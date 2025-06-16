
#!/bin/bash
# Skript zur vollstaendigen Entfernung von Docker auf einem Debian-basierten System

echo 
echo "--- Docker-Remove ------------------------------------------------------"
echo

echo "Dieses Skript deinstalliert Docker gemaess der Instruktion von Docker selbst."
read -p "Bist du sicher, dass du fortfahren moechtest? [y/j/N]: " -n 1 -r

if [[ ! $REPLY =~ ^[YyJj]$ ]]
then
    echo "Skript wird abgebrochen."
    exit 1
fi

# Stoppen aller Docker-Container
echo "Stoppen aller Docker-Container..."
sudo docker stop $(sudo docker ps -a -q)

# Entfernen aller Docker-Container
echo "Entfernen aller Docker-Container..."
sudo docker rm $(sudo docker ps -a -q)

# Entfernen aller Docker-Images
echo "Entfernen aller Docker-Images..."
sudo docker rmi $(sudo docker images -q)

# Deinstallation von Docker Engine, CLI und Containerd
echo "Deinstallation von Docker Engine, CLI und Containerd..."
sudo apt-get purge -y docker-ce docker-ce-cli containerd.io

# Entfernen aller Docker-Konfigurationen und Daten
echo "Entfernen aller Docker-Konfigurationen und Daten..."
sudo rm -rf /var/lib/docker
sudo rm -rf /etc/docker
sudo rm -rf /var/run/docker
sudo rm -rf /run/docker
sudo rm -rf /lib/systemd/system/docker.service
sudo rm -rf /lib/systemd/system/docker.socket
sudo rm -rf /etc/systemd/system/docker.service.d
sudo rm -rf /etc/systemd/system/docker.socket.d
sudo rm -rf /usr/bin/docker
sudo rm -rf /usr/bin/dockerd
sudo rm -rf /var/lib/docker

# Bereinigen des Paketindex
echo "Bereinigen des Paketindex..."
sudo apt-get autoremove -y
sudo apt-get autoclean -y

echo
echo "Docker wurde vollstaendig entfernt!"
echo  

