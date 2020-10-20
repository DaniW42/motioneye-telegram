#!/bin/bash

## check for root privileges
if [[ "$EUID" -ne 0 ]]; then
  echo "Please run as root" >&2
  exit 1
fi

## get current path to be set as directory in cron
var_scriptDir="$(
	cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null \
	&& pwd
)"

## where we place the cron job
var_cronFile="/etc/cron.d/motioneye-telegram"
var_defaultNewCron="y"

cat <<-INTRO
	About to install /etc/cron.d/motioneye-telegram with content:"
	##################################################################
	* * * * * root $var_scriptDir/bin/presencecheck.sh &>/dev/null    
	##################################################################

INTRO

## ask user to press corresponding key
read -n1 -p "Create new cronjob? [Y/n]: " var_NewCron
: ${var_NewCron:=$var_defaultNewCron}
echo

## run action based on users choice
case ${var_NewCron,,} in
	## [y] create new config file or [n] simply quit.
	y)
		echo "Ok, I will create new cronjob."
		touch $var_cronFile
		echo "* * * * * root $var_scriptDir/bin/presencecheck.sh &>/dev/null" > $var_cronFile

		## check if file was created and either exit or report error
		test $var_cronFile && echo "Successful, end script."
		exit 0 || echo "Hmmm.. Something went wrong, no file created...";
		exit 1
	;;
	n)
		echo "You selected to not create new cronjob."
		echo "That is Ok, but you have to do this on your own. See ya!"
		exit 0
	;;
	*)
		echo "Wrong answer given. Abort install." >&2
		exit 1
	;;
esac

exit $?
