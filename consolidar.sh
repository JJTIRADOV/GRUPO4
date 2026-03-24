#!/bin/bash

while true; do
        for archivo in "$ENTORNO/entrada"/*.txt; do
            if [ -f "$archivo" ]; then
                cat "$archivo" >> "$SALIDA/$FILENAME.txt"
                mv "$archivo" "$ENTORNO/procesado/"
            fi
        done
        sleep 5
    done
