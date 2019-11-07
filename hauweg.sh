#!/bin/bash
set +x
set +e

CMD="export K3S_URL=https://192.168.1.18:6443 && export K3S_TOKEN=K10abd4e75c60cebdf874bb602bdf5ba65f4eb33aae29a6acc31aca5a7ad808097c::node:2049202b593df7b050a8d6627b20e6f0 && curl -sfL https://get.k3s.io | sh -s - --docker"
ALL="\
	192.168.1.10 \
	192.168.1.13 \
	192.168.1.14 \
	192.168.1.15 \
	192.168.1.16 \
	192.168.1.17 \
"

# execute CMD on ALL nodes
for I in $ALL
do
	ssh $I echo $I; $CMD
done
exit 0

