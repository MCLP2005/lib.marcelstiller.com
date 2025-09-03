#!/bin/bash

/root/lib.marcelstiller.com/internal_scripts/rss/daily-haiku.sh -d /var/www/html -f daily-haiku.xml "You write one haiku about the day $(date +"%F"). You only reply with the haiku you've generated. There should never be any other contents, title(s) or formatting in your reply"
