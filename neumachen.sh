#!/bin/bash
set +x
set +e

server() {
	ssh bigengine <<EOF
		echo start
		set +x
		sudo dphys-swapfile swapoff
		sudo dphys-swapfile uninstall

		echo Installation des Webservers
		docker rm -f www
		docker run -d -p 30001:80 --name www frickler24/phpngx
		docker cp ~/k3s/www www:/var/.
		echo Container sollte nun laufen.

		echo Aufräumen alte Reste
		if [[ -x /usr/local/bin/k3s-uninstall.sh ]]; then
			k3s-uninstall.sh
		else
			echo kein k3s-uninstall.sh gefunden
		fi

		echo
		echo Installieren des Cluster-Servers
		(curl -sfL http://bigengine:30001 | sh -s - --write-kubeconfig-mode 644)
EOF

	echo Fertig mit dem Clusterserver.
	echo -n "Das neue Token lautet "
	sudo cat /var/lib/rancher/k3s/server/node-token
}

clients() {
	echo "Starten der Worker auf den Clients"
	for i in $(nmap -sL 192.168.1.0/24 |grep Nmap | grep pi | cut -d" " -f 5 | cut -d"." -f 1 | sort)
	do
		echo Bearbeite Pi $i
		ssh $i mkdir -p ~pi/k3s
		scp ~pi/k3s/clientneu.sh $i:k3s/clientneu.sh
		ssh $i k3s/clientneu.sh &
	done
}

server
clients

echo "Warte auf Erscheinen von BigEngine als ServerManager"
sleep 30
kubectl cordon bigengine

echo && echo fertig.
exit 0
