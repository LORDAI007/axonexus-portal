-- ============================================================
-- 📊 Axonexus Health Index v1.0 — Estructura de base de datos
-- Instituto Soberano Axonexus | Gobernanza Predictiva
-- ============================================================

-- Tabla de instituciones monitoreadas
CREATE TABLE IF NOT EXISTS axhi_instituciones (
  id SERIAL PRIMARY KEY,
  nombre TEXT NOT NULL,
  region TEXT,
  responsable TEXT,
  correo TEXT,
  creado_en TIMESTAMP DEFAULT NOW()
);

-- Registro de latidos cada 5 minutos
CREATE TABLE IF NOT EXISTS axhi_latidos (
  id SERIAL PRIMARY KEY,
  institucion_id INT REFERENCES axhi_instituciones(id),
  timestamp TIMESTAMP DEFAULT NOW(),
  estado VARCHAR(10) CHECK (estado IN ('OK','WARN','FAIL')),
  fuente TEXT,
  hash_sha256 TEXT,
  observacion TEXT
);

-- Tabla de hashes publicados (CertChain local)
CREATE TABLE IF NOT EXISTS axhi_hashes_publicados (
  id SERIAL PRIMARY KEY,
  periodo VARCHAR(16),
  hash_oficial TEXT,
  url_certificado TEXT,
  registrado_en TIMESTAMP DEFAULT NOW()
);

-- Vista resumen: estado actual por institución
CREATE OR REPLACE VIEW axhi_estado_actual AS
SELECT 
  i.nombre AS institucion,
  l.estado,
  l.timestamp AS ultima_actualizacion,
  l.hash_sha256
FROM axhi_instituciones i
JOIN LATERAL (
  SELECT estado, timestamp, hash_sha256
  FROM axhi_latidos
  WHERE institucion_id = i.id
  ORDER BY timestamp DESC
  LIMIT 1
) l ON TRUE;

-- ============================================================
-- Fin del esquema
-- ============================================================
