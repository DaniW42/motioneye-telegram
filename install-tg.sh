#!/bin/bash

## set directories
var_scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
var_logFile="$var_scriptDir/motion-send.log"
var_confFile="$var_scriptDir/telegram.conf"

## BEGIN Functions
function func_getGitHubConf () {
## Get fresh config file from github and save as (parameter 1)

	wget -q https://raw.githubusercontent.com/DaniW42/motioneye-telegram/master/telegram.conf.original -O $1
}

function func_readLocalConf () {
## Read Configuration-File so we have the variables available

	source $var_scriptDir/telegram.conf
}

function func_sendTestMessage () {
	curl -s -X POST \
		 -H 'Content-Type: application/json' \
		 -d '{"chat_id": '$var_chatId', "text": "test", "disable_notification": true}' \
		 https://api.telegram.org/bot$var_botApiKey/sendMessage > /dev/null
}

function func_clearScreen () {
## Clear Screen

	clear -x
}

function func_writeLog () {
## write to stdout and pipe-tee to logfile

	printf '%s\n' "$1" | tee -a $var_logFile
}

function func_isVarEmpty () {
## check if given variable is empty, (first) parameter is the variable (e.g. $var_chatId)

	[ -z "$1" ]
}

function func_isArrayEmpty () {
## check if given array is empty, (first) parameter is the variable (e.g. $var_pingDevices)

	myArray=("$@")
	[ ${#myArray[@]} -eq 0 ]
}

function func_setConfVar () {
	while :
	do
		echo ""; read -p "$1" userinput
		if func_isVarEmpty $userinput
		then
			func_isVarEmpty $3 && echo "Error" || break
		else
			printf -v $2 "$userinput"
			break
		fi
	done
}

function func_setConfArray () {
	while :
	do
		echo ""; read -p "Please enter your IP-Addresses (Currently: ${var_pingDevices[*]}): " userinput
		if func_isVarEmpty $userinput
		then
			if func_isArrayEmpty "${var_pingDevices[@]}"
			then
				echo "Error!"
			else
				break
			fi
		else
			var_pingDevices+=("$userinput")
			func_writeLog "IP-Addresses: <$userinput> "
		fi
	done
}
## END Functions

func_readLocalConf

func_clearScreen

func_writeLog ""
func_writeLog "################################################################################################"
func_writeLog "################################################################################################"
func_writeLog ""

## Check for config file, if not found wget it from github, if found check version and ask user to update
if [ ! -f "telegram.conf" ]
then
	func_writeLog "I was unable to find telegram.conf file!"
	func_writeLog "This is why I decided to get you a new one from github ;-)"
	func_getGitHubConf telegram.conf
	func_readLocalConf
else
	func_writeLog "Found telegram.conf, checking version."
	var_GitConfVersion="$(curl --silent https://raw.githubusercontent.com/DaniW42/motioneye-telegram/master/telegram.conf.original | grep ConfVersion | cut -d '=' -f 2)"
	if [[ "$var_GitConfVersion" == "$var_ConfVersion" ]]
	then
		func_writeLog "- Local Config-File Version matches GitHub Version, nothing to update."
	else
		func_writeLog "- Config-File Version mismatch, local version: $var_ConfVersion => GitHub version: $var_GitConfVersion."
		func_writeLog "- So we have to update your config file. If you want to do this now we have to go through the 'whole process'."
		func_writeLog ""

		var_defaultNewConf="y"
		read -p "Create new telegram.conf? [Y/n]: " var_NewConf
		: ${var_NewConf:=$var_defaultNewConf}

		case $var_NewConf in
		## [y] create new config file or [n] simply quit.
			[yY] | [yY][eE][sS] )
				func_writeLog "Ok, I will process values and backup 'old' config, then get a clean file from GitHub."
				func_readLocalConf
				mv $var_scriptDir/telegram.conf $var_scriptDir/telegram.conf.bak
				func_getGitHubConf $var_scriptDir/telegram.conf
				;;

			[nN] | [nN][oO] )
				func_writeLog "You selected to not create an updated config file now."
				func_writeLog "That is Ok, but you have to download it or make yours to work on your own. See ya!"
				;;

			*)
				func_writeLog "Wrong answer given. Abort install."
				exit 1
				;;
		esac
	fi
fi

## set apiKey
func_setConfVar "Please enter your Api Key (Currently: $var_botApiKey): " var_botApiKey $var_botApiKey
func_writeLog "apiKey: <$var_botApiKey> "


## set chatId
func_setConfVar "Please enter your Chat_id (Currently: $var_chatId): " var_chatId $var_chatId
func_writeLog "chatId: <$var_chatId> "


## set IP-Addresses
func_setConfArray
func_writeLog "IP-Addresses: <${var_pingDevices[*]}>"

func_writeLog ""
func_writeLog "Let's see if we can send a test message to your Telegram."
func_sendTestMessage
func_writeLog "You should have recieved a test message in Telegram."
func_writeLog ""

## ask user if we should save the variables to the config file
var_defaultSave="y"
read -p "Write current configuration to telegram.conf? [Y/n]: " var_confSave
: ${var_confSave:=$var_defaultSave}

case $var_confSave in
	[yY] | [yY][eE][sS] )
		func_writeLog "Ok, saving current configuration, bye."
		sed -i "s/var_botApiKey=.*$/var_botApiKey='$var_botApiKey'/" $var_confFile
		sed -i "s/var_chatId=.*$/var_chatId='$var_chatId'/" $var_confFile
		sed -i "s/var_pingDevices=.*$/var_pingDevices=(${var_pingDevices[*]})/" $var_confFile
		sed -i "s/LastConfigSave=.*$/LastConfigSave='$(date)'/" $var_confFile
		;;

	[nN] | [nN][oO] )
		func_writeLog "Ok, not saving current configuration."
		;;

	*)	func_writeLog "Wrong answer given. Abort install."
		;;
esac


func_writeLog ""
func_writeLog "################################################################################################"
func_writeLog "################################################################################################"
func_writeLog ""

exit 0
