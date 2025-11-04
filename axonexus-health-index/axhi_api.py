# ============================================================
# 🧠 Axonexus Health Index API
# Endpoint público: /ledger/certainty/latest
# ============================================================

from fastapi import FastAPI
from datetime import datetime
import psycopg2
import os
import hashlib
from dotenv import load_dotenv

load_dotenv()
app = FastAPI(title="Axonexus Health Index API")

# Conexión a la base de datos
def get_conn():
    return psycopg2.connect(
        host=os.getenv("PG_HOST", "localhost"),
        database=os.getenv("PG_DATABASE", "axonexus"),
        user=os.getenv("PG_USER", "postgres"),
        password=os.getenv("PG_PASSWORD", "password"),
        port=os.getenv("PG_PORT", "5432")
    )

@app.get("/ledger/certainty/latest")
def get_latest_status():
    """
    Retorna el estado más reciente de cada institución.
    """
    try:
        conn = get_conn()
        cur = conn.cursor()
        cur.execute("""
            SELECT institucion, estado, ultima_actualizacion, hash_sha256
            FROM axhi_estado_actual
            ORDER BY institucion;
        """)
        data = cur.fetchall()
        cur.close()
        conn.close()

        result = []
        for row in data:
            result.append({
                "institucion": row[0],
                "estado": row[1],
                "ultima_actualizacion": row[2].strftime("%Y-%m-%d %H:%M:%S"),
                "hash_sha256": row[3]
            })
        return {"timestamp": datetime.utcnow(), "data": result}

    except Exception as e:
        return {"error": str(e)}

# ============================================================
# Generador SHA-256 local (para verificación manual)
# ============================================================

@app.post("/ledger/hash")
def generate_hash(content: str):
    """
    Retorna el hash SHA-256 de una cadena de texto.
    """
    hash_object = hashlib.sha256(content.encode())
    return {"hash_sha256": hash_object.hexdigest()}
