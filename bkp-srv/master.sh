#!/bin/bash
## Definimos el servidor de Backup (IP)
server=xxx.xxx.xxx.xxx
service=$1

echo "Comienzo proceso de backup $service" >> /var/log/bkp/bkp.log
## echo "PID:" $$ "DATE: "`date +%d/%m/%Y' '%H:%M:%S` >> /var/log/bkp/bkp.log

#Para probar 1 equipo en particular (solo cambiar donde dice where IP='')
#query=`mysql --host=localhost --user=root --password=root01 -D bkp-srv -e "SELECT H.ip,C.community,V.vendor,H.port,T.type,L.login,AES_DECRYPT(L.password,'alagrandelepusekuka'),AES_DECRYPT (E.password_en,'alagrandelepusekuka'),H.host , Z.id_login_type, Z.comment as login_comment FROM $service AS H INNER JOIN data_community AS C ON C.id_community = H.id_community INNER JOIN data_vendor AS V ON H.id_vendor = V.id_vendor INNER JOIN data_type AS T ON H.id_type = T.id_type INNER JOIN data_login AS L ON H.id_login = L.id_login INNER JOIN data_enable AS E ON H.id_enable = E.id_enable INNER JOIN login_type AS Z ON Z.id_login_type = H.login_type where state='1' and IP='200.63.147.74';" | sed "1d"|sed 's/\t/|/g'`

#Para probar por vendor (solo cambiar donde dice where V.id_vendor='')
#query=`mysql --host=localhost --user=root --password=root01 -D bkp-srv -e "SELECT H.ip,C.community,V.vendor,H.port,T.type,L.login,AES_DECRYPT(L.password,'alagrandelepusekuka'),AES_DECRYPT (E.password_en,'alagrandelepusekuka'),H.host , Z.id_login_type, Z.comment as login_comment FROM $service AS H INNER JOIN data_community AS C ON C.id_community = H.id_community INNER JOIN data_vendor AS V ON H.id_vendor = V.id_vendor INNER JOIN data_type AS T ON H.id_type = T.id_type INNER JOIN data_login AS L ON H.id_login = L.id_login INNER JOIN data_enable AS E ON H.id_enable = E.id_enable INNER JOIN login_type AS Z ON Z.id_login_type = H.login_type where V.id_vendor='2' and state='1';" | sed "1d"|sed 's/\t/|/g'`

#Para traer todos los registros en state='2' (osea los desabilitados)
#query=`mysql --host=localhost --user=root --password=root01 -D bkp-srv -e "SELECT H.ip,C.community,V.vendor,H.port,T.type,L.login,AES_DECRYPT(L.password,'alagrandelepusekuka'),AES_DECRYPT(E.password_en,'alagrandelepusekuka'),H.host FROM hosts_eer AS H INNER JOIN data_community AS C ON C.id_community = H.id_community INNER JOIN data_vendor AS V ON H.id_vendor = V.id_vendor INNER JOIN data_type AS T ON H.id_type = T.id_type INNER JOIN data_login AS L ON H.id_login = L.id_login INNER JOIN data_enable AS E ON H.id_enable = E.id_enable where state='2';" | sed "1d"|sed 's/\t/|/g'`

#Para traer todos los registros
#query=`mysql --host=localhost --user=root --password=root01 -D bkp-srv -e "SELECT H.ip,C.community,V.vendor,H.port,T.type,L.login,AES_DECRYPT(L.password,'alagrandelepusekuka'),AES_DECRYPT(E.password_en,'alagrandelepusekuka'),H.host FROM $service AS H INNER JOIN data_community AS C ON C.id_community = H.id_community INNER JOIN data_vendor AS V ON H.id_vendor = V.id_vendor INNER JOIN data_type AS T ON H.id_type = T.id_type INNER JOIN data_login AS L ON H.id_login = L.id_login INNER JOIN data_enable AS E ON H.id_enable = E.id_enable;" | sed "1d"|sed 's/\t/|/g'`

