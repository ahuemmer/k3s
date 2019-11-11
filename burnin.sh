#!/bin/sh

for p in $(nmap -sL 192.168.1.0/24 |grep Nmap | grep pi | cut -d" " -f 5 | cut -d"." -f 1 | sort -u)
do
    echo $p
    curl http://$p:30666/brot.php > /dev/null
done

