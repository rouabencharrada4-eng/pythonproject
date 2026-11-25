#!/bin/bash
# Scan réseau — run from inside lab-attacker:
#   docker exec -it lab-attacker bash /work/scan.sh
set -e

echo "[*] SYN scan of victim (22, 21) and dvwa (80)"
nmap -sS -p 21,22,80 172.30.0.10 172.30.0.11

echo "[*] Full port sweep on victim (generates many short/failed connections)"
nmap -p- --max-retries 1 --host-timeout 30s 172.30.0.11

echo "[*] Service/version detection"
nmap -sV 172.30.0.10 172.30.0.11
