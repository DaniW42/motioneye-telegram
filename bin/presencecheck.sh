#!/bin/bash

## get my current directory
var_binDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

## Get the name of the motioneye-telegram project directory
var_projectDir="$var_binDir"/..

## Read Configuration-File so we have the variables available
source $var_projectDir/telegram.conf
var_confFile="$var_projectDir/telegram.conf"

function func_pingDevices () {
  ## loop through var_pingDevices array and return 0 if at least one ping was successful
   for i in "${var_pingDevices[@]}"
   do
     if /usr/sbin/arping -c 5 $i > /dev/null
     then
       return 0
     fi 
   done

   return 1
}

function func_setVarPingFail() {
	func_pingDevices && var_pingFail="0" || ((var_pingFail++))
}

function func_setVarDeviceAvailable() {
	[[ $var_pingFail -ge 3 ]] && var_deviceAvailable="false" || var_deviceAvailable="true"
}

func_setVarPingFail
func_setVarDeviceAvailable

sed -i "s/var_pingFail=.*$/var_pingFail='$var_pingFail'/" $var_confFile
sed -i "s/var_deviceAvailable=.*$/var_deviceAvailable='$var_deviceAvailable'/" $var_confFile

exit 0
