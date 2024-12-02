

def eliminar_antes_de_from_en_archivo(archivo_entrada, archivo_salida):
    with open(archivo_entrada, 'r') as entrada, open(archivo_salida, 'w') as salida:
        for linea in entrada:
            # Si "FROM" está en la línea, elimina lo que viene antes
            if "FROM" in linea:
                nueva_linea = linea.split("FROM", 1)[1]
                salida.write(nueva_linea)
            else:
                # Si no contiene "FROM", escribe la línea tal cual
                salida.write(linea)

# Nombres de los archivos
archivo_entrada = "archivo_salida3.txt"
archivo_salida = "archivo_salida4.txt"

# Llamar a la función
eliminar_antes_de_from_en_archivo(archivo_entrada, archivo_salida)

print(f"Archivo procesado. Revisa el archivo '{archivo_salida}'.")



import pandas as pd

# Ruta del archivo de texto
file_path = 'archivo_salida4.txt'

# Leer el archivo de texto
with open(file_path, 'r') as file:
    content = file.read()

# Dividir el contenido por secciones de archivos
sections = content.split('-- ARCHIVO:')
sections = [section.strip() for section in sections if section.strip()]

# Preparar la lista de datos para la tabla
table_data = []

for section in sections:
    # Dividir líneas dentro de cada sección
    lines = section.split('\n')
    
    # La primera línea es la referencia
    reference = lines[0].strip()
    
    # El resto son las fuentes
    sources = [line.strip() for line in lines[1:] if line.strip()]
    
    # Generar las filas de la tabla
    for source in sources:
        table_data.append([source, reference])

# Crear el DataFrame
df = pd.DataFrame(table_data, columns=['Source', 'Reference'])

# Guardar el resultado en un archivo CSV o mostrarlo
output_path = 'output_table.csv'
df.to_csv(output_path, index=False)

print(f"Tabla generada y guardada en '{output_path}'.")