#!/bin/bash
set +x
set +e

clients() {
	echo "Starten der Worker auf den Clients"
	set +x
	sudo dphys-swapfile swapoff
	sudo dphys-swapfile uninstall

	if [[ -x /usr/local/bin/k3s-agent-uninstall.sh ]]; then
		k3s-agent-uninstall.sh
	else
		echo Kein k3s-agent-uninstall.sh gefunden
	fi
	# nur zur Sicherheit...
	[[ -x /usr/local/bin/k3s-uninstall.sh ]] && k3s-uninstall.sh
	docker rm -f $(docker ps -aq) 2>/dev/null

	export K3S_URL=https://192.168.1.11:6443
	export K3S_TOKEN=$(ssh bigengine sudo cat /var/lib/rancher/k3s/server/node-token)
	set | grep K3S
	curl -sfL http://bigengine:30001 | sh -s - --docker
}

clients > ~/client.log 2>&1