#Para traer todos los registros en state='1' (osea los habilitados)
#query=`mysql --host=localhost --user=root --password=root01 -D bkp-srv -e "SELECT H.ip,C.community,V.vendor,H.port,T.type,L.login,AES_DECRYPT(L.password,'alagrandelepusekuka'),AES_DECRYPT(E.password_en,'alagrandelepusekuka'),H.host FROM $service AS H INNER JOIN data_community AS C ON C.id_community = H.id_community INNER JOIN data_vendor AS V ON H.id_vendor = V.id_vendor INNER JOIN data_type AS T ON H.id_type = T.id_type INNER JOIN data_login AS L ON H.id_login = L.id_login INNER JOIN data_enable AS E ON H.id_enable = E.id_enable where state='1';" | sed "1d"|sed 's/\t/|/g'`

#Para traer todos los registros en state='1' (osea los habilitados) y con tacacs, radius o local
## query=`mysql --host=localhost --user=root --password=root01 -D bkp-srv -e "SELECT H.ip,C.community,V.vendor,H.port,T.type,L.login,AES_DECRYPT(L.password,'alagrandelepusekuka'),AES_DECRYPT (E.password_en,'alagrandelepusekuka'),H.host , Z.id_login_type, Z.comment as login_comment FROM $service AS H INNER JOIN data_community AS C ON C.id_community = H.id_community INNER JOIN data_vendor AS V ON H.id_vendor = V.id_vendor INNER JOIN data_type AS T ON H.id_type = T.id_type INNER JOIN data_login AS L ON H.id_login = L.id_login INNER JOIN data_enable AS E ON H.id_enable = E.id_enable INNER JOIN login_type AS Z ON Z.id_login_type = H.login_type where state='1';" | sed "1d"|sed 's/\t/|/g'`


## Inicio del Loop
for i in $query
do

## Parceo de string 
ip=$(echo $i |awk '{print $1 }' | cut -d '|' -f1)
community=$(echo $i |awk '{print $1 }' | cut -d '|' -f2)
vendor=$(echo $i |awk '{print $1 }' | cut -d '|' -f3)
port=$(echo $i |awk '{print $1 }' | cut -d '|' -f4)
type=$(echo $i |awk '{print $1 }' | cut -d '|' -f5)
user=$(echo $i |awk '{print $1 }' | cut -d '|' -f6)
password=$(echo $i |awk '{print $1 }' | cut -d '|' -f7)
password_en=$(echo $i |awk '{print $1 }' | cut -d '|' -f8)
router=$(echo $i |awk '{print $1 }' | cut -d '|' -f9)
login_type=$(echo $i |awk '{print $1 }' | cut -d '|' -f10)
login_comment=$(echo $i |awk '{print $1 }' | cut -d '|' -f11)

## Switch ##
if [ $port = "0" ] && [ $type == "6" ]; then 
/home/mrse/scripts/bkp-snmp.sh $ip $router $servicio $vendor $server 								# SNMP (Cisco/Huawei/Juniper)

###############################################################################################################################################################
##  Local - Radius - Login
###############################################################################################################################################################

### Cisco - SSH
elif [ $port = "22" ] && [ $type = "1" ] && [ $vendor = "1" ] && [ $login_type = "1" ]; then 
/home/mrse/scripts/local-radius/Cisco/bkp-ssh-scp.sh $user $ip $password $password_en $router $service $server 					# SSH - SCP (Cisco)

elif [ $port = "22" ] && [ $type = "2" ] && [ $vendor = "1" ] && [ $login_type = "1" ]; then
/home/mrse/scripts/local-radius/Cisco/bkp-ssh-txt.sh $user $ip $password $password_en $router $service $server 					# SSH - TXT (Cisco)

