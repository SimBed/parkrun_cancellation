# require "active_support/core_ext/time"
require 'active_support/all'
require 'httparty'
require 'json'
require_relative 'secrets.rb'
require_relative 'twilio_message.rb'
require 'byebug'

class Octopus
  attr_reader :url_leccy, :url_gas
  def initialize(octopus, twilio)
    octopus.merge(twilio).each do |k,v|
      instance_variable_set("@#{k}", v)
    end
    @test = true
  end
  
  def set_urls
    period_from = Time.now.advance(days: -7).strftime('%Y-%m-%dT00:00:00Z')
    @url_leccy = "https://api.octopus.energy/v1/electricity-meter-points/#{@electricity_mpan}/meters/#{@electricity_meter}/" \
                 "consumption?period_from=#{period_from}&group_by=day"
    @url_gas = "https://api.octopus.energy/v1/gas-meter-points/#{@gas_mprn}/meters/#{@gas_meter}/" \
               "consumption?period_from=#{period_from}&group_by=day"
  end

  def get_results(url)
    response = HTTParty.get(url, { basic_auth: { username: @api_key, password: '' } })
    JSON.parse(response.body)['results']
    # [{"consumption"=>0.267, "interval_start"=>"2024-11-30T00:00:00Z", "interval_end"=>"2024-12-01T00:00:00Z"}, {"consumption"=>0.284, "interval_start"=>"2024-11-29T00:00:00Z",.... 
  end

  def results_process(response)
    results = {}
    response.each { |r| results[Date.parse(r['interval_start']).strftime('%d %b %y')] = r['consumption'] }
    results
    # {"30 Nov 24"=>1.8, "29 Nov 24"=>2.074, "28 Nov 24"=>2.066, "27 Nov 24"=>1.679, "26 Nov 24"=>1.28, "25 Nov 24"=>0.432}
  end

  def alert_check
    set_urls
    json_response_results_leccy = get_results(url_leccy)
    todays_leccy_consumption = json_response_results_leccy.first['consumption']
    @alert_leccy = todays_leccy_consumption > 0.29

    json_response_results_gas = get_results(url_gas)
    last_day = Date.parse(json_response_results_gas.first['interval_start']).strftime('%A, %d %B')
    last_day_gas_consumption = json_response_results_gas.first['consumption']
    results_gas = results_process(json_response_results_gas)
    week_gas_average = (results_gas.values.sum(0.0) / results_gas.values.size)
    @alert_gas = last_day_gas_consumption > 1.2 * week_gas_average
    send_warning(last_day, 0.29.to_s, todays_leccy_consumption.round(2).to_s, week_gas_average.round(2).to_s, last_day_gas_consumption.round(2).to_s) if alert
    # send_warning('Monday, 14 Jan', '2.0', '2.5', '1.5', '2.0')
  end

  def send_warning(date, leccy_normal, leccy_actual, gas_average, gas_actual)
    TwilioMessage.new(content_sid: 'HX1a9baa0af51441b2e3ab2329c7e72804',
                      content_variables: { '1': date,
                                            '2': leccy_normal,
                                            '3': leccy_actual,
                                            '4': gas_average,
                                            '5': gas_actual }).send_whatsapp
  end

  private
  def alert
    @alert_leccy || @alert_gas || @test
  end

end


