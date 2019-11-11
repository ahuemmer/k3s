#!/bin/bash
set +x
set +e

echo "Starten der Abfrage"
for i in $(nmap -sL 192.168.1.0/24 |grep Nmap | grep pi | cut -d" " -f 5 | cut -d"." -f 1 | sort -u)
do
	echo Bearbeite Pi $i
	ssh $i -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no docker ps
	echo "------------------------------------"
done

echo && echo fertig.
exit 0
