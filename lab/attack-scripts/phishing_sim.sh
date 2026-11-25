#!/bin/bash
# Phishing — run from inside lab-attacker:
#   docker exec -it lab-attacker bash /work/phishing_sim.sh
#
# Note: phishing is mainly covered by the public "Phishing Websites
# Dataset" (UCI/Kaggle) used offline in notebooks/01_supervised. This
# script only generates *live* traffic with phishing-like URL
# characteristics (long URL, '@', many sub-domains, suspicious path)
# against DVWA, so Zeek's http.log/dns.log has real examples to extract
# features from for the real-time validation dataset.
#
# A proper look-alike phishing page via GoPhish is a stretch goal for
# later (see docs/attacks/phishing.md) — it needs its own container and
# isn't required to unblock the ML/sensor pipeline.
set -e

TARGET=172.30.0.10

echo "[*] Requests with phishing-style URL characteristics"
curl -s -o /dev/null "http://$TARGET/@login-secure.account.verify.$TARGET/update/index.php?user=victim&redirect=http://evil.example"
curl -s -o /dev/null "http://$TARGET/login.php?session=aXNfcGhpc2hpbmc%3D&confirm=1&verify=account-update-2026"
curl -s -o /dev/null "http://$TARGET/wp-login-secure-verify-account-update-confirm-now-2026.php"

echo "[*] Suspicious DNS-style lookups (fake sub-domain depth)"
for i in 1 2 3; do
  getent hosts "secure-login.account-verify.update.$TARGET" || true
done