elif [ $port = "22" ] && [ $type = "9" ] && [ $vendor = "1" ] && [ $login_type = "1" ]; then
/home/mrse/scripts/local-radius/Cisco/bkp-ssh-txt-IOS-XR.sh $user $ip $password $router $service $server 						# SSH - TXT (Cisco IOS XR)

elif [ $port = "22" ] && [ $type = "19" ] && [ $vendor = "1" ] && [ $login_type = "1" ]; then 
/home/mrse/scripts/local-radius/Cisco/bkp-ssh-ftp.sh $user $ip $password $password_en $router $service $server 					# SSH - FTP (Cisco)

elif [ $port = "22" ] && [ $type = "20" ] && [ $vendor = "1" ] && [ $login_type = "1" ]; then 
/home/mrse/scripts/local-radius/Cisco/bkp-ssh-ftp-IOS-XR2.sh $user $ip $password $router $service $server 						# SSH - FTP (Cisco IOS-XR)

elif [ $port = "22" ] && [ $type = "25" ] && [ $vendor = "1" ] && [ $login_type = "1" ]; then 
#/home/mrse/scripts/local-radius/Cisco/bkp-ssh-sftp-ACE.sh $user $ip $password $password_en $router $service $server 			# SSH - SFTP (Balanceadoras Cisco ACE)
/home/mrse/scripts/local-radius/Cisco/bkp-ssh-sftp-ACE.sh $user $ip $password $router $service $server 							# SSH - SFTP (Balanceadoras Cisco ACE)

### Cisco - Telnet
elif [ $port = "23" ] && [ $type = "5" ] && [ $vendor = "1" ] && [ $login_type = "1" ]; then
/home/mrse/scripts/local-radius/Cisco/bkp-telnet-txt.sh $user $ip $password $password_en $router $service $server 				# Telnet - TXT (Cisco)

elif [ $port = "23" ] && [ $type = "3" ] && [ $vendor = "1" ] && [ $login_type = "1" ]; then
/home/mrse/scripts/local-radius/Cisco/bkp-telnet-ftp.sh $user $ip $password $password_en $router $service $server 				# Telnet - FTP (Cisco)

elif [ $port = "23" ] && [ $type = "8" ] && [ $vendor = "1" ] && [ $login_type = "1" ]; then
/home/mrse/scripts/local-radius/Cisco/bkp-telnet-scp.sh $user $ip $password $password_en $router $service $server 				# Telnet - SCP (Cisco)

elif [ $port = "23" ] && [ $type = "4" ] && [ $vendor = "1" ] && [ $login_type = "1" ]; then
/home/mrse/scripts/local-radius/Cisco/bkp-telnet-tftp.sh $user $ip $password $password_en $router $service $server 				# Telnet - TFTP (Cisco)

elif [ $port = "23" ] && [ $type = "12" ] && [ $vendor = "1" ] && [ $login_type = "1" ]; then
/home/mrse/scripts/local-radius/Cisco/bkp-telnet-txt-IOS-XR.sh $user $ip $password $router $service $server 					# Telnet - TXT (Cisco IOS XR)

elif [ $port = "23" ] && [ $type = "15" ] && [ $vendor = "1" ] && [ $login_type = "1" ]; then
/home/mrse/scripts/local-radius/Cisco/bkp-telnet-ftp-IOS-XR.sh $user $ip $password $router $service $server 					# Telnet - FTP (Cisco IOS XR)

## Gigamon - SSH
elif [ $port = "22" ] && [ $type = "13" ] && [ $vendor = "5" ] && [ $login_type = "1" ]; then
/home/mrse/scripts/local-radius/Gigamon/bkp-ssh-txt-2404.sh $user $ip $password $router $service $server 						# SSH - TXT (Gigamon 2404)

elif [ $port = "22" ] && [ $type = "14" ] && [ $vendor = "5" ] && [ $login_type = "1" ]; then
/home/mrse/scripts/local-radius/Gigamon/bkp-ssh-txt-TA.sh $user $ip $password $router $service $server 							# SSH - TXT (Gigamon TA)

