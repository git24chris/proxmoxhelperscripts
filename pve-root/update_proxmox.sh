#!/bin/bash

# Logging Funktion
log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1"
}

# Updates suchen
log ">>> Suche nach Updates..."
apt-get update

# Updates installieren
log ">>> Installiere Updates..."
apt-get -y dist-upgrade

# Nicht mehr benoetigte Pakete entfernen
log ">>> Entferne nicht mehr benoetigte Pakete..."
apt-get -y autoremove

log ">>> Updates erfolgreich abgeschlossen."

# Das Subscription Popup unterbinden
log ">>> Popup mit Hinweis auf das Subscription Model unterbinden."

# Backup der ursprünglichen Datei
cp /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js.bak

# Anpassung der Datei
#sed -i.bak "s/if (res === null || res === undefined || !res.data.status.toLowerCase() === 'active')/if (false)/g" /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js
sed -Ezi.bak "s/(Ext.Msg.show\(\{\s+title: gettext\('No valid sub)/void\(\{ \/\/\1/g" /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js
# Neustart des Proxmox-Dienstes
#systemctl restart pveproxy.service

log ">>> Das Popup zum Subscriptionsmodell wurde unterdrückt."
echo "Updateueberpruefung/~vorgang durchgefuehrt: $(date)" >> "/root/last_update.info"

# Ueberpruefen, ob ein Neustart erforderlich ist
if [ -f /var/run/reboot-required ]; then
    log ">>> Ein Neustart ist erforderlich. Starte das System neu..."
    # Benachrichtigung aufs den msgServer unterhalb dieser Zeile einfuegen
    curl -X -s POST "https://mping.die-czajas.goip.de/message?token=A130xYR1BhwsizU" -F "title=Proxmox Aktualisierung: DellServer" -F "message=Aktualisierung erfolgreich durchgefuehrt, Kernel-Update, Server-Neustart."
    echo #Leerzeile
    # Ende Benachrichtigungsblock

    shutdown -r now

else
    log ">>> Kein Neustart erforderlich."
    # Benachrichtigung auf dem msgServer unterhalb dieser Zeile einfuegen
    curl -X -s POST "https://mping.die-czajas.goip.de/message?token=A130xYR1BhwsizU" -F "title=Proxmox Aktualisierung: DellServer" -F "message=Aktualisierung erfolgreich durchgefuehrt. Kein Server-Neustart."
    echo #Leerzeile
    # Ende Benachrichtigungsblock
fi
