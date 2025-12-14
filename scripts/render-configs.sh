#!/bin/sh
set -e
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

ENV_FILE="$ROOT_DIR/.env"
if [ -f "$ENV_FILE" ]; then
  set -a
  . "$ENV_FILE"
  set +a
else
  echo "Warning: $ENV_FILE not found. Continuing without loading .env"
fi

if ! command -v envsubst >/dev/null 2>&1; then
  echo "envsubst is required but not installed. Install gettext (`apt install gettext`) or render the file manually."
  exit 1
fi

envsubst < alertmanager/config.yml.template > alertmanager/config.yml
echo "Rendered alertmanager/config.yml"
