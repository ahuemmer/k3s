#!/bin/bash
set +x
set +e

server() {
	ssh bigengine <<EOF
		echo start
		set +x
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
	for i in {1..21}
	do
		echo Bearbeite pi$i
		ssh pi$i mkdir -p ~pi/k3s
		scp ~pi/k3s/clientneu.sh pi$i:k3s/clientneu.sh
		ssh pi$i k3s/clientneu.sh &
	done
}

server
clients

echo && echo fertig.
exit 0
