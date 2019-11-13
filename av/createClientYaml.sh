#!/bin/bash

echo -n "Bitte Teamnamen eingeben: "
read teamname

echo -n "Bitte Spielernamen eingeben: "
read playername

team_technical=$(echo ${teamname} | tr -d "[:blank:]" | tr -cd "[:alnum:]" | tr "[:upper:]" "[:lower:]" )
player_technical=$(echo ${playername} | tr -d "[:blank:]" | tr -cd "[:alnum:]" | tr "[:upper:]" "[:lower:]" )
uniquename="${team_technical}-${player_technical}"

playername=$(echo ${playername} | sed "s/\\\"/'/g")
teamname=$(echo ${teamname} | sed "s/\\\"/'/g")

(cat .av-client.template.yaml | sed "s/%TEAMNAME%/${teamname}/g" | sed "s/%SPIELERNAME%/${playername}/g" | sed "s/%UNIQUENAME%/${uniquename}/g" > av-client.yaml) && echo "av-client.yaml erfolgreich erstellt."
