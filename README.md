# Plateforme XDR intelligente de détection multi-attaques

Projet pédagogique de cybersécurité (ML + IDPS) : détection et prévention de
six familles d'attaques — DDoS, phishing, brute force, injection SQL, scan
réseau, comportements système anormaux — en combinant Suricata, Zeek et
Wazuh avec des modèles de Machine Learning supervisés (Random Forest,
XGBoost) et non supervisés (Autoencoder).

Voir le cahier des charges complet dans `docs/report/`.

## Structure du dépôt

```
lab/            Laboratoire Docker isolé (attaquant, victimes, capteurs)
data/           Datasets (raw / processed / synthetic) — non versionnés
notebooks/      01_supervised, 02_unsupervised, 03_ensemble
src/            pipeline, models, decision, api, dashboard
docs/           attacks (fiches par attaque), report (rapport final)
configs/        Fichiers de configuration (seuils, chemins, etc.)
tests/          Tests unitaires
```

## Démarrage rapide

```bash
docker compose -f lab/docker-compose.yml up -d --build
```

Voir `lab/README.md` pour le détail des conteneurs et des scripts d'attaque.

## État d'avancement

- [x] Laboratoire Docker : DVWA, victime SSH/FTP, attaquant, Suricata, Zeek
- [x] Scripts de simulation pour les 6 attaques
- [ ] Wazuh (agents + Active Response)
- [ ] Constitution du dataset (CIC-IDS2017, phishing, synthétique)
- [ ] Modèles supervisés / non supervisés / ensemble
- [ ] API de décision + tableau de bord Streamlit
