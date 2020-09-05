#!/bin/bash

## set directories
var_scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
var_logFile="$var_scriptDir/motion-send.log"
var_cronFile="/etc/cron.d/motioneye-telegram"

func_writeLog () {
	printf '%s\n' "$1" >> $var_logFile
}

func_writeConsole () {
	printf '%s\n' "$1"
	printf '%s\n' "$1" >> $var_logFile
}

if [[ "$EUID" -ne 0 ]]; then
  func_writeConsole "Please run as root"
  exit 1
else
  func_writeConsole "\n\nAbout to install /etc/cron.d/motioneye-telegram with content."
  func_writeLog ""
  func_writeLog "##################################################################"
  func_writeLog "* * * * * root $var_scriptDir/bin/presencecheck.sh >/dev/null 2>&1"
  func_writeLog "##################################################################"
  func_writeLog ""

  var_defaultNewCron="y"
  read -p "Create new cronjob? [Y/n]: " var_NewCron
  : ${var_NewCron:=$var_defaultNewCron}

  case $var_NewCron in
  ## [y] create new config file or [n] simply quit.
    [yY] | [yY][eE][sS] )
      func_writeConsole "Ok, I will create new cronjob."
      touch $var_cronFile
      echo "* * * * * root $var_scriptDir/bin/presencecheck.sh >/dev/null 2>&1" > $var_cronFile
      test $var_cronFile && func_writeConsole "Successful, end script."; exit 0 || func_writeConsole "Hmmm.. Something went wrong, no file created..."; exit 1
      ;;

    [nN] | [nN][oO] )
      func_writeConsole "You selected to not create new cronjob."
      func_writeConsole "That is Ok, but you have to do this on your own. See ya!"
      exit 0
      ;;

    *)
      func_writeConsole "Wrong answer given. Abort install."
      exit 1
      ;;
  esac
fi

exit 1
