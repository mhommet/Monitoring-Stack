# Monitoring Stack

This repository contains a small Docker Compose monitoring stack suitable for local or small-server use.

Components
- Prometheus: metrics collection and alerting (`prometheus/`)
- Alertmanager: alert routing (Discord webhook configured via environment variable)
- Grafana: dashboards and visualization (persistent data in `grafana_data/`)
- Loki: log storage (`loki/`)
- Promtail: log shipping from the host to Loki
- Node Exporter: host metrics for Prometheus

Key files
- `docker-compose.yml` — service definitions and orchestration
- `prometheus/prometheus.yml` — scrape configuration and rule includes
- `alertmanager/config.yml.template` — Alertmanager template (sensitive values via env)
- `alertmanager/config.yml` — rendered Alertmanager config (do not commit)
- `alertmanager/alerts.yml` — alerting rules
- `loki/` & `loki/promtail-config.yml` — Loki and Promtail configs
- `scripts/render-configs.sh` — renders templates from `.env` using `envsubst`
- `.env` — sensitive values (DO NOT COMMIT)
- `.env.example` — example variables to commit

Sensitive values
- Store secrets such as `DISCORD_WEBHOOK` in `.env`. A sample file `.env.example` is provided for documentation.
- `.gitignore` excludes `.env` and the rendered `alertmanager/config.yml`.

Render templates
1. Copy `.env.example` to `.env` and edit the values:

```bash
cp .env.example .env
# edit .env (e.g. set DISCORD_WEBHOOK)
```

2. Render templates (requires `envsubst`, provided by the `gettext` package):

```bash
chmod +x scripts/render-configs.sh
./scripts/render-configs.sh
```

Start the stack

Prefer the modern `docker compose` command if available:

```bash
docker --version
docker compose up -d
# or older syntax if you have the standalone binary:
docker-compose up -d
```

Check status and logs

```bash
docker ps --filter name=alertmanager
docker logs -f alertmanager
```

Git tips
- Never commit `.env`.
- Add and commit templates, scripts and the `.env.example` file:

```bash
git add .gitignore .env.example alertmanager/config.yml.template scripts/ docker-compose.yml prometheus/ loki/
git commit -m "Initial monitoring config: templates + render script (do not commit .env)"
```
