#!/bin/bash
# Skript zur Installation von Portainer auf einem Debian-basierten System

echo 
echo "--- Portainer-Installation ------------------------------------------------------"
echo

echo "Dieses Skript installiert Portainer gemaess der Instruktion von Portainer selbst."
read -p "Bist du sicher, dass du fortfahren moechtest? [y/j/N]: " -n 1 -r

if [[ ! $REPLY =~ ^[YyJj]$ ]]
then
    echo "Skript wird abgebrochen."
    exit 1
fi

# Erstellen eines Docker-Volumes für Portainer-Daten
echo ">>> Erstellen eines Docker-Volumes für Portainer-Daten..."
sudo docker volume create portainer_data

# Herunterladen und Ausfuehren des Portainer-Docker-Containers
echo ">>> Herunterladen und Ausfuehren des Portainer-Docker-Containers..."
sudo docker run -d -p 8000:8000 -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce

# Ueberpruefung, ob der Portainer-Container laeuft
echo ">>> Ueberpruefung, ob der Portainer-Container laeuft..."
sudo docker ps | grep portainer

echo 
echo ">>> Portainer wurde erfolgreich installiert und laeuft!"
echo  
