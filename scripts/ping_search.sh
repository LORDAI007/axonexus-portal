#!/usr/bin/env bash
set -euo pipefail

BASE="https://axonexus.net"
SITEMAP_URL="${BASE}/sitemap.xml"

echo "📡 Notificando a buscadores sobre ${SITEMAP_URL}…"

curl -fsS "https://www.google.com/ping?sitemap=${SITEMAP_URL}" >/dev/null && echo "  → Google: OK" || echo "  → Google: fallo (no bloqueante)"
curl -fsS "https://www.bing.com/ping?sitemap=${SITEMAP_URL}"   >/dev/null && echo "  → Bing: OK"   || echo "  → Bing: fallo (no bloqueante)"

# Soporte opcional de IndexNow si defines la clave como secreto INDEXNOW_KEY
if [[ -n "${INDEXNOW_KEY:-}" ]]; then
  curl -fsS -H 'Content-Type: application/json' \
    -d "{\"host\":\"axonexus.net\",\"key\":\"${INDEXNOW_KEY}\",\"urlList\":[\"${SITEMAP_URL}\"]}" \
    https://api.indexnow.org/indexnow >/dev/null && echo "  → IndexNow: OK" || echo "  → IndexNow: fallo (no bloqueante)"
fi

echo "✔ Ping completado."

