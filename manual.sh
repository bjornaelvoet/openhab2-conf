#!/bin/bash

if [[ $# -eq 0 ]] ; then
    echo Usage: ./manual.sh -e 123 -g 456 -w 789.123
    exit 0
fi

#Used of red coloring of echo error messages
red=`tput setaf 1`
reset=`tput sgr0`

while getopts e:g:w: option
do
case "${option}"
in
e) ELECTRICITY=${OPTARG};;
g) GAS=${OPTARG};;
w) WATER=${OPTARG};;
esac
done

echo Sending given values to openHAB
echo Electricity: $ELECTRICITY
echo Gas: $GAS
echo Water: $WATER

curl -s --header "Content-Type: text/plain" --request PUT --data "$ELECTRICITY" http://openhab.aelvoetnet.be:8080/rest/items/Usage_Electricity_Total/state
curl -s --header "Content-Type: text/plain" --request PUT --data "$GAS" http://openhab.aelvoetnet.be:8080/rest/items/Usage_Gas_Total/state
curl -s --header "Content-Type: text/plain" --request PUT --data "$WATER" http://openhab.aelvoetnet.be:8080/rest/items/Usage_Water_Total/state

echo Reading back out the values
ELECTRICITY_WRITTEN=$(curl -s http://openhab.aelvoetnet.be:8080/rest/items/Usage_Electricity_Total/state)
GAS_WRITTEN=$(curl -s http://openhab.aelvoetnet.be:8080/rest/items/Usage_Gas_Total/state)
WATER_WRITTEN=$(curl -s http://openhab.aelvoetnet.be:8080/rest/items/Usage_Water_Total/state)

echo Checking written values with given values
if [ "$ELECTRICITY_WRITTEN" = "$ELECTRICITY" ]
then
	#Everything OK
	echo Electricity OK
else
	echo "${red}Electricity written value $ELECTRICITY_WRITTEN not equal to given value $ELECTRICITY${reset}"
fi

if [ "$GAS_WRITTEN" = "$GAS" ]
then
	#Everything OK
	echo Gas OK
else
	echo "${red}Gas written value $GAS_WRITTEN not equal to given value $GAS${reset}"
fi
if [ "$WATER_WRITTEN" = "$WATER" ]
then
	#Everything ok
	echo Water OK
else
	echo "${red}Water written value $WATER_WRITTEN not equal to given value $WATER${reset}"
fi
echo Done
