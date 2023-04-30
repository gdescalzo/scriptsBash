#!/bin/bash

## Definimos la fecha
#dates=`date +%Y-%m-%d`

## Capturamos la variable ($router) de master.sh
#nombre=$1
#service=$2

## Comprimimos los 3 archivos de backup y lo movemos al directorio de Sandvine
#rar a /bkp/$service/$dates-$nombre.rar /tmp/sandvine/

## Borramos los archivos temporales
rm /tmp/sandvine/*

exit 0