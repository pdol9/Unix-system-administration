#!/bin/bash

# save boot time in minutes and seconds
BOOT_MIN=$(uptime -s | cut -d ":" -f 2)
BOOT_SEC=$(uptime -s | cut -d ":" -f 3)

#  3min from 43rd minute % 10 * 60 + secs from boot time
DELAY_CRON=$(bc <<< $BOOT_MIN%10*60+$BOOT_SEC)

sleep $DELAY_CRON
