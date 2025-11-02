#!/usr/bin/env bash
set -euo pipefail
SITEMAP_URL="https://axonexus.net/sitemap.xml"

echo "▶ Ping Google"
curl -fsS "https://www.google.com/ping?sitemap=${SITEMAP_URL}" >/dev/null || echo "Aviso: ping Google no confirmado"

echo "▶ Ping Bing"
curl -fsS "https://www.bing.com/ping?sitemap=${SITEMAP_URL}" >/dev/null || echo "Aviso: ping Bing no confirmado"

echo "✔ Motores notificados."
