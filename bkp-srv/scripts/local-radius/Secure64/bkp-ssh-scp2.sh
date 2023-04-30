#!/bin/bash

## Capturamos las variables del master.sh
user=$1
ip=$2
password=$3
router=$4
service=$5
server=$6

## Comienzo de script

## Copiamos el rool de "cachednsadmin"
sshpass -p $password scp $user@$ip:/cachednsadmin/* /tmp/secure64/ && tar cvzf /bkp/$service/$(date '+%y-%m-%d')-$router-cachednsadmin.tar.gz /tmp/secure64/ && rm /tmp/secure64/.s* /tmp/secure64/*

## Copiamos el rool de "backup/files"
sshpass -p $password scp $user@$ip:/backup/files/* /tmp/secure64/ && tar cvzf /bkp/$service/$(date '+%y-%m-%d')-$router-backup-files.tar.gz /tmp/secure64/ && rm /tmp/secure64/*

exit 0
