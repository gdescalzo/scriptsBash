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
nombre="$dates-$router.conf.gz"

## Comienzo del script

sshpass -p $password ssh -l $user -o StrictHostKeyChecking=no $ip 'show configuration | display set | no-more' >  /bkp/hosts_firewalls/$service/$nombre 2>> /var/log/bkp/error.log
flag=$(echo $?)

if [ $flag -ne 0 ]; then
    echo "$dates | $dates1 | Servicio $service | Equipo: $router | IP: $ip | Backup con errores"  >> /var/log/bkp/error.log
    echo " "  >> /var/log/bkp/error.log
else
    echo "$dates | $dates1 | Servicio $service | Equipo: $router | IP: $ip | Backup Realizado"  >> /var/log/bkp/bkp.log
fi

exit 0