elif [ $port = "22" ] && [ $type = "23" ] && [ $vendor = "5" ] && [ $login_type = "1" ]; then
/home/mrse/scripts/local-radius/Gigamon/bkp-ssh-scp-HD.sh $user $ip $password $router $service $server 							# SSH - HD (Gigamon HD)

## Huawei
elif [ $port = "22" ] && [ $type = "2" ] && [ $vendor = "3" ] && [ $login_type = "1" ]; then
/home/mrse/scripts/local-radius/Huawei/bkp-ssh-txt.sh $user $ip $password $server && /home/mrse/scripts/local-radius/Huawei/fix.sh $router $service	# SSH - TXT (Huawei)

elif [ $port = "23" ] && [ $type = "5" ] && [ $vendor = "3" ] && [ $login_type = "1" ]; then
/home/mrse/scripts/local-radius/Huawei/bkp-telnet-txt.sh $user $ip $password  $server && /home/mrse/scripts/local-radius/Huawei/fix.sh $router $service	# Telnet - TXT (Huawei)

## Juniper
elif [ $port = "22" ] && [ $type = "2" ] && [ $vendor = "2" ] && [ $login_type = "1" ]; then
/home/mrse/scripts/local-radius/Juniper/bkp-ssh-txt.sh $user $ip $password $router $service $server 							# SSH - TXT (JunOS)

elif [ $port = "22" ] && [ $type = "17" ] && [ $vendor = "2" ] && [ $login_type = "1" ]; then
/home/mrse/scripts/local-radius/Juniper/bkp-ssh-scp-junos.sh $user $ip $password $router $service $server 						# SSH - SCP - Send/Expect (JunOS)

elif [ $port = "22" ] && [ $type = "27" ] && [ $vendor = "2" ] && [ $login_type = "1" ]; then
/home/mrse/scripts/local-radius/Juniper/bkp-ssh-scp-junos-fwrbs.sh $user $ip $password $router $service $server 				# SSH - TXT - Bash (JunOS - fwrbs)

elif [ $port = "22" ] && [ $type = "28" ] && [ $vendor = "2" ] && [ $login_type = "1" ]; then
/home/mrse/scripts/local-radius/Juniper/bkp-ssh-txt-junos-fwrbs.sh $user $ip $password $router $service $server 				# SSH - TXT - Bash (JunOS - fwrbs)

elif [ $port = "22" ] && [ $type = "29" ] && [ $vendor = "2" ] && [ $login_type = "1" ]; then
/home/mrse/scripts/local-radius/Juniper/bkp-ssh-txt-junos.sh $user $ip $password $router $service $server 						# SSH - TXT - Bash (JunOS - fwrbs)

elif [ $port = "23" ] && [ $type = "5" ] && [ $vendor = "2" ] && [ $login_type = "1" ]; then
/home/mrse/scripts/local-radius/Juniper/bkp-telnet-txt.sh $user $ip $password $router $service $server 							# Telnet - TXT (Juniper)

elif [ $port = "22" ] && [ $type = "16" ] && [ $vendor = "2" ] && [ $login_type = "1" ]; then
/home/mrse/scripts/local-radius/Juniper/bkp-ssh-scp-netscreen.sh $user $ip $password $router $service $server 					# SSH - SCP (Netscreen)

## Sandvine
elif [ $port = "22" ] && [ $type = "7" ] && [ $vendor = "4" ] && [ $login_type = "1" ]; then
/home/mrse/scripts/local-radius/Sandvine/bkp-ssh-scp2.sh $user $ip $password $router $service $server && /home/mrse/scripts/local-radius/Sandvine/fix.sh	# SSH - SCP (Sandvine)

