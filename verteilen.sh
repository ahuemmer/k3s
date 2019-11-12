#!/bin/bash
set +x
set +e

echo "Starten der Worker auf den Clients"

# for i in $(nmap -sL 192.168.1.0/24 |grep Nmap | grep pi | cut -d" " -f 5 | cut -d"." -f 1 | sort -u)
for i in pi2 pi3 pi4
do
	echo Bearbeite Pi $i
	ssh $i -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no rm -rf /home/pi/k3s
	scp $i -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no git clone https://github.com/frickler24/k3s
done

exit 0
