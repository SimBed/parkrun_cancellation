### Receive notification if Park Run is cancelled.
Scrape public website.  
Review for cancellation.  
If cancelled, issues notifications.  
Record notifications have been issued (if so).  
Set up cron job locally for automation.

```
30 12-23 * * Fri ~/parkrun/bin/cancellation_monitor >> ~/parkrun/bin/log.txt 2>&1<br>
0 7-8 * * Sat ~/parkrun/bin/cancellation_monitor >> ~/parkrun/bin/log.txt 2>&1
```
set configurations in .env<br>
create .env.secrets in root

```
### whatsapp
TWILIO_ACCOUNT_SID=
TWILIO_AUTH_TOKEN=
TWILIO_WHATSAPP_NUMBER=
ME=whatsapp number

### email
GMAIL_API_KEY=
EMAIL_FROM=
EMAIL_TO=
```

from project root:
```
$ ./bin/cancellation_monitor
```

<img src="parkrun.svg" alt="demo image" width="300"><br>