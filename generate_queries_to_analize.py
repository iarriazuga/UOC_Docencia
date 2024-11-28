'''
Usando python quiero que proceses un archivo de texto de la siquiente manera, dentro del fichero estan diversas descripciones de tablas de esta forma 

-- ARCHIVO: MODELS\POST\POST_DADES_ACADEMIQUES.sql
CREATE OR REPLACE TABLE DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES (
FROM DB_UOC_PROD.DDP_DOCENCIA.STAGE_DADES_ACADEMIQUES_COCO
FROM DB_UOC_PROD.DDP_DOCENCIA.STAGE_DADES_ACADEMIQUES_DIMAX;



quiero que me entregues una modifiacion donde hagas lo siguiente: 

-- ARCHIVO: MODELS\POST\POST_DADES_ACADEMIQUES.sql
SELECT count(*), 'DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES' as table_name from DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES Union all
SELECT count(*), 'DB_UOC_PROD.DDP_DOCENCIA.STAGE_DADES_ACADEMIQUES_COCO' as table_name from DB_UOC_PROD.DDP_DOCENCIA.STAGE_DADES_ACADEMIQUES_COCO  Union all
SELECT count(*), 'DB_UOC_PROD.DDP_DOCENCIA.STAGE_DADES_ACADEMIQUES_DIMAX' as table_name from  DB_UOC_PROD.DDP_DOCENCIA.STAGE_DADES_ACADEMIQUES_DIMAX  Union all

'''
import os

# Configuración
carpeta_raiz = 'MODELS'  # Cambia esto por la ruta de la carpeta raíz
archivo_salida = 'filtrado_resultado.txt'

# Iterar sobre todas las subcarpetas y archivos : 
# VERIFICAR QUE LEEMOS TODO: 
'''for ruta_carpeta, subcarpetas, archivos in os.walk(carpeta_raiz):
    for archivo in archivos:
        ruta_completa = os.path.join(ruta_carpeta, archivo)
        print(f'Leyendo archivo: {ruta_completa}')
        '''


# Crear o limpiar el archivo de salida
with open(archivo_salida, 'w') as salida:
    salida.write('')  # Vaciar el archivo

# Recorrer las subcarpetas y archivos
for ruta_carpeta, subcarpetas, archivos in os.walk(carpeta_raiz):
    for archivo in archivos:
        ruta_completa = os.path.join(ruta_carpeta, archivo)
        # Abrir y procesar solo archivos de texto
        with open(archivo_salida, 'a', encoding='utf-8') as salida:
            salida.write('\n\n\n\n-- ARCHIVO: '+os.path.join(ruta_carpeta, archivo)+ '\n')
        try:
            with open(ruta_completa, 'r', encoding='utf-8') as file:
                for linea in file:
                    linea = linea.split('--')[0].strip() + '\n'
                    if any(keyword in linea.upper() for keyword in ['CREATE OR REPLACE', 'FROM', 'JOIN']):
                        # Guardar la línea en el archivo de salida
                        with open(archivo_salida, 'a', encoding='utf-8') as salida:
                            salida.write(linea)
        except Exception as e:
            print(f"No se pudo procesar el archivo {ruta_completa}: {e}")

print(f"Proceso completado. Las líneas filtradas están en '{archivo_salida}'.")


def remove_characters_before_join(input_file, output_file):
    with open(input_file, 'r') as file:
        lines = file.readlines() 

    updated_lines = []
 
    for line in lines:
        # Find the index of the word 'JOIN' and slice the line
        line = line.upper()
        join_index = line.find('JOIN')
        if join_index != -1:
            updated_lines.append(line[join_index:])  # Keep only from 'JOIN' onward
        else:
            updated_lines.append(line)  # If 'JOIN' not found, keep the line as is

    # Write the updated lines to the output file
    with open(output_file, 'w') as file:
        file.writelines(updated_lines)

# Usage
input_file = 'filtrado_resultado.txt'
output_file = 'archivo_salida.txt'
remove_characters_before_join(input_file, output_file)


import re

def procesar_archivo(input_file, output_file):
    with open(input_file, 'r') as file:
        lines = file.readlines()

    output_lines = []
    table_name = None


    for line in lines:
        
        source_tables = ''

        if line.startswith('-- ARCHIVO:'):
            # Capturamos el nombre del archivo y lo añadimos al output
            output_lines.append('\n\n' + line.strip())
        elif line.startswith('CREATE OR REPLACE TABLE'):
            # Capturamos el nombre de la tabla principal
            match = re.search(r'TABLE\s+([\w.]+)', line)
            if match:
                source_tables = match.group(1)
            output_lines.append(
                f"SELECT '{source_tables}' as table_name , count(*) from {source_tables} Union all"
            )
        elif line.startswith('FROM'):
            # Capturamos las tablas de origen
            match = re.search(r'FROM\s+([\w.]+)', line)
            if match:
                source_tables = match.group(1)
            output_lines.append(
                f"SELECT '{source_tables}' as table_name , count(*) from {source_tables} Union all"
            )
        elif any(keyword in line.upper() for keyword in [ 'JOIN']):
            # Capturamos las tablas de origen
            match = re.search(r'JOIN\s+([\w.]+)', line)
            print(match)
            if match:
                source_tables = match.group(1)
            output_lines.append(
                f"SELECT '{source_tables}' as table_name , count(*) from {source_tables} Union all"
            )

 
        # output_lines[-1] = output_lines[-1].replace(' Union all', '')

    # Guardamos el resultado en un archivo de salida
    with open(output_file, 'w') as file:
        file.write('\n'.join(output_lines))

# Uso del script
input_file = 'archivo_salida.txt'
output_file = 'archivo_salida2.txt'
procesar_archivo(input_file, output_file)


# Nombre del archivo de entrada y salida
input_file = "archivo_salida2.txt"
output_file = "archivo_salida3.txt"

# Leer y procesar el archivo
with open(input_file, "r") as infile, open(output_file, "w") as outfile:
    for line in infile:
        # Buscar la palabra FROM en la línea
        line = line.upper()
        if "FROM" in line:
            # Obtener la parte después de "FROM"
            after_from = line.split("FROM", 1)[1].strip()
            # Si contiene un punto, escribir la línea en el archivo de salida
            if "." in after_from:
                outfile.write(line)
        else:
            # Si no contiene FROM, escribir la línea en el archivo de salida
            outfile.write(line)