#!/bin/bash

## git-updatecheck.sh is based on a script by Christian Engvall https://www.christianengvall.se/check-for-changes-on-remote-origin-git-repository/

ACTION='\033[1;90m'
FINISHED='\033[1;96m'
READY='\033[1;92m'
NOCOLOR='\033[0m' # No Color
ERROR='\033[0;31m'

function func_updateRepo () {
	echo
	echo -e ${ACTION}Updating Git repo
	echo -e =======================${NOCOLOR}
	git pull
}

function func_checkBranch () {
	echo
	echo -e ${ACTION}Checking Git branch
	echo -e =======================${NOCOLOR}
	BRANCH=$(git rev-parse --abbrev-ref HEAD)
	if [ "$BRANCH" != "testing" ]
	then
		echo -e ${ERROR}Not on testing. Aborting. ${NOCOLOR}
		echo
		exit 1
	else
		echo -e ${READY}We are on $BRANCH. ${NOCOLOR}
		echo
	fi
}

function func_updatecheckMain () {
	echo
	echo -e ${ACTION}Fetching Git repo
	echo -e =======================${NOCOLOR}
	git fetch
	HEADHASH=$(git rev-parse HEAD)
	UPSTREAMHASH=$(git rev-parse testing@{upstream})

	if [ "$HEADHASH" != "$UPSTREAMHASH" ]
		then
		echo -e ${ERROR}Not up to date with origin.${NOCOLOR}

		echo
		var_defaultUpdateRepo="y"
		read -p "Update Repository from GitHub? [Y/n]: " var_UpdateRepo
		: ${var_UpdateRepo:=$var_defaultUpdateRepo}

		case $var_UpdateRepo in
		## [y] create new config file or [n] simply quit.
			[yY] | [yY][eE][sS] )
				func_updateRepo
				func_updatecheckMain
				;;

			[nN] | [nN][oO] )
				echo -e ${ERROR}You selected not to update local repository. ${NOCOLOR}
				echo -e ${FINISHED}That is Ok, but you have to do this on your own! ${NOCOLOR}
				echo
				read -n1 -r -p "Press any key to continue..." var_key
				exit 0
				;;

			*)
				echo -e ${ERROR}Unsupported answer given. Abort install. ${NOCOLOR}
				echo
				exit 1
				;;
		esac

	echo
	exit 0
	else
	echo -e ${FINISHED}Current branch is up to date with origin/testing. ${NOCOLOR}
	sleep 2
	fi
}

## Before starting I want to check so that I have the testing branch checked out. Since thats the branch i want to deploy from.

func_checkBranch

## After that we can get the latest commit hash from our branch by running git rev-parse HEAD. Then to get the latest commit hash 
## from the origin we run git rev-parse testing@{upstream} and compare these two. If they do not match there is either changes in 
## the origin testing, or you haven’t pushed the latest local commit to origin testing.

func_updatecheckMain