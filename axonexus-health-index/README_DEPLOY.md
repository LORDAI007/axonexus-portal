# ⚙️ Axonexus Health Index v1.0 — Deployment Guide

## 🧩 Descripción

El **Axonexus Health Index (AHXI)** es un sistema de *certeza operativa* para infraestructura crítica (agua, energía, gestión municipal).  
Registra y verifica eventos cada **5 minutos**, generando hashes verificables (SHA-256) y publicándolos en el **Ledger Predictivo Axonexus**.

---

## 🚀 Requisitos

- Python 3.9 o superior  
- PostgreSQL / Supabase  
- Acceso SSH o entorno con `psql`  
- Dependencias: `fastapi`, `uvicorn`, `psycopg2-binary`, `python-dotenv`

---

## 🔐 Configuración inicial

1. Copia el archivo de entorno:
   ```bash
   cp .env.example .env
