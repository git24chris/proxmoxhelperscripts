#!/bin/bash
# Skript zur Aktualisierung von Portainer auf einem Debian-basierten System

echo 
echo "--- Portainer-Update ------------------------------------------------------"
echo

echo "Dieses Skript aktualisiert Portainer gemaess der Instruktion von Portainer selbst."
read -p "Bist du sicher, dass du fortfahren moechtest? [y/j/N]: " -n 1 -r

if [[ ! $REPLY =~ ^[YyJj]$ ]]
then
    echo "Skript wird abgebrochen."
    exit 1
fi

# Stoppen des Portainer-Containers
echo ">>> Stoppen des Portainer-Containers..."
sudo docker stop portainer

# Entfernen des Portainer-Containers
echo ">>> Entfernen des Portainer-Containers..."
sudo docker rm portainer

# Entfernen des alten Portainer-Docker-Images
echo ">>> Entfernen des alten Portainer-Docker-Images..."
sudo docker rmi portainer/portainer-ce

# Herunterladen und Ausfuehren des neuen Portainer-Docker-Containers
echo ">>> Herunterladen und Ausfuehren des neuen Portainer-Docker-Containers..."
sudo docker run -d -p 8000:8000 -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce

# Ueberpruefung, ob der neue Portainer-Container laeuft
echo ">>> Ueberpruefung, ob der neue Portainer-Container laeuft..."
sudo docker ps | grep portainer

echo
echo ">>> Portainer wurde erfolgreich aktualisiert und laeuft!"
echo 
