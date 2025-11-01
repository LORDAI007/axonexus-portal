#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Generador de sitemap.xml para AXONEXUS
- Escanea archivos .html en la raíz y /sections
- Asigna prioridad/frecuencia por ruta clave
- Usa mtime de los archivos como <lastmod> (UTC)
"""

from __future__ import annotations
import os, sys, pathlib, datetime
from xml.etree.ElementTree import Element, SubElement, ElementTree

BASE_URL = "https://axonexus.net"
ROOT = pathlib.Path(__file__).resolve().parent.parent  # repo root

# Rutas a considerar
INCLUDE_DIRS = [ROOT, ROOT / "sections"]
EXCLUDE_FILES = {
    "404.html",
}

# Políticas imperiales por ruta/archivo
FREQ_DEFAULT = "monthly"
PRIO_DEFAULT = 0.80

SPECIAL = {
    "index.html":            {"loc": "/",                          "changefreq": "weekly",  "priority": 1.00},
    "sections/universidad.html": {"loc": "/sections/universidad.html","changefreq": "weekly",  "priority": 0.90},
    "arquitectura.html":     {"loc": "/arquitectura.html",          "changefreq": "monthly", "priority": 0.85},
    "jurisprudencia.html":   {"loc": "/jurisprudencia.html",        "changefreq": "monthly", "priority": 0.85},
    "prensa.html":           {"loc": "/prensa.html",                "changefreq": "monthly", "priority": 0.80},
    "economia.html":         {"loc": "/economia.html",              "changefreq": "monthly", "priority": 0.80},
    "core.html":             {"loc": "/core.html",                  "changefreq": "monthly", "priority": 0.75},
    "healthz.html":          {"loc": "/healthz.html",               "changefreq": "monthly", "priority": 0.20},
}

def file_to_route(p: pathlib.Path) -> dict:
    rel = p.relative_to(ROOT).as_posix()
    if rel in EXCLUDE_FILES:
        return {}
    # Coincidencias especiales
    if rel in SPECIAL:
        d = SPECIAL[rel].copy()
        return d
    # También soporta sections/*
    if rel.startswith("sections/") and rel.endswith(".html"):
        return {"loc": "/" + rel, "changefreq": FREQ_DEFAULT, "priority": PRIO_DEFAULT}
    # Raíz *.html genérica
    if "/" not in rel and rel.endswith(".html"):
        return {"loc": "/" + rel, "changefreq": FREQ_DEFAULT, "priority": PRIO_DEFAULT}
    return {}

def lastmod_utc(p: pathlib.Path) -> str:
    ts = datetime.datetime.utcfromtimestamp(p.stat().st_mtime)
    return ts.strftime("%Y-%m-%d")

def build():
    urlset = Element("urlset", xmlns="http://www.sitemaps.org/schemas/sitemap/0.9")

    seen = set()
    for d in INCLUDE_DIRS:
        if not d.exists():
            continue
        for p in d.rglob("*.html"):
            route = file_to_route(p)
            if not route: 
                continue
            loc = route["loc"]
            if loc in seen:
                continue
            seen.add(loc)

            url = SubElement(urlset, "url")
            SubElement(url, "loc").text = BASE_URL + ("" if loc == "/" else loc)
            SubElement(url, "lastmod").text = lastmod_utc(p)
            SubElement(url, "changefreq").text = route["changefreq"]
            SubElement(url, "priority").text = f'{route["priority"]:.2f}'

    # Guardar
    out = ROOT / "sitemap.xml"
    tree = ElementTree(urlset)
    tree.write(out, encoding="utf-8", xml_declaration=True)
    print(f"✅ Generado {out} con {len(seen)} URL(s).")

if __name__ == "__main__":
    try:
        build()
    except Exception as e:
        print(f"❌ Error: {e}", file=sys.stderr)
        sys.exit(1)
