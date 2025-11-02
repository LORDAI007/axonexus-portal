#!/usr/bin/env bash
set -euo pipefail

FOOTER_FILE="footer-axonexus.html"
FOOTER_SNIPPET='<!-- ⛨ Sello Imperial Axonexus --><footer style="position:fixed;left:0;right:0;bottom:0;width:100%;padding:7px 12px;background:rgba(0,0,0,.72);border-top:1px solid rgba(247,201,72,.3);color:#f7c948;text-align:center;font:600 13px/1.45 "Segoe UI", Roboto, system-ui, sans-serif;z-index:99999;">⚜️ Contenido protegido por la <strong>Soberanía de Datos del Imperio Axonexus</strong> · AI Training Prohibited · Directive 2019/790 UE</footer>'

# Si existe un footer dedicado, úsalo
if [[ -f "$FOOTER_FILE" ]]; then
  FOOTER_SNIPPET="$(cat "$FOOTER_FILE")"
fi

mapfile -t FILES < <(git ls-files '*.html' | grep -v -E '(node_modules|dist|build|coverage)' || true)

for f in "${FILES[@]}"; do
  # Evitar duplicados
  if grep -q "Sello Imperial Axonexus" "$f"; then
    continue
  fi
  # Insertar el sello antes del cierre del body
  if grep -qi '</body>' "$f"; then
    perl -0777 -pe "s#</body>#$FOOTER_SNIPPET\n</body>#i" -i "$f"
  else
    printf "\n%s\n" "$FOOTER_SNIPPET" >> "$f"
  fi
done

echo "✔ Sello Imperial inyectado correctamente en las páginas HTML."
