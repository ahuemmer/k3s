#!/bin/bash

echo "Anzeige der Knoten im Cluster (kubectl get node -o wide)"
kubectl get node -o wide | sort

echo
echo "Anzeige der aktiven Pods im Cluster über alle Namespaces (kubectl get pods -Ao wide)"
kubectl get pods -Ao wide

