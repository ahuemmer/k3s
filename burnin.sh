#!/bin/bash

MAXRUNS=1000000

# PAGE=test.php
PAGE=mandel.php

singleBurn() {
	echo $NODES
	for p in $NODES
	do
			echo $p
			(curl -s http://$p:30666/$PAGE | wc -c ; echo $p) &
	done

	echo "Wait for completion"
	wait
	echo "-----------------------"
}

# export NODES="$(nmap -sL 192.168.1.0/24 |grep Nmap | grep pi | cut -d" " -f 5 | cut -d"." -f 1 | sort -u | tr '\n' ' ')"
export NODES="$(kubectl get pods -Ao wide | grep phpngx | sed "s/  */ /g" | cut -d" " -f 8 | sort -u | tr '\n' ' ')"

for i in $(eval echo "{1..$MAXRUNS}");
do
	echo starte Durchlauf $i
	singleBurn
done



