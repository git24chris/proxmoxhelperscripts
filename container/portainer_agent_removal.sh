#!/bin/bash
# Skript zur Deinstallation des Portainer Agents auf einem Debian-basierten System

echo 
echo "--- Portainer-Agent Deinstallation ------------------------------------------------------"
echo

echo "Dieses Skript deinstalliert Portainer-Agent gemaess der Instruktion von Portainer selbst."
read -p "Bist du sicher, dass du fortfahren moechtest? [y/j/N]: " -n 1 -r

if [[ ! $REPLY =~ ^[YyJj]$ ]]
then
    echo "Skript wird abgebrochen."
    exit 1
fi

# Stoppen des Portainer Agent-Containers
echo ">>> Stoppen des Portainer Agent-Containers..."
sudo docker stop portainer_agent

# Entfernen des Portainer Agent-Containers
echo ">>> Entfernen des Portainer Agent-Containers..."
sudo docker rm portainer_agent

# Entfernen des Portainer Agent-Docker-Images
echo ">>> Entfernen des Portainer Agent-Docker-Images..."
sudo docker rmi portainer/agent

# Entfernen des Docker-Volumes für Portainer Agent-Daten (optional)
echo ">>> Entfernen des Docker-Volumes für Portainer Agent-Daten..."
sudo docker volume rm portainer_data

echo 
echo ">>> Portainer Agent wurde erfolgreich deinstalliert!"
echo  