## Alcatel
elif [ $port = "22" ] && [ $type = "18" ] && [ $vendor = "6" ] && [ $login_type = "1" ]; then
/home/mrse/scripts/local-radius/Alcatel/bkp-ssh-scp-alcatel.sh $user $ip $password $router $service $server 					# SSH - SCP (Alcatel)

## DNS-Secure64
elif [ $port = "22" ] && [ $type = "21" ] && [ $vendor = "9" ] && [ $login_type = "1" ]; then
/home/mrse/scripts/local-radius/Secure64/bkp-ssh-scp2.sh $user $ip $password $router $service  $server 							# SSH - SCP (Secure64)

## Fortinet
elif [ $port = "22" ] && [ $type = "24" ] && [ $vendor = "10" ] && [ $login_type = "1" ]; then
/home/mrse/scripts/local-radius/Fortinet/bkp-ssh-scp-fortinet.sh $user $ip $password $router $service $server 					# SSH - SCP (Fortinet)

## Brocade - SSH
elif [ $port = "22" ] && [ $type = "26" ] && [ $vendor = "11" ] && [ $login_type = "1" ]; then 
/home/mrse/scripts/local-radius/Brocade/bkp-ssh-tftp.sh $user $ip $password $password_en $router $service $server $server		# SSH - SCP (Brocade)

## Ericsson - SSH
elif [ $port = "22" ] && [ $type = "30" ] && [ $vendor = "12" ] && [ $login_type = "1" ]; then
/home/mrse/scripts/local-radius/Ericsson/bkp-ssh-scp-se1200.sh $user $ip $password $router $service $server						# SSH - SCP (Brocade)

################### Scripts en gral 

## Scripts en gral
elif [ $port = "22" ] && [ $type = "22" ] && [ $vendor = "1" ] && [ $login_type = "1" ]; then
/home/mrse/scripts/local-radius/Linux/Gral-scripts/script-cambios.sh $user $ip $password $password_en $router $service $server 			# SSH - SCP (Secure64)

###############################################################################################################################################################
## Tacacs Login
###############################################################################################################################################################

elif [ $port = "0" ] && [ $type == "6" ] && [ $login_type = "2" ]; then 
/home/mrse/scripts/tacacs/bkp-snmp.sh $ip $router $servicio $vendor $server                                                              	# SNMP (Cisco/Huawei/Juniper)

### Cisco - SSH
elif [ $port = "22" ] && [ $type = "1" ] && [ $vendor = "1" ] && [ $login_type = "2" ]; then 
/home/mrse/scripts/tacacs/Cisco/bkp-ssh-scp.sh $user $ip $password $password_en $router $service $server                                 	# SSH - SCP (Cisco)

elif [ $port = "22" ] && [ $type = "2" ] && [ $vendor = "1" ] && [ $login_type = "2" ]; then
/home/mrse/scripts/tacacs/Cisco/bkp-ssh-txt.sh $user $ip $password $password_en $router $service $server                                	# SSH - TXT (Cisco)

elif [ $port = "22" ] && [ $type = "9" ] && [ $vendor = "1" ] && [ $login_type = "2" ]; then
/home/mrse/scripts/tacacs/Cisco/bkp-ssh-txt-IOS-XR.sh $user $ip $password $router $service $server                                 	# SSH - TXT (Cisco IOS XR)

elif [ $port = "22" ] && [ $type = "19" ] && [ $vendor = "1" ] && [ $login_type = "2" ]; then 
/home/mrse/scripts/tacacs/Cisco/bkp-ssh-ftp.sh $user $ip $password $password_en $router $service $server 					# SSH - FTP (Cisco)

elif [ $port = "22" ] && [ $type = "20" ] && [ $vendor = "1" ] && [ $login_type = "2" ]; then 
/home/mrse/scripts/tacacs/Cisco/bkp-ssh-ftp-IOS-XR.sh $user $ip $password $router $service $server                              	# SSH - FTP (Cisco IOS-XR)

