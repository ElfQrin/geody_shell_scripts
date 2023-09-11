#!/bin/bash

# sservice
xver='r2023-09-11 f2023-09-07';
# by Valerio Capello - http://labs.geody.com/ - License: GPL v3.0


# Config

shwdate=true; # Show date
servicesdefault=('apache2' 'tor' 'mysql'); # Services default (if no services are passed from the command line)
servicessortaz=false; # Sort services in alphabetical order (a-z)
servicestoporder=1; # Services Stop order: 1: First to Last, 2: Last to First
servicestartorder=2; # Services Start order: 1: First to Last, 2: Last to First
servicemanager=4; # Service Manager: 1: SysVInit service, 2: SysVInit init.d, 3: SystemD with path (/bin/systemctl), 4: SystemD without path (systemctl)
dotservice=""; # SystemD .service: use dotservice=".service" to force .service after the service name, otherwise let systemctl deal with it automatically (recommended)
stopterm=true; # Term Service after Stopping it, shouldn't it stop.
stoptermtime=90; # Time in seconds to Term a program if it hasn't stopped.
stoptermkill=true; # Term Service after Stopping it, shouldn't it stop.
stoptermkilltime=30; # Time in seconds (after stoptermtime) to Kill a program if it hasn't stopped nor terminated (requires stopterm=true).
stopkillanyway=false; # Kill any still existing process with the service name.


# Functions

getservices() {
if [ $# -gt 1 ]; then
services=( "$@" ); unset services[0];
else
echo "No services given. Using default settings.";
if [ -n "$servicesdefault" ]; then
services=(${servicesdefault[@]});
else
echo "No services given and no default settings specified.";
fi
listservices ', '; echo;
fi
}

listservices() {
local sep="$1";
if [ -z "$sep" ]; then sep=', '; fi
if [ ${#services[@]} -gt 0 ]; then
i=0;
for service in "${services[@]}"
do
((++i))
if [[ "$sep" == '\n' ]]; then
echo "${i}. ${service}";
else
echo -n "${i}. ${service}";
if [ $i -lt ${#services[@]} ]; then echo -n "${sep}"; else echo; fi
fi
done
else
echo 'No services given.';
fi
}

printservicemanager() {
echo -n "Service Manager selected: ";
case $servicemanager in
'1')
echo "SysVInit service";
;;
'2')
echo "SysVInit init.d";
;;
'3')
echo "SystemD with path (/bin/systemctl)";
;;
'4')
echo "SystemD (systemctl)";
;;
*)
echo "Service Manager not specified.";
;;
esac
}

servicedo() {
local service="$1";
if [ -z "$service" ]; then echo "Error: No Service given."; exit 1; fi
local servaction="$2";

case $servicemanager in
'1')
servicedocmd="service ${service} ${servaction}";
;;
'2')
servicedocmd="/etc/init.d/${service} ${servaction}";
;;
'3')
servicedocmd="/bin/systemctl ${servaction} ${service}${dotservice}";
;;
'4')
servicedocmd="systemctl ${servaction} ${service}${dotservice}";
;;
*)
servicedocmd="";
echo "Service Manager not specified. Qutting.";
exit 0;
;;
esac

if [[ "$servaction" == "stop" ]]; then
if ( $stopterm ); then
if ( $stoptermkill ); then
local stoptermkillpar="-k ${stoptermkilltime} ";
else
local stoptermkillpar="";
fi
local timeoutcmd="timeout -v ${stoptermkillpar}${stoptermtime} "; # local timeoutcmd="timeout";
else
local timeoutcmd="";
fi
servicedocmd="${timeoutcmd}${servicedocmd}";
fi

# echo "${servicedocmd}";
}

