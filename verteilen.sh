#!/bin/bash
set +x
set +e

echo "Verteile Wichtiges auf den Clients"

for i in $(nmap -sL 192.168.1.0/24 |grep Nmap | grep pi | cut -d" " -f 5 | cut -d"." -f 1 | sort -u)
# for i in pi2 pi3 pi4
do
	echo Bearbeite Pi $i
	# ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $i rm -rf /home/pi/{k3s,client.log,k8s}
	ssh $i rm -rf /home/pi/{k3s,client.log}
	ssh $i git clone https://github.com/frickler24/k3s
	scp -r ~/ziai12/blink $i:./.
	scp -r ~/.bashrc ~/.bash_aliases ~/.toprc ~/.zshrc .ssh $i:./.
done

exit 0
