#!/bin/bash

## Capturamos las variables del master.sh
user=$1
ip=$2
password=$3
router=$4
service=$5
server=$6

## Comienzo de script
dates=$(date "+%Y-%m-%d")
dates1=$(date "+%H:%M:%S")
nombre="$dates-$router"

## Copiamos el rool de "cachednsadmin"
sshpass -p $password scp $user@$ip:/cachednsadmin/* /tmp/secure64/ && tar cvzfP /bkp/$service/$nombre-cachednsadmin.tar.gz /tmp/secure64/ 2>> /var/log/bkp/error.log && rm /tmp/secure64/.s* /tmp/secure64/*

## Copiamos el rool de "backup/files"
sshpass -p $password scp $user@$ip:/backup/files/* /tmp/secure64/ && tar cvzfP /bkp/$service/$nombre-backup-files.tar.gz /tmp/secure64/ 2>> /var/log/bkp/error.log && rm /tmp/secure64/*
flag=$(echo $?)

if [ $flag -ne 0 ]; then
    echo "$dates | $dates1 | Servicio $service | Equipo: $router | IP: $ip | Backup con errores"  >> /var/log/bkp/error.log
    echo " "  >> /var/log/bkp/error.log
else
    echo "$dates | $dates1 | Servicio $service | Equipo: $router | IP: $ip | Backup Realizado"  >> /var/log/bkp/bkp.log
fi

exit 0
