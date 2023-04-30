#!/bin/bash

#Backup de la DB
sshpass -p t0km3la ssh -l mrse -b 172.18.74.70  192.168.191.138 mysqldump -h 127.0.0.1 -u root -pn0T1ad0y wikigrip > /bkp/hosts_wikigrip/mysql-dumps/$(date +"%Y-%m-%d")-wikigrip-db.sql 

#Backup de la configuracion de Apache 2
sshpass -p t0km3la ssh -l mrse -b 172.18.74.70 192.168.191.138 "tar -cvzf - /etc/apache2" > /bkp/hosts_wikigrip/configs-apache2/$(date +"%Y-%m-%d")-wikigrip-apache2.tar.gz

#Backup de la configuracion de Mediawiki
sshpass -p t0km3la ssh -l mrse -b 172.18.74.70 192.168.191.138 "tar -cvzf - /var/lib/mediawiki" > /bkp/hosts_wikigrip/configs-mediawiki/$(date +"%Y-%m-%d")-wikigrip-mediawiki.tar.gz
