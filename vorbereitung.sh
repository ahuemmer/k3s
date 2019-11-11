#!/bin/bash

# Dieses Script wird am besten remote geöffnet
# und schrittweise ausgeführt,
# weil mindestens ein Bootvorgang enthalten ist
ssh -X bigengine geany ~/k3s/vorbereitung.sh

# und hier geht es nun los
git clone https://github.com/frickler24/k3s

# Kopieren der wichtigsten Dinge
# Der Quellrechner
QUELLE=pi1

# Die Keys zum Remote login auf die Raspis ohne Passwort
scp -r ${QUELLE}:.ssh . # TODO yes |

# Vor den nächsten Zeilen abwarten, 
# denn durch die Temrinaleingabe verschwinden die weiteren Pastes...
# scp -r ${QUELLE}:k3s .
scp ${QUELLE}:.bash{rc,_aliases} . # TODO authentication again...
source ~/.bashrc
scp ${QUELLE}:.zshrc . # TODO scp: .zshrc: No such file or directory
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

# Vor den nächsten Zeilen abwarten wegen reboots
# Installation Docker
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
echo "deb [arch=armhf] https://download.docker.com/linux/debian \
     $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
sudo apt update && sudo apt install -y docker-ce
sudo apt remove aufs-dkms -y && sudo apt autoremove -y

sudo systemctl enable docker
sudo systemctl start docker

# -------------------------------
# Achtung, auch hier erst mal die Installation abwarten!
sudo usermod -aG docker pi

# Einmal durchstarten, denn es gab einen neuen Kernel
reboot

sudo docker run armhf/hello-world

# Wenn die Ausgabe OK ist, läuft der Knoten

# Wenn bereits ein Cluster besteht, hängen wir uns rein
k3s/clientneu.sh

tail ~/client.log # tail: '/home/pi/client.log' kann nicht zum Lesen geöffnet werden: Datei oder Verzeichnis nicht gefunden
# Das nächste zum Anschauen, ob der Service läuft: Mit "q" beenden
systemctl status k3s-agent.service # Nov 11 10:49:50 pi5 k3s[4079]: time="2019-11-11T10:49:50.700512395+01:00" level=error msg="Node password rejected, conte


# TODO
#Bearbeite Pi pi99
#ssh: connect to host pi99 port 22: No route to host
#ssh: connect to host pi99 port 22: No route to host
#lost connection
#ssh: connect to host pi99 port 22: No route to host
#Warte auf Erscheinen von BigEngine als ServerManager

#Warning: the ECDSA host key for 'pi5' differs from the key for the IP address '192.168.1.15'
#Offending key for IP in /home/pi/.ssh/known_hosts:6
#Matching host key in /home/pi/.ssh/known_hosts:33
#Are you sure you want to continue connecting (yes/no)? 