servicestop() {
if [ $# -gt 0 ]; then
local service="$1";
echo "Stopping $service";
servicedo "$service" "stop";
# echo $servicedocmd;
$servicedocmd;
if ( $stopkillanyway ); then
pgrep $service | xargs kill -9 ;
fi
else
echo "No service argument given.";
fi
}

servicestart() {
if [ $# -gt 0 ]; then
local service="$1";
echo "Starting $service";
servicedo "$service" "start";
# echo $servicedocmd;
$servicedocmd;
else
echo "No service argument given.";
fi
}

apphelp() {
echo "Usage:";
echo "sservice COMMAND [SERVICE1 [SERVICE 2] [SERVICE ...]]";
echo;
echo "Commands:";
echo;
echo "--help     # Display this help";
echo "--version  # Display version information";
echo "--list     # List all services";
echo "--status   # Display status for all services";
echo "--start    # Start all services";
echo "--stop     # Stop all services";
echo "--restart  # Restart (Stop / Start) all services";
echo;
echo "Example:";
echo "sservice --restart apache2 tor mysql";
echo;
echo "Note:"
echo "If no services are passed as arguments, default services will be used. Use sservice --list without further arguments to see default services.";
}


# Main

echo "SService by Valerio Capello - http://labs.geody.com/ - $xver";

if ( $shwdate ); then
echo; echo -n "Date: ";
date "+%a %d %b %Y %H:%M:%S %Z (UTC%:z)";
fi

echo; printservicemanager;

echo;

if ( $servicessortaz ); then
IFS=$'\n' services=($(sort <<<"${services[*]}")); unset IFS;
fi

if [ $# -gt 0 ]; then
action=$1; # Action
action=$( echo "$action" | tr '[:upper:]' '[:lower:]' );

case $action in
'--help')
apphelp;
exit 0;
;;
'--ver'|'--version')
echo "Version: $xver";
exit 0;
;;
'--list')
getservices "$@";
echo "Services:"; echo;
listservices '\n';
exit 0;
;;
'--status')
getservices "$@";
echo "Status:"; echo;
if [ ${#services[@]} -gt 0 ]; then
for service in "${services[@]}"
do
echo "${service}:";
servicedo "$service" "status";
# echo "$servicedocmd";
$servicedocmd | head --lines=1 ; $servicedocmd | grep "Loaded:\|Active:\|Main PID:\|Memory:\|CPU:" | awk '{sub(/^[ \t]+/, "")};1' ; echo;
done
else
echo 'No services given. Nothing to do.';
fi
exit 0;
;;
'--stop')
getservices "$@";
echo "Stop services:"; echo;
if [ ${#services[@]} -gt 0 ]; then
case $servicestoporder in
1)
for service in "${services[@]}"
do
servicestop ${service};
done
exit 0;
;;
2)
arridx=( ${!services[@]} )
for ((i=${#arridx[@]} - 1; i >= 0; i--)) ; do
service=${services[arridx[i]]};
servicestop ${service};
done
exit 0;
;;
*)
echo "Stop order not specified. Can't stop services.";
exit 0;
;;
esac
else
echo 'No services given. Nothing to do.';
fi
exit 0;
;;
'--start')
getservices "$@";
echo "Start services:"; echo;
if [ ${#services[@]} -gt 0 ]; then
case $servicestartorder in
1)
for service in "${services[@]}"
do
servicestart ${service};
done
exit 0;
;;
2)
arridx=( ${!services[@]} )
for ((i=${#arridx[@]} - 1; i >= 0; i--)) ; do
service=${services[arridx[i]]};
servicestart ${service};
done
exit 0;
;;
*)
echo "Start order not specified. Can't start services.";
exit 0;
;;
esac
else
echo 'No services given. Nothing to do.';
fi
exit 0;
;;
'--restart')
getservices "$@";
echo "Restart services:"; echo;
if [ ${#services[@]} -gt 0 ]; then
case $servicestoporder in
1)
for service in "${services[@]}"
do
servicestop ${service};
done
;;
2)
arridx=( ${!services[@]} )
for ((i=${#arridx[@]} - 1; i >= 0; i--)) ; do
service=${services[arridx[i]]};
servicestop ${service};
done
;;
*)
echo "Stop order not specified. Can't stop services.";
exit 0;
;;
esac
case $servicestartorder in
1)
for service in "${services[@]}"
do
servicestart ${service};
done
exit 0;
;;
2)
arridx=( ${!services[@]} )
for ((i=${#arridx[@]} - 1; i >= 0; i--)) ; do
service=${services[arridx[i]]};
servicestart ${service};
done
exit 0;
;;
*)
echo "Start order not specified. Can't start services.";
exit 0;
;;
esac
else
echo 'No services given. Nothing to do.';
fi
exit 0;
;;
*)
echo 'Command unknown. Nothing to do.';
exit 0;
;;
esac

else
echo "No command given. Nothing to do.";
fi
