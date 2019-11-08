#!/bin/bash

# Dieses Script wird am besten remote geöffnet
# und schrittweise ausgeführt,
# weil mindestens ein Bootvorgang enthalten ist
ssh -X pi1 geany vorbereitung.sh

# und hier geht es nun los

# Kopieren der wichtigsten Dinge
# Der Quellrechner
QUELLE=pi1

# Die Keys zum Remote login auf die Raspis ohne Passwort
scp -r ${QUELLE}:.ssh .

# Vor den nächsten Zeilen abwarten, 
# denn durch die Temrinaleingabe verschwinden die weiteren Pastes...
scp -r ${QUELLE}:k3s .
scp ${QUELLE}:.bash{rc,_aliases} .
source ~/.bashrc
scp ${QUELLE}:.zshrc .
scp ${QUELLE}:.toprc .

# jeweils einmal den remote pi aufrufen zum Setzen der Host Keys
yes | ssh pi1 echo ok
yes | ssh bigengine echo ok


# Vorbereitungsscript für Raspis 3 / 3B+
# Zunächst die normale NOOBS-Prozedur durchlaufen
# Anschließend den Linux-Patchday durchführen:
sudo dphys-swapfile swapoff
sudo dphys-swapfile uninstall
sudo apt update && sudo apt upgrade -y
reboot

# Vor den nächsten Zeilen abwarten wegen reboots
# Installation Docker
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
echo "deb [arch=armhf] https://download.docker.com/linux/debian \
     $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
sudo apt update && sudo apt install -y docker-ce
sudo apt remove aufs-dkms -y && sudo apt autoremove -y

# -------------------------------
# Achtung, auch hier erst mal die Installation abwarten!
sudo usermod -aG docker pi

# Einmal durchstarten, denn es gab einen neuen Kernel
reboot

sudo docker run armhf/hello-world

# Wenn die Ausgabe OK ist, läuft der Knoten


