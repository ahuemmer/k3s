#!/bin/bash
set +x
set +e

MASTER_IP=192.168.1.12

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

	export K3S_URL=https://${MASTER_IP}:6443
	export K3S_TOKEN=$(ssh ${MASTER_IP} sudo cat /var/lib/rancher/k3s/server/node-token)
  ssh ${MASTER_IP} cat /etc/rancher/k3s/k3s.yaml | sed "s/127\.0\.0\.1/${MASTER_IP}/g" > ~/.kube/config
  curl -sfL http://${MASTER_IP}:42001 | sh -s - --docker
}

clients | tee ~/client.log 2>&1

