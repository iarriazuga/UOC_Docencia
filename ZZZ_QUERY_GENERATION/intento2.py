def procesar_archivo_multiples_tablas(archivo_entrada, archivo_salida):
    with open(archivo_entrada, 'r') as entrada:
        lineas = [linea.strip() for linea in entrada if linea.strip()]  # Leer y limpiar líneas

    resultado = []
    bloque_actual = []  # Para almacenar las líneas de un bloque

    for linea in lineas:
        if linea.startswith("-- ARCHIVO:"):  # Detectar inicio de un nuevo bloque
            if bloque_actual:
                # Procesar el bloque anterior
                resultado.extend(procesar_bloque(bloque_actual))
            bloque_actual = [linea]  # Reiniciar el bloque actual
        else:
            bloque_actual.append(linea)

    # Procesar el último bloque si existe
    if bloque_actual:
        resultado.extend(procesar_bloque(bloque_actual))

    # Guardar el resultado en el archivo de salida
    with open(archivo_salida, 'w') as salida:
        salida.write("\n".join(resultado))

    print(f"Archivo procesado. Resultado guardado en: {archivo_salida}")


def procesar_bloque(bloque):
    if len(bloque) < 2:
        return []  # Si el bloque tiene menos de dos líneas, no hay nada que procesar

    columna_referencia = bloque[1]  # Segunda línea como columna de referencia
    tablas_restantes = bloque[2:]  # Resto de las líneas a procesar

    # Generar combinaciones para el bloque
    return [
        f"{tabla} , {columna_referencia}" for tabla in tablas_restantes
    ]



# Ejecución del script
archivo_entrada = 'archivo_salida4.txt'
archivo_salida = 'archivo_salida5.txt'

 
 

procesar_archivo_multiples_tablas(archivo_entrada, archivo_salida)