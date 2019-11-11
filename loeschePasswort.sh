#!/bin/bash

sudo sed -i "/^.*$/d" /var/lib/rancher/k3s/server/cred/node-passwd
sudo cat /var/lib/rancher/k3s/server/cred/node-passwd

