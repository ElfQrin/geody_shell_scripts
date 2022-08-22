#!/bin/bash

# Log This
# r2022-08-22 fr2017-06-21
# by Valerio Capello - https://labs.geody.com/ - License: GPL v3.0


# Config

tlogen=true; # Enable logs
ech1=true; # Echo logged line to console
tlogfndef="/var/log/logthis"; # Default Log path and file name (if not passed as a parameter)
tlogfndyy=true; # Append Year to log file name
tlogfndext='.log'; # File name extension for file names with a date (it will be added only if a date is appended to file name)
tlogedt=true; # Add date and time to log entries
tlogeip=true; # Add IP address to log entries
tlogeidmach=false; # Add Machine ID to log entries
tlogeidboot=false; # Add Boot ID to log entries
tlogelbootdt=true; # Add Last Boot Date and Time to log entries
logsep=" "; # Separator between elements
logelst=""; # Element Start
logelen=""; # Element End
logeltxtst=''; # Log Text Element Start
logeltxten=''; # Log Text Element End
ttest=false; # Test Mode (doesn't actually write to the file)


# Get Parameters

if [ $# -eq 1 ]; then
tlogfn=$tlogfndef;
logthis=$1; # Log text
elif [ $# -eq 2 ]; then
tlogfn=$1; # Log path and file name (destination directory must exists and be writeable)
logthis=$2; # Log text
else
echo "Log This";
echo 'Usage: log [/path/filename] "TEXT"';
echo ;
echo "Example:";
echo 'log "Lorem Ipsum"';
echo 'log /var/log/logthis.log "Lorem Ipsum"';
exit 1;
fi


# Main

if ( ! $tlogen ); then echo "Logging is disabled"; exit 1; fi
if [ -z "$tlogfn" ]; then tlogfn=$tlogfndef; fi
if ( $tlogfndyy ); then tlogfn="${tlogfn}_$(date '+%Y')${tlogfndext}"; fi
if ( $tlogedt ); then
ctdt="$logelst$(date '+%F %T')$logelen$logsep"
else
ctdt=""
fi
if ( $tlogeip ); then
ctip="$logelst`echo $SSH_CLIENT | awk '{print $1}'`$logelen$logsep"
else
ctip=""
fi
if ( $tlogeidmach ); then
ctidmach="$logelst$(cat /etc/machine-id)$logelen$logsep"
else
ctidmach=""
fi
if ( $tlogeidboot ); then
ctidboot="$logelst$(cat /proc/sys/kernel/random/boot_id)$logelen$logsep"
else
ctidboot=""
fi
if ( $tlogelbootdt ); then
ctlbootdt="$logelst$(uptime -s)$logelen$logsep"
else
ctlbootdt=""
fi
ous="$ctdt$ctlbootdt$ctip$ctidmach$ctidboot$logeltxtst$logthis$logeltxten";
if ( $ech1 ); then
echo "Log to $tlogfn"
echo $ous
fi
if ( ! $ttest ); then
echo $ous >> $tlogfn ;
else
echo "TEST MODE ON: LOG NOT WRITTEN ON FILE.";
fi
