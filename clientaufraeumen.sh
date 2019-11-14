#!/bin/bash
set +e
set +x

echo "Räume Client auf..."
echo -n "  - Deaktiviere Swapspace... "
sudo dphys-swapfile swapoff > /dev/null
sudo dphys-swapfile uninstall > /dev/null
echo "OK"

echo -n "  - Deinstalliere k3s-agent (sofern vorhanden)... "
if [[ -x /usr/local/bin/k3s-agent-uninstall.sh ]]; then
  k3s-agent-uninstall.sh > /dev/null 2>&1
fi
# nur zur Sicherheit...
[[ -x /usr/local/bin/k3s-uninstall.sh ]] && k3s-uninstall.sh >/dev/null 2>&1
echo "OK"

echo -n "  - Räume Docker-Container auf... "
docker rm -f $(docker ps -aq) >/dev/null 2>&1 && echo "OK"

