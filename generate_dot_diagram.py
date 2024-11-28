import os
import re
from graphviz import Digraph

# Ruta a la carpeta con los archivos SQL
ruta_carpeta_sql = "MODELS/DIM"
archivos_sql = [f for f in os.listdir(ruta_carpeta_sql) if f.endswith('.sql')]

# Expresiones regulares para extraer información
regex_create_table = r"CREATE OR REPLACE TABLE\s+([\w.]+)"

regex_from = r"(?:FROM|JOIN)\s+([\w.]+)"
regex_with = r"WITH\s+([\w.]+)\s+AS"

# Diccionario para almacenar dependencias
dependencias = {}

# Procesar cada archivo SQL
for archivo in archivos_sql:
    with open(os.path.join(ruta_carpeta_sql, archivo), 'r') as file:
        sql_content = file.read().upper()
        # Encontrar la tabla creada
        tabla_creada = re.search(regex_create_table, sql_content)
        print (tabla_creada)
        if tabla_creada:
            tabla_creada = tabla_creada.group(1)
            dependencias[tabla_creada] = set()

            # Encontrar las tablas referenciadas
            tablas_fuente = re.findall(regex_from, sql_content) + re.findall(regex_with, sql_content)
            for tabla in tablas_fuente:
                dependencias[tabla_creada].add(tabla)

# Crear el archivo .dot
dot = Digraph(comment="Dependencias entre Tablas")
for tabla, fuentes in dependencias.items():
    for fuente in fuentes:
        dot.edge(fuente, tabla)

# Guardar el archivo .dot
archivo_dot = "dependencias.dot"
dot.save(filename=archivo_dot)

print(f"Archivo .dot generado: {archivo_dot}")

