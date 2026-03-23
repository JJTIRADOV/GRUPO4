#!/bin/bash

# Parametro optativo -d
if [ "$1" = "-d" ]; then
    echo "Borrando entorno EPNro1 y matando procesos en background..."
    pkill -f "consolidar"
    rm -rf "$HOME/EPNro1"
    echo "Listo."
    exit 0
fi

# Verificar que FILENAME esté definida
if [ -z "$FILENAME" ]; then
    echo "Error: la variable de entorno FILENAME no está definida."
    echo "Ejemplo: export FILENAME=alumnos"
    exit 1
fi

ENTORNO="$HOME/EPNro1"
SALIDA="$ENTORNO/salida"
ARCHIVO="$SALIDA/$FILENAME.txt"

# Funcion consolidar que corre en background
consolidar() {
    while true; do
        for archivo in "$ENTORNO/entrada"/*.txt; do
            if [ -f "$archivo" ]; then
                cat "$archivo" >> "$SALIDA/$FILENAME.txt"
                mv "$archivo" "$ENTORNO/procesado/"
            fi
        done
        sleep 5
    done
}

while true; do
    echo ""
    echo "=== MENU ==="
    echo "1) Crear entorno"
    echo "2) Correr proceso"
    echo "3) Listar alumnos ordenados por padron"
    echo "4) Mostrar las 10 notas mas altas"
    echo "5) Buscar alumno por padron"
    echo "6) Salir"
    echo ""
    read -p "Ingrese una opcion: " opcion

    case $opcion in
        1)
            mkdir -p "$ENTORNO/entrada"
            mkdir -p "$ENTORNO/salida"
            mkdir -p "$ENTORNO/procesado"
            echo "Entorno creado en $ENTORNO"
            ;;
        2)
            if [ ! -d "$ENTORNO" ]; then
                echo "Primero debe crear el entorno (opcion 1)."
            else
                consolidar &
                echo "Proceso consolidar corriendo en background (PID $!)"
            fi
            ;;
        3)
            if [ ! -f "$ARCHIVO" ]; then
                echo "No existe el archivo $ARCHIVO"
            else
                echo "Alumnos ordenados por padron:"
                sort -k1,1n "$ARCHIVO"
            fi
            ;;
        4)
            if [ ! -f "$ARCHIVO" ]; then
                echo "No existe el archivo $ARCHIVO"
            else
                echo "Las 10 notas mas altas:"
                sort -k5 -n "$ARCHIVO" | tail -n10
            fi
            ;;
        5)
            read -p "Ingrese el nro de padron: " padron
            if [ ! -f "$ARCHIVO" ]; then
                echo "No existe el archivo $ARCHIVO"
            else
                resultado=$(grep "^$padron " "$ARCHIVO")
                if [ -z "$resultado" ]; then
                    echo "No se encontro el padron $padron"
                else
                    echo "$resultado"
                fi
            fi
            ;;
        6)
            echo "Saliendo..."
            exit 0
            ;;
        *)
            echo "Opcion invalida."
            ;;
    esac
done
