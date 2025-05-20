#!/bin/bash
echo "Willkommen bei der Postfix-Relay-Server-Konfiguration unter Proxmox!"
read -p "Geben Sie den SMTP-Server ein: " smtp_server
read -p "Geben Sie den SMTP-Port ein (z. B. 587): " smtp_port
read -p "Geben Sie den SMTP-Benutzernamen ein: " smtp_user
read -s -p "Geben Sie das SMTP-Passwort ein: " smtp_password
echo
read -p "Sind Sie sicher, dass Sie die Postfix-Konfiguration durchführen möchten? (ja/nein): " confirmation
if [ "$confirmation" != "ja" ]; then
    echo "Abbruch der Konfiguration."
    exit 1
fi
echo "Postfix wird installiert und konfiguriert..."
apt-get update && apt-get install -y postfix
postfix_config="/etc/postfix/main.cf"
cat <<EOL_CONFIG >> $postfix_config
relayhost = [$smtp_server]:$smtp_port
smtp_sasl_auth_enable = yes
smtp_sasl_security_options = noanonymous
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
smtp_tls_security_level = encrypt
smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt
smtp_use_tls = yes
EOL_CONFIG
echo "[$smtp_server]:$smtp_port $smtp_user:$smtp_password" > /etc/postfix/sasl_passwd
postmap /etc/postfix/sasl_passwd
systemctl restart postfix
echo "Postfix wurde erfolgreich als Relay-Server konfiguriert!"
echo "echo Testnachricht | mail -s Testbetreff -a From:$smtp_user [Empfänger-E-Mail-Adresse]"