elif [ $port = "22" ] && [ $type = "25" ] && [ $vendor = "1" ] && [ $login_type = "2" ]; then 
/home/mrse/scripts/tacacs/Cisco/bkp-ssh-sftp-ACE.sh $user $ip $password $router $service $server 					# SSH - SFTP (Balanceadoras Cisco ACE)

### Cisco - Telnet
elif [ $port = "23" ] && [ $type = "5" ] && [ $vendor = "1" ] && [ $login_type = "2" ]; then
/home/mrse/scripts/tacacs/Cisco/bkp-telnet-txt.sh $user $ip $password $password_en $router $service $server                              	# Telnet - TXT (Cisco)

elif [ $port = "23" ] && [ $type = "3" ] && [ $vendor = "1" ] && [ $login_type = "2" ]; then
/home/mrse/scripts/tacacs/Cisco/bkp-telnet-ftp.sh $user $ip $password $password_en $router $service $server                              	# Telnet - FTP (Cisco)

elif [ $port = "23" ] && [ $type = "8" ] && [ $vendor = "1" ] && [ $login_type = "2" ]; then
/home/mrse/scripts/tacacs/Cisco/bkp-telnet-scp.sh $user $ip $password $password_en $router $service $server                             	# Telnet - SCP (Cisco)

elif [ $port = "23" ] && [ $type = "4" ] && [ $vendor = "1" ] && [ $login_type = "2" ]; then
/home/mrse/scripts/tacacs/Cisco/bkp-telnet-tftp.sh $user $ip $password $password_en $router $service $server                             	# Telnet - TFTP (Cisco)

elif [ $port = "23" ] && [ $type = "12" ] && [ $vendor = "1" ] && [ $login_type = "2" ]; then
/home/mrse/scripts/tacacs/Cisco/bkp-telnet-txt-IOS-XR.sh $user $ip $password $router $service $server                                    	# Telnet - TXT (Cisco IOS XR)

elif [ $port = "23" ] && [ $type = "15" ] && [ $vendor = "1" ] && [ $login_type = "2" ]; then
/home/mrse/scripts/tacacs/Cisco/bkp-telnet-ftp-IOS-XR.sh $user $ip $password $router $service $server                                    	# Telnet - FTP (Cisco IOS XR)

## Gigamon - SSH
elif [ $port = "22" ] && [ $type = "13" ] && [ $vendor = "5" ] && [ $login_type = "2" ]; then
/home/mrse/scripts/tacacs/Gigamon/bkp-ssh-txt-2404.sh $user $ip $password $router $service $server                                       	# SSH - TXT (Gigamon 2404)

elif [ $port = "22" ] && [ $type = "14" ] && [ $vendor = "5" ] && [ $login_type = "2" ]; then
/home/mrse/scripts/tacacs/Gigamon/bkp-ssh-txt-TA.sh $user $ip $password $router $service $server                                        	# SSH - TXT (Gigamon TA)

elif [ $port = "22" ] && [ $type = "23" ] && [ $vendor = "5" ] && [ $login_type = "2" ]; then
/home/mrse/scripts/tacacs/Gigamon/bkp-ssh-scp-HD.sh $user $ip $password $router $service $server                                         	# SSH - HD (Gigamon HD)

## Huawei
elif [ $port = "22" ] && [ $type = "2" ] && [ $vendor = "3" ] && [ $login_type = "2" ]; then
/home/mrse/scripts/tacacs/Huawei/bkp-ssh-txt.sh $user $ip $password $server && /home/mrse/scripts/tacacs/Huawei/fix.sh $router $service 	# SSH - TXT (Huawei)

elif [ $port = "23" ] && [ $type = "5" ] && [ $vendor = "3" ] && [ $login_type = "2" ]; then
/home/mrse/scripts/tacacs/Huawei/bkp-telnet-txt.sh $user $ip $password $server && /home/mrse/scripts/tacacs/Huawei/fix.sh $router $service      # Telnet - TXT (Huawei)

