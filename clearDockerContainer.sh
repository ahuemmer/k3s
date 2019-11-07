#!/bin/bash

LISTE=`ssh $1 docker ps -aq`

if [[ -z "$LISTE" ]]; then
	echo "Keine Container gefunden zum löschen, weiter."
else
	ssh $1 docker rm -f $LISTE
fi

