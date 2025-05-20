#!/bin/bash
# Skript zur Deinstallation von Portainer auf einem Debian-basierten System

echo 
echo "--- Portainer-Deinstallation ------------------------------------------------------"
echo

echo "Dieses Skript deinstalliert Portainer gemaess der Instruktion von Portainer selbst."
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

# Entfernen des Portainer-Docker-Images
echo ">>> Entfernen des Portainer-Docker-Images..."
sudo docker rmi portainer/portainer-ce

# Entfernen des Docker-Volumes für Portainer-Daten
echo ">>> Entfernen des Docker-Volumes für Portainer-Daten..."
sudo docker volume rm portainer_data

echo
echo ">>> Portainer wurde erfolgreich deinstalliert!"
echo  
