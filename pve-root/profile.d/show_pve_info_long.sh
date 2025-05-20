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

# Der FunPart fuer ASCII-Art

# Farben definieren
cYELLOW="\e[1;33m"  # Leuchtendes Gelb
cRED="\e[1;31m"     # Leuchtendes Rot
cGREEN="\e[1;32m"   # Leuchtendes Gruen
cBLUE="\e[1;34m"    # Leuchtendes Blau
cRESET="\e[0m"      # Reset auf Standardfarbe

generate_ascii_art() {
    local username=$1
    declare -A patterns

    # Definition der Buchstabenmuster mit fester Breite
    patterns["A"]=" AAA  \nA   A \nAAAAA \nA   A \nA   A "
    patterns["B"]="BBBB  \nB   B \nBBBB  \nB   B \nBBBB  "
    patterns["C"]=" CCCC \nC     \nC     \nC     \n CCCC "
    patterns["D"]="DDDD  \nD   D \nD   D \nD   D \nDDDD  "
    patterns["E"]="EEEEE \nE     \nEEE   \nE     \nEEEEE "
    patterns["F"]="FFFFF \nF     \nFFFF  \nF     \nF     "
    patterns["G"]=" GGGG \nG     \nG  GG \nG   G \n GGGG "
    patterns["H"]="H   H \nH   H \nHHHHH \nH   H \nH   H "
    patterns["I"]=" III  \n  I   \n  I   \n  I   \n III  "
    patterns["J"]="  JJJ \n   J  \n   J  \nJ  J  \n JJ   "
    patterns["K"]="K   K \nK  K  \nKKK   \nK  K  \nK   K "
    patterns["L"]="L     \nL     \nL     \nL     \nLLLLL "
    patterns["M"]="M   M \nMM MM \nM M M \nM   M \nM   M "
    patterns["N"]="N   N \nNN  N \nN N N \nN  NN \nN   N "
    patterns["O"]=" OOO  \nO   O \nO   O \nO   O \n OOO  "
    patterns["P"]="PPPP  \nP   P \nPPPP  \nP     \nP     "
    patterns["Q"]=" QQQ  \nQ   Q \nQ   Q \nQ  QQ \n QQQQ "
    patterns["R"]="RRRR  \nR   R \nRRRR  \nR  R  \nR   R "
    patterns["S"]=" SSS  \nS     \n SSS  \n    S \n SSS  "
    patterns["T"]="TTTTT \n  T   \n  T   \n  T   \n  T   "
    patterns["U"]="U   U \nU   U \nU   U \nU   U \n UUU  "
    patterns["V"]="V   V \nV   V \n V V  \n V V  \n  V   "
    patterns["W"]="W   W \nW   W \nW W W \nWW WW \nW   W "
    patterns["X"]="X   X \n X X  \n  X   \n X X  \nX   X "
    patterns["Y"]="Y   Y \n Y Y  \n  Y   \n  Y   \n  Y   "
    patterns["Z"]="ZZZZZ \n   Z  \n  Z   \n Z    \nZZZZZ "

    # Zahlenmuster mit fester Breite
    patterns["0"]=" 000  \n0   0 \n0   0 \n0   0 \n 000  "
    patterns["1"]="  1   \n 11   \n  1   \n  1   \n11111 "
    patterns["2"]=" 222  \n2   2 \n   2  \n  2   \n22222 "
    patterns["3"]=" 333  \n3   3 \n   33 \n3   3 \n 333  "
    patterns["4"]="4  4  \n4  4  \n44444 \n   4  \n   4  "
    patterns["5"]="55555 \n5     \n5555  \n    5 \n5555  "
    patterns["6"]=" 666  \n6     \n6666  \n6   6 \n 666  "
    patterns["7"]="77777 \n   7  \n  7   \n 7    \n7     "
    patterns["8"]=" 888  \n8   8 \n 888  \n8   8 \n 888  "
    patterns["9"]=" 999  \n9   9 \n 999  \n    9 \n 999  "

    # Sonderzeichenmuster mit fester Breite
    patterns["!"]="  !   \n  !   \n  !   \n      \n  !   "
    patterns["$"]=" $$$  \n$     \n $$$  \n    $ \n $$$  "
    patterns["%"]="%   % \n   %  \n  %   \n %    \n%   % "
    patterns["&"]="  &   \n & &  \n  &   \n & &  \n  & & "
    patterns["/"]="    / \n   /  \n  /   \n /    \n/     "
    patterns["("]="  (   \n (    \n(     \n (    \n  (   "
    patterns[")"]="  )   \n   )  \n    ) \n   )  \n  )   "
    patterns["-"]="      \n      \n -----\n      \n      "
    patterns["+"]="      \n  +   \n +++  \n  +   \n      "
    patterns["#"]=" # #  \n##### \n # #  \n##### \n # #  "
    patterns["*"]="  *   \n * *  \n***** \n * *  \n  *   "
    patterns["~"]="      \n ~ ~  \n~ ~   \n      \n      "
    patterns["@"]="  @@@@ \n @    @\n@  @@@@\n@ @   @\n @@@@@ \n      @"

    # ASCII-Art Zeilenweise generieren
    for ((i=0; i<5; i++)); do
        line=""
        for ((j=0; j<${#username}; j++)); do
            char=${username:j:1}
            char=${char^^}  # In Grossbuchstaben umwandeln
            if [[ -n ${patterns[$char]} ]]; then
                line+=$(echo -e "${patterns[$char]}" | sed -n "$((i+1))p")
            else
                line+="      "  # Leerplatzhalter fuer unbekannte Zeichen
            fi
        done
        echo "$line"
    done
}


# Ausgabe
echo # Leerzeile
echo -e "${cBLUE}"
generate_ascii_art "${WELCOME_MSG}"
echo -e "${cRESET}"
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
generate_ascii_art "$USERID #PVE"
echo -e "${cRESET}"
echo 
