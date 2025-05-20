#!/bin/bash
# Skript zur Ausgabe von kompakten Systeminformationen inklusive IP-Adresse, DNS-IP, DHCP-IP, SUDO und SSH

# CPU-Informationen
CPUS=$(nproc)

# RAM-Informationen (zugewiesener Speicher)
RAM_TOTAL=$(grep MemTotal /proc/meminfo | awk "{printf \"%.2f GB\", \$2/1024/1024}")

# User-Informationen
USERID=$(whoami)
if [[ "$LANG" == de* ]]; then
    IS_SUDOER=$(groups | grep -qw "sudo" && echo "ja" || echo "nein")
    SSH_ENABLED=$(grep "^AllowUsers" /etc/ssh/sshd_config | grep -w "${USERID}" >/dev/null 2>&1 && echo "ja" || echo "nein")
    WELCOME_MSG="Willkommen"
else
        IS_SUDOER=$(groups | grep -qw "sudo" && echo "yes" || echo "no")
    SSH_ENABLED=$(grep "^AllowUsers" /etc/ssh/sshd_config | grep -w "${USERID}" >/dev/null 2>&1 && echo "yes" || echo "no")
    WELCOME_MSG="Welcome"
fi

# Netzwerk-Informationen
INTERFACE=$(ip -o -4 route show to default | awk "{print \$5}")
IP_CIDR=$(ip -o -4 addr show dev $INTERFACE | awk "{print \$4}") # IP-Adresse inklusive CIDR
DNS_IP=$(awk "/nameserver/ {print \$2; exit}" /etc/resolv.conf)
DHCP_IP=$(ip route show | awk "/default/ {print \$3; exit}")

# UTC-Zeit
UTC_TIME=$(date -u "+%Y-%m-%d %H:%M:%S")

# Speicherplatz-Informationen
STORAGE=$(df -h | head -n 2)

# Farben definieren
cYELLOW="\e[1;33m"  # Leuchtendes Gelb
cRED="\e[1;31m"     # Leuchtendes Rot
cGREEN="\e[1;32m"   # Leuchtendes Gruen
cBLUE="\e[1;34m"    # Leuchtendes Blau
cRESET="\e[0m"      # Reset auf Standardfarbe


# Ausgabe
echo # Leerzeile

echo "Systeminfo:"
echo
echo -e "${cYELLOW}$STORAGE${cRESET}"
echo
echo -e "CPUs: ${cYELLOW}${CPUS}${cRESET}      RAM: ${cYELLOW}${RAM_TOTAL}${cRESET}     UTC: ${cYELLOW}${UTC_TIME}${cRESET}"
echo
echo -e "IP: ${cYELLOW}${IP_CIDR}${cRESET}     DNS: ${cYELLOW}${DNS_IP}${cRESET}     DHCP: ${cYELLOW}${DHCP_IP}${cRESET}"
echo
echo -e "SUDO: ${cYELLOW}${IS_SUDOER}${cRESET}     SSH: ${cYELLOW}${SSH_ENABLED}${cRESET}"
echo

# Farbwahl basierend auf Benutzer
if [[ "$USERID" == "root" ]]; then
    COLOR=$cRED
else
    # Hier kannst du zwischen Gruen und Blau wechseln
    COLOR=$cGREEN  # Alternativ: COLOR=$cBLUE
fi
echo -e "${COLOR}"
echo "${WELCOME_MSG} ${USERID}"
echo -e "${cRESET}"
echo 
