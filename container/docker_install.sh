#!/bin/bash
# Skript zur Installation von Docker auf einem Debian-basierten System

echo 
echo "--- Docker-Installation ------------------------------------------------------"
echo

echo "Dieses Skript installiert Docker gemaess der Instruktion von Docker selbst."
read -p "Bist du sicher, dass du fortfahren moechtest? [y/j/N]: " -n 1 -r

if [[ ! $REPLY =~ ^[YyJj]$ ]]
then
    echo "Skript wird abgebrochen."
    exit 1
fi

# Update des Paketindex
echo "Aktualisieren des Paketindex..."
sudo apt-get update -y

# Installation der erforderlichen Pakete zum Hinzufügen eines neuen Repositorys
echo "Installation der erforderlichen Pakete..."
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release

# Hinzufügen des offiziellen Docker GPG-Keys
echo "Hinzufügen des Docker GPG-Keys..."
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Hinzufügen des Docker Repositorys
echo "Hinzufügen des Docker Repositorys..."
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Aktualisieren des Paketindex mit dem neuen Docker Repository
echo "Aktualisieren des Paketindex mit dem Docker Repository..."
sudo apt-get update -y

# Installation der neuesten Version von Docker Engine und Docker CLI
echo "Installation von Docker Engine und Docker CLI..."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Überprüfung der Docker-Installation
echo "Überprüfung der Docker-Installation..."
sudo docker --version

echo
echo "Docker wurde erfolgreich installiert!"
echo  
