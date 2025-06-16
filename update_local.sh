#!/bin/bash
# Dieses Skript holt die neuesten Aenderungen von GitHub und aktualisiert das lokale Repository.

# Schritt 1: Pruefen, ob ein Git-Repository existiert
if [ ! -d .git ]; then
    echo "Fehler: Dies ist kein Git-Repository! Bitte zuerst mit 'git init' initialisieren."
    exit 1
fi

# Schritt 2: Pruefen, ob ein Remote-Repository gesetzt ist
REMOTE_URL=$(git config --get remote.origin.url)
if [ -z "$REMOTE_URL" ]; then
    echo "Fehler: Kein Remote-Repository gesetzt. Bitte mit 'git remote add origin <URL>' hinzufuegen."
    exit 1
fi

# Schritt 3: Holen der neuesten Aenderungen von GitHub
echo
echo "Hole die neuesten Aenderungen von GitHub..."
git fetch origin

# Schritt 4: Zusammenfuehren der Aenderungen mit dem lokalen Branch
echo
echo "Mische die Aenderungen mit dem lokalen Branch..."
git merge origin/main

# Falls dein Hauptbranch 'master' statt 'main' heisst, ersetze 'main' mit 'master'
# git merge origin/master

echo
echo "Fertig! Lokales Repository wurde aktualisiert."
echo
