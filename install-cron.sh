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

func_chooseLanguage () {
	var_languages=($(ls -1 $var_scriptDir/languages/ | sed -e 's/\.lang$//'))
	counter=0
	
	echo ""
	echo "Choose your language:"
	for i in "${var_languages[@]}"
	do
	:
	echo "$counter: $i"
	counter=$[counter + 1]
	done
	
	echo ""
	
	
	var_defaultLanguage="0"
	read -p "Which language do you prefer? (Default is ${var_languages[$var_defaultLanguage]}): " var_userChoice
	: ${var_userChoice:=$var_defaultLanguage}
	source $var_scriptDir/languages/${var_languages[$var_userChoice]}".lang"
	
	echo $var_chosenLanguage
	
	echo ""
}

func_chooseLanguage

if [[ "$EUID" -ne 0 ]]; then
  func_writeConsole "$var_runAsRootText"
  exit 1
else
  func_writeConsole "$var_startInstallCronText"
  func_writeLog ""
  func_writeLog "##################################################################"
  func_writeLog "* * * * * root $var_scriptDir/bin/presencecheck.sh >/dev/null 2>&1"
  func_writeLog "##################################################################"
  func_writeLog ""

  var_defaultNewCron="y"
  read -p "$var_createCronjobText" var_NewCron
  : ${var_NewCron:=$var_defaultNewCron}

  case $var_NewCron in
  ## [y] create new config file or [n] simply quit.
    [yY] | [yY][eE][sS] )
      func_writeConsole "$var_startCreatingCronjobText"
      touch $var_cronFile
      echo "* * * * * root $var_scriptDir/bin/presencecheck.sh >/dev/null 2>&1" > $var_cronFile
      test $var_cronFile && func_writeConsole "$var_successfullText"; exit 0 || func_writeConsole "$var_errorText2"; exit 1
      ;;

    [nN] | [nN][oO] )
      func_writeConsole "$var_selectedNoText"
      func_writeConsole "$var_installItYourselfText"
      exit 0
      ;;

    *)
      func_writeConsole "$var_wrongInputText"
      exit 1
      ;;
  esac
fi

exit 1
