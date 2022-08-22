#!/bin/bash

# aptup
xver='r2021-08-14 fr2021-08-14';
# by Valerio Capello - http://labs.geody.com/ - License: GPL v3.0


# Config

shwdate=true; # Show Date
shwsrclist=false; # Show sources list
shwspackcnt=true; # Show installed packages count
shwspacklast=true; # Show last installed packages
shwspackmax=5; # Last installed packages output limit
checkbroken=true; # Check for incorrect installations and broken dependencies


# Main

echo "AptUp by Valerio Capello - http://labs.geody.com/ - $xver";
if ( $shwdate ); then
echo; echo -n "Date: "; date "+%a %d %b %Y %H:%M:%S %Z (UTC%:z)";
fi
if ( $shwspackcnt ); then
echo; echo -n "Installed packages: "; dpkg --get-selections | wc -l;
fi
if ( $shwspacklast ); then
echo; echo "Last installed packages:"; grep install /var/log/dpkg.log | tail -$shwspackmax;
fi
if ( $checkbroken ); then
echo; echo "Check for incorrect installations and broken dependencies:"; dpkg --audit ; apt-get check ;
fi
if ( $shwsrclist ); then
echo; echo "Package sources list:"; cat /etc/apt/sources.list ; # | grep 'deb \|deb-src ' ;
fi
echo; echo "Dowloading package information:"; apt update ;
upacks="$( apt-get -s upgrade | tail --lines=1 ; )";
if [[ "$upacks" != "0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded." ]]; then
echo; echo "Updated packages:"; apt list --upgradable ;
echo; echo "Simulated Upgrade:"; apt -s upgrade ;
else
echo $upacks ;
fi