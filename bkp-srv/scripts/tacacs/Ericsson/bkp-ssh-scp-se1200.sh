#!/bin/bash

## Capturamos las variables del master.sh
user=$1
ip=$2
password=$3
router=$4
service=$5
server=$6

dates=$(date "+%Y-%m-%d")
dates1=$(date "+%H:%M:%S")
nombre="$dates-$router.cfg"

## Comienzo del script

sshpass -p $password scp -oStrictHostKeyChecking=no $user@$ip:/md/ericsson.cfg  /bkp/$service/$nombre 2>> /var/log/bkp/error.log
#sshpass -p n0T1ad0y scp -oStrictHostKeyChecking=no grip@192.168.96.11:/md/ericsson.cfg /bkp/hosts_ags/prueba-SSAVN01.cfg
flag=$(echo $?)

if [ $flag -ne 0 ]; then
    echo "$dates | $dates1 | Servicio $service | Equipo: $router | IP: $ip | Backup con errores"  >> /var/log/bkp/error.log
    echo " "  >> /var/log/bkp/error.log
else
    echo "$dates | $dates1 | Servicio $service | Equipo: $router | IP: $ip | Backup Realizado"  >> /var/log/bkp/bkp.log
fi

exit 0