## Juniper
elif [ $port = "22" ] && [ $type = "2" ] && [ $vendor = "2" ] && [ $login_type = "2" ]; then
/home/mrse/scripts/tacacs/Juniper/bkp-ssh-txt.sh $user $ip $password $router $service $server                                            	# SSH - TXT (Juniper)

elif [ $port = "22" ] && [ $type = "17" ] && [ $vendor = "2" ] && [ $login_type = "2" ]; then
/home/mrse/scripts/tacacs/Juniper/bkp-ssh-scp-junos.sh $user $ip $password $router $service $server                                      	# SSH - SCP (Juniper)

elif [ $port = "22" ] && [ $type = "27" ] && [ $vendor = "2" ] && [ $login_type = "2" ]; then
/home/mrse/scripts/tacacs/Juniper/bkp-ssh-scp-junos-fwrbs.sh $user $ip $password $router $service $server                                      	# SSH - SCP (Juniper)

elif [ $port = "23" ] && [ $type = "5" ] && [ $vendor = "2" ] && [ $login_type = "2" ]; then
/home/mrse/scripts/tacacs/Juniper/bkp-telnet-txt.sh $user $ip $password $router $service $server                                  	# Telnet - TXT (Juniper)

elif [ $port = "22" ] && [ $type = "16" ] && [ $vendor = "2" ] && [ $login_type = "2" ]; then
/home/mrse/scripts/tacacs/Juniper/bkp-ssh-scp-netscreen.sh $user $ip $password $router $service $server                        		# SSH - SCP (Netscreen)

## Sandvine
elif [ $port = "22" ] && [ $type = "7" ] && [ $vendor = "4" ] && [ $login_type = "2" ]; then
/home/mrse/scripts/tacacs/Sandvine/bkp-ssh-scp2.sh $user $ip $password $router $service $server && /home/mrse/scripts/tacacs/Sandvine/fix.sh    # SSH - SCP (Sandvine)

## Alcatel
elif [ $port = "22" ] && [ $type = "18" ] && [ $vendor = "6" ] && [ $login_type = "2" ]; then
/home/mrse/scripts/tacacs/Alcatel/bkp-ssh-scp-alcatel.sh $user $ip $password $router $service  $server                                    	# SSH - SCP (Alcatel)

## DNS-Secure64
elif [ $port = "22" ] && [ $type = "21" ] && [ $vendor = "9" ] && [ $login_type = "2" ]; then
/home/mrse/scripts/tacacs/Secure64/bkp-ssh-scp2.sh $user $ip $password $router $service  $server                         		# SSH - SCP (Secure64)

## Fortinet
elif [ $port = "22" ] && [ $type = "24" ] && [ $vendor = "10" ] && [ $login_type = "2" ]; then
/home/mrse/scripts/tacacs/Fortinet/bkp-ssh-scp-fortinet.sh $user $ip $password $router $service  $server                      		# SSH - SCP (Fortinet)

### Brocade - SSH
elif [ $port = "22" ] && [ $type = "26" ] && [ $vendor = "11" ] && [ $login_type = "2" ]; then 
/home/mrse/scripts/tacacs/Brocade/bkp-ssh-tftp.sh $user $ip $password $password_en $router $service $server                         # SSH - SCP (Brocade)

################### Scripts en gral 

## Scripts en gral
elif [ $port = "22" ] && [ $type = "22" ] && [ $vendor = "1" ] && [ $login_type = "2" ]; then
/home/mrse/scripts/tacacs/Linux/Gral-scripts/script-cambios.sh $user $ip $password $password_en $router $service $server                	# SSH - SCP (Secure64)

fi
done

## Fin del script
echo
echo "Fin proceso de backup $service" >> /var/log/bkp/bkp.log
echo "PID:" $$ "DATE: "`date +%d/%m/%Y' '%H:%M:%S` >> /var/log/bkp/bkp.log
echo
