#!/bin/bash
# Dieses Skript fuegt alle Aenderungen zum Git-Repository hinzu, commitet sie und pusht sie nach GitHub.

# Schritt 1: Pruefen, ob ein Git-Repository existiert
if [ ! -d .git ]; then
    echo "Fehler: Dies ist kein Git-Repository! Bitte zuerst mit 'git init' initialisieren."
    exit 1
fi

# Schritt 2: Alle Aenderungen dem Staging-Bereich hinzufuegen
echo "Fuege alle Aenderungen hinzu..."
git add .

# Schritt 3: Commit-Nachricht generieren
COMMIT_MESSAGE="Automatische Aktualisierung am $(date +"%Y-%m-%d %H:%M:%S")"
echo "Commit-Nachricht: $COMMIT_MESSAGE"

# Schritt 4: Commit ausfuehren
git commit -m "$COMMIT_MESSAGE"

# Schritt 5: Pruefen, ob ein Remote-Repository vorhanden ist
REMOTE_URL=$(git config --get remote.origin.url)
if [ -z "$REMOTE_URL" ]; then
    echo "Fehler: Kein Remote-Repository gesetzt. Bitte mit 'git remote add origin <URL>' hinzufuegen."
    exit 1
fi

# Schritt 6: Aenderungen nach GitHub pushen
echo "Push nach GitHub..."
git push origin main

# Falls dein Branch 'master' statt 'main' heisst, ersetze 'main' mit 'master'
# git push origin master

echo "Fertig! Aenderungen erfolgreich synchronisiert."ah0`i0ai0
