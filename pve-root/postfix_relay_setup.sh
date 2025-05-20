#!/bin/bash
# Willkommen bei der Postfix-Relay-Server-Konfiguration unter Proxmox
echo 
echo "Willkommen bei der Postfix-Relay-Server-Konfiguration unter Proxmox!"
echo 

# Eingabe der SMTP-Zugangsdaten
read -p "Geben Sie den SMTP-Server ein: " smtp_server
read -p "Geben Sie den SMTP-Port ein (z. B. 587): " smtp_port
read -p "Geben Sie den SMTP-Benutzernamen ein: " smtp_user
read -s -p "Geben Sie das SMTP-Passwort ein: " smtp_password
echo

# Nutzerbestaetigung zur Fortsetzung der Installation
read -p "Sind Sie sicher, dass Sie die Postfix-Konfiguration durchfuehren moechten? (ja/nein): " confirmation

# Falls der Nutzer die Konfiguration nicht bestaetigen moechte, wird das Skript beendet
if [ "$confirmation" != "ja" ]; then
    echo "Abbruch der Konfiguration."
    exit 1
fi

echo "Postfix wird installiert und konfiguriert..."

# Aktualisieren der Paketlisten und Installation von Postfix
apt-get update && apt-get install -y postfix

# Postfix-Konfigurationsdatei
postfix_config="/etc/postfix/main.cf"

# Konfiguration von Postfix mit den eingegebenen SMTP-Daten
cat <<EOL_CONFIG >> $postfix_config
# Konfiguriert den Relay-Host mit dem angegebenen SMTP-Server und Port
relayhost = [$smtp_server]:$smtp_port

# Aktiviert die SMTP-Authentifizierung
smtp_sasl_auth_enable = yes

# Legt Sicherheitsoptionen fuer die Authentifizierung fest
smtp_sasl_security_options = noanonymous

# Verweist auf die Datei mit den SMTP-Zugangsdaten
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd

# Erzwingt TLS-Verschluesselung fuer die SMTP-Kommunikation
smtp_tls_security_level = encrypt

# Legt die Zertifikatsdatei fuer die TLS-Verschluesselung fest
smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt

# Aktiviert die TLS-Nutzung fuer SMTP
smtp_use_tls = yes
EOL_CONFIG

# Speichert die SMTP-Zugangsdaten in einer Datei
echo "[$smtp_server]:$smtp_port $smtp_user:$smtp_password" > /etc/postfix/sasl_passwd

# Erstellt eine Hash-Datenbank fuer die Passwortdatei
postmap /etc/postfix/sasl_passwd

# Neustart von Postfix, damit die neue Konfiguration angewendet wird
systemctl restart postfix

echo "Postfix wurde erfolgreich als Relay-Server konfiguriert!"

# Hinweis zur Test-Nachricht
echo "Verwenden Sie den folgenden Befehl, um eine Testnachricht zu senden:"
echo "echo 'Testnachricht' | mail -s 'Testbetreff' -a 'From:$smtp_user' [Empfaenger-E-Mail-Adresse]"
echo
