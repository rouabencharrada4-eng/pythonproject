# Docker lab

Isolated network (`172.30.0.0/24`) used to generate attack traffic safely.

| Container | IP | Role |
|-----------|----|------|
| lab-dvwa | 172.30.0.10 | Vulnerable web app (SQLi target) |
| lab-attacker | 172.30.0.20 | Attack tools (nmap, hping3, hydra, sqlmap) |

## Commands
```bash
docker compose -f lab/docker-compose.yml up -d --build   # start
docker compose -f lab/docker-compose.yml ps              # status
docker compose -f lab/docker-compose.yml down            # stop
docker exec -it lab-attacker bash                        # shell in attacker
```

## Rule
Attack tools must only target containers inside this lab network.