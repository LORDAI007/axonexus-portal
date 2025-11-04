#!/bin/bash
# ============================================================
# 🚀 Axonexus Health Index v1.0 — Deployment Script
# ============================================================

echo "🔱 Iniciando despliegue del Axonexus Health Index..."

# 1️⃣ Activar entorno virtual (si aplica)
python3 -m venv venv
source venv/bin/activate

# 2️⃣ Instalar dependencias
pip install fastapi uvicorn psycopg2-binary python-dotenv

# 3️⃣ Cargar variables de entorno
if [ -f ".env" ]; then
  export $(cat .env | xargs)
  echo "✅ Variables de entorno cargadas."
else
  echo "⚠️ Archivo .env no encontrado. Copia desde .env.example y edita tus credenciales."
  exit 1
fi

# 4️⃣ Migrar base de datos
echo "🗃️ Aplicando esquema SQL..."
psql -h $PG_HOST -U $PG_USER -d $PG_DATABASE -p $PG_PORT -f axhi_schema.sql

# 5️⃣ Iniciar servidor FastAPI
echo "🧠 Ejecutando API en puerto ${APP_PORT:-8000}..."
uvicorn axhi_api:app --host 0.0.0.0 --port ${APP_PORT:-8000}

echo "⚡ Despliegue completado."
