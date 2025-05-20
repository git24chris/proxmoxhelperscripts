#!/bin/bash
# Skript zur Installation des Portainer Agents auf einem Debian-basierten System

echo 
echo "--- Portainer-Agent Installation ------------------------------------------------------"
echo

echo "Dieses Skript installiert Portainer-Agent gemaess der Instruktion von Portainer selbst."
read -p "Bist du sicher, dass du fortfahren moechtest? [y/j/N]: " -n 1 -r

if [[ ! $REPLY =~ ^[YyJj]$ ]]
then
    echo "Skript wird abgebrochen."
    exit 1
fi

# Herunterladen und Ausfuehren des Portainer Agent Docker-Containers
echo ">>> Herunterladen und Ausfuehren des Portainer Agent Docker-Containers..."
# sudo docker run -d --name portainer_agent --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/docker/volumes:/var/lib/docker/volumes portainer/agent



# Ueberpruefung, ob der Portainer Agent-Container laeuft
echo ">>> Ueberpruefung, ob der Portainer Agent-Container laeuft..."
sudo docker ps | grep portainer_agent

echo 
echo ">>> Portainer Agent wurde erfolgreich installiert und laeuft!"
echo 
