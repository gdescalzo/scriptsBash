#!/usr/bin/expect

## Password encriptado
set pass [exec echo "U2FsdGVkX1/C16+FMF5IKx4uOH0nbn8QVCAvHN2SSSc=" | openssl enc -base64 -d | openssl enc -des3 -k mysalt -d]

## Capturamos las variables del master.sh
set user [lindex $argv 0]
set ip [lindex $argv 1]
set password [lindex $argv 2]
set router [lindex $argv 3]
set service [lindex $argv 4]
set server [lindex $argv 5]

set prompt "(%|% |#|# |>|> |\\\$|\\\$ )$"
set dates [exec date "+%Y-%m-%d"]
set dates1 [exec date "+%H:%M:%S"]
set nombre "$dates-$router.cfg"
set comando "copy running-config ftp://ftpuser:$pass@$server//$nombre"

## Comienzo de script
spawn telnet $ip
expect_after eof	{exit 0}
set timeout 10

#Desactiva el logueo del standar output ( en "0" desactiva en "1" activa )
log_user 0

#Loguea en este archivo
log_file /var/log/bkp/bkp.log

expect {
-re "(U|u)sername:" 	{send "$user\n"; exp_continue}
-re "(P|p)assword:" 	{send "$password\n"}
}

expect {
-re "$prompt"		{send "$comando\n\r\r\r"}
}

expect {
"OK"			{send_log "$dates | $dates1 | Servicio $service | Equipo: $router | IP: $ip | Backup Realizado\n"}

}

expect {
#-re "$prompt"		{send "exit\r"}
-re "$router"		{send "exit\r"; exp_continue}
}

## Movemos al directorio correspondiente del servicio el archivo backupeado.
exec /bin/bash -c "mv /bkp/ftp/$nombre /bkp/$service"

exit 0
