#!/bin/bash

## Definimos la fecha
dates=`date +%Y-%m-%d`

## Capturamos la variable ($router) de master.sh
nombre=$1
service=$2

## Modificamos el archivo temporal de bkp-ssh-txt.sh
cat /tmp/bkp-huawei-tmp.log | grep -v "  ---- More ----" | sed '$d' | sed '$d' | sed '$d' > /bkp/$service/$dates-$nombre.cfg

## Borramos el archivo temporal de bkp-ssh-txt.sh y bkp-telnet-txt.sh
rm /tmp/bkp-huawei-tmp.log

exit 0