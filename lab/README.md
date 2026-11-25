# Docker lab

Isolated network (`172.30.0.0/24`) used to generate attack traffic safely.
No container in this network can reach the internet or your real network
(`internal: true` on the `labnet` bridge).

| Container     | IP          | Role                                         |
|---------------|-------------|-----------------------------------------------|
| lab-dvwa      | 172.30.0.10 | Vulnerable web app (SQLi target)              |
| lab-victim    | 172.30.0.11 | SSH/FTP target (brute force) + FIM/anomaly demo |
| lab-attacker  | 172.30.0.20 | Attack tools (nmap, hping3, hydra, sqlmap)    |
| lab-suricata  | shares lab-attacker's netns | NIDS, writes `eve.json`       |
| lab-zeek      | shares lab-attacker's netns | Behavioral logs (conn/http/dns) |

Suricata and Zeek run with `network_mode: "service:attacker"`, so they see
every packet the attacker sends or receives, whichever target is being hit.
This matches the demo scenario in the cahier des charges: attack launched
from the attacker container → detected by the sensors.

## Commands

```bash
docker compose -f lab/docker-compose.yml up -d --build   # start everything
docker compose -f lab/docker-compose.yml ps              # status
docker compose -f lab/docker-compose.yml down             # stop
docker exec -it lab-attacker bash                         # shell in attacker
```

First run only: Suricata needs its ruleset downloaded once, and DVWA needs
its database initialized once:

```bash
docker exec -it lab-suricata suricata-update
docker exec -it lab-dvwa bash -c "mysql -u root < /var/www/html/config/db_init.sql" 2>/dev/null || true
# then open http://172.30.0.10/setup.php in a browser and click "Create / Reset Database"
```

## Running the attacks

Each attack has its own script in `attack-scripts/`, run from inside
`lab-attacker` unless noted otherwise:

```bash
docker exec -it lab-attacker bash /work/scan.sh          # scan réseau
docker exec -it lab-attacker bash /work/ddos.sh          # DDoS (SYN flood)
docker exec -it lab-attacker bash /work/bruteforce.sh    # brute force SSH/FTP
docker exec -it lab-attacker bash /work/sqli.sh          # SQL injection (needs DVWA cookie, see script)
docker exec -it lab-attacker bash /work/phishing_sim.sh  # phishing-style traffic
bash attack-scripts/anomaly.sh                            # comportement système anormal (run on the HOST)
```

Logs land in `sensors/suricata/logs/eve.json` and `sensors/zeek/logs/*.log`
(JSON format) — these are the raw inputs for the feature-extraction
pipeline in `src/pipeline/`.

## Rule
Attack tools must only target containers inside this lab network.
