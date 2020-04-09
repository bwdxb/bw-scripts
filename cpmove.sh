#!/bin/bash
# Script to create cPanel backups and copy to a remote server
# For security purposes, assumes you have enabled ssh key based authentication between servers.
# Written by Mark Railton - markrailton.com - github.com/railto

# Variables to make script easier to configure for your needs
threshold="3.00" # Load threshold above which backups will not run
check="10" # Time in seconds between load checks when above threshold

#  Check server load and only run if below threshold

while [ 1 ]; do
        load=`cat /proc/loadavg | awk '{print $1}'`
        if [ ${load%%.*} -ge ${threshold%%.*} ]; then
                echo "Server load too high, trying again in $check seconds"
                sleep $check
        else
                echo "Server load below threshold, running backup"
                break
        fi
done


# Backup all accounts

echo ""
echo "Creating backup files"
echo ""
ls /var/cpanel/users/ | while read account; do
/scripts/pkgacct --skiphomedir --skipmysql $account /home/z-cpmove/
echo ""
echo "Backup for $account created"
echo ""
done


echo "The cpmove finished on `date` on $HOSTNAME " | mail -s " $HOSTNAME cpmove finished " logs@bw.ae
# Backup complete, exit
exit 0