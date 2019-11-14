#!/bin/bash

echo -n "Anzeige der Knoten im Cluster (kubectl get node -o wide), "
echo "insgesamt $(kubectl get node -o wide | grep pi | sort -u | wc -l) Knoten exkl. BigEngine erkannt"
kubectl get node -o wide | sort

echo
echo "Anzeige der aktiven Pods im Cluster über alle Namespaces (kubectl get pods -Ao wide)"
kubectl get pods -Ao wide

