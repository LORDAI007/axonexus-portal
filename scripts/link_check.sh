#!/usr/bin/env bash
set -euo pipefail

BASE="https://axonexus.net"
URLS=(
  "$BASE/"
  "$BASE/sections/universidad.html"
  "$BASE/arquitectura.html"
  "$BASE/jurisprudencia.html"
  "$BASE/prensa.html"
  "$BASE/healthz.html"
  "$BASE/sitemap.xml"
  "$BASE/robots.txt"
)

FAIL=0
for u in "${URLS[@]}"; do
  code="$(curl -s -o /dev/null -w '%{http_code}' "$u")" || code="000"
  if [[ "$code" =~ ^2|3 ]]; then
    echo "✔ $u  → $code"
  else
    echo "✖ $u  → $code"; FAIL=1
  fi
done

# No bloquea el job principal
exit 0
