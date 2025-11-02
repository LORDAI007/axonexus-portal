#!/usr/bin/env bash
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel || echo ".")"
cd "$ROOT"

TODAY="$(date -u +'%Y-%m-%d')"

if [[ -f scripts/generate_sitemap.py ]]; then
  echo "▶ Regenerando sitemap con generate_sitemap.py…"
  python3 scripts/generate_sitemap.py
else
  echo "▶ Actualizando <lastmod> en sitemap.xml…"
  if [[ ! -f sitemap.xml ]]; then
    echo "❌ No existe sitemap.xml en la raíz del repo"; exit 1
  fi
  sed -i "s|<lastmod>[^<]*</lastmod>|<lastmod>${TODAY}</lastmod>|g" sitemap.xml
fi

# Asegura que estas URLs mínimas estén presentes
for u in "https://axonexus.net/" "https://axonexus.net/sections/universidad.html"; do
  if ! grep -q "$u" sitemap.xml; then
    awk -v URL="$u" -v LM="$TODAY" '
      /<\/urlset>/ && !done {
        print "  <url>\n    <loc>" URL "</loc>\n    <lastmod>" LM "</lastmod>\n    <changefreq>weekly</changefreq>\n    <priority>0.90</priority>\n  </url>"
        done=1
      }1' sitemap.xml > sitemap.xml.tmp && mv sitemap.xml.tmp sitemap.xml
  fi
done

echo "✔ sitemap.xml listo."
