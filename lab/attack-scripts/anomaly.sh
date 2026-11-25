#!/bin/bash
# Comportement système anormal — this one targets the HOST itself, so
# run it from your Docker host (not from inside lab-attacker):
#   bash lab/attack-scripts/anomaly.sh
set -e

echo "[*] CPU/memory spike inside lab-victim (Wazuh/metrics should catch this)"
docker exec lab-victim stress-ng --cpu 2 --vm 1 --vm-bytes 128M --timeout 30s

echo "[*] Suspicious file modification (Wazuh FIM should flag this)"
docker exec lab-victim bash -c 'echo "new_secret=leaked" >> /home/labuser/config.txt'
docker exec lab-victim bash -c 'chmod 777 /home/labuser/config.txt'

echo "[*] Unexpected process spawn"
docker exec lab-victim bash -c 'nohup sleep 300 >/dev/null 2>&1 &'
