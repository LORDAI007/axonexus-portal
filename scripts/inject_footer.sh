#!/usr/bin/env bash
set -euo pipefail

FOOTER_FILE="footer-axonexus.html"
MARKER="<!-- axnx-footer -->"

if [[ ! -f "${FOOTER_FILE}" ]]; then
  echo "❌ No encuentro ${FOOTER_FILE} en la raíz del repo"; exit 1
fi

# Escapar contenido para sed
FOOTER_ESCAPED=$(printf '%s\n' "${MARKER}\n$(cat "${FOOTER_FILE}")" | sed -e 's/[\/&]/\\&/g' -e 's/$/\\n/g')

# Iterar todos los .html excepto el propio footer
while IFS= read -r -d '' file; do
  # Saltar el archivo del footer
  [[ "${file}" == *"/footer-axonexus.html" ]] && continue

  # Evitar duplicados si ya hay marcador
  if grep -q "${MARKER}" "${file}"; then
    echo "↷ Ya inyectado: ${file}"
    continue
  fi

  if grep -qi '</body>' "${file}"; then
    sed -i "s#</body>#${FOOTER_ESCAPED}\n</body>#I" "${file}"
    echo "✅ Inyectado en: ${file}"
  else
    # Si no tiene </body>, lo anexamos al final
    printf '\n%s\n' "${MARKER}" >> "${file}"
    cat "${FOOTER_FILE}" >> "${file}"
    echo "⚠️  Sin </body>, añadido al final: ${file}"
  fi
done < <(find . -type f -name "*.html" -print0)

echo "✔ Inyección de footer completada."


