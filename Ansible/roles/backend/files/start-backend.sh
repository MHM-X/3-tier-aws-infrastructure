#!/bin/bash
set -euo pipefail

SECRET_JSON=$(aws secretsmanager get-secret-value \
  --secret-id "white/production/database" \
  --region "eu-north-1" \
  --query SecretString \
  --output text)

DATABASE_URL=$(python3 -c \
  'import json,sys; print(json.load(sys.stdin)["DATABASE_URL"])' \
  <<< "$SECRET_JSON")

export DATABASE_URL

cd /opt/white
docker compose up -d
