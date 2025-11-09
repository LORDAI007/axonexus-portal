import os
from fastapi import FastAPI
import psycopg

app = FastAPI(title="Axonexus Health Index API")

@app.get("/")
def root():
    return {"ok": True, "name": "Axonexus Health Index API"}

@app.get("/ledger/certainty/latest")
def latest():
    dsn = (
        f"host={os.getenv('PG_HOST')} "
        f"port={os.getenv('PG_PORT')} "
        f"dbname={os.getenv('PG_DATABASE')} "
        f"user={os.getenv('PG_USER')} "
        f"password={os.getenv('PG_PASSWORD')} "
        "sslmode=require"
    )
    try:
        with psycopg.connect(dsn) as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT NOW()")
                ts = cur.fetchone()[0].isoformat()
        return {"source": "core", "status": "OK", "timestamp": ts}
    except Exception as e:
        return {"source": "core", "status": "INIT", "details": {"error": str(e)}}
