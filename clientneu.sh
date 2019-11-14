#!/bin/bash
set +x
set +e

MASTER_IP=192.168.1.12

clients() {
	echo "Starten der Worker auf den Clients"

  echo -n "  - Räume auf... "
  ./clientaufraeumen.sh >/dev/null && echo "OK"

  echo -n "  - Hole K3S-Token... "
  token=$(ssh ${MASTER_IP} sudo cat /var/lib/rancher/k3s/server/node-token) && echo "OK"

  echo "  - Exportiere Variablen:"
  echo -n "    - K3S_URL=https://${MASTER_IP}:6443 "
	export K3S_URL=https://${MASTER_IP}:6443 && echo " - OK"

  echo -n "    - K3S_TOKEN=${token} "
	export K3S_TOKEN=${token} && echo " - OK"

  echo -n "  - Lade kubeconfig... "
  mkdir -p ~/.kube
  ssh ${MASTER_IP} cat /etc/rancher/k3s/k3s.yaml | sed "s/127\.0\.0\.1/${MASTER_IP}/g" > ~/.kube/config
  echo "OK"

  echo -n "  - Initialisiere K3S... "
  curl -sfL http://${MASTER_IP}:42001 | sh -s - --docker >/dev/null 2>&1
  echo "OK"

  echo "Fertig :-)"
}

clients | tee ~/client.log 2>&1
