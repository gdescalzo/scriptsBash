#!/usr/bin/expect

## Capturamos las variables del master.sh
set user [lindex $argv 0]
set ip [lindex $argv 1]
set password [lindex $argv 2]
set password_en [lindex $argv 3]
set router [lindex $argv 4]
set service [lindex $argv 5]
set server [lindex $argv 6]


set prompt "(%|% |#|# |>|> |\\\$|\\\$ )$"
set dates1 [exec date "+%H:%M:%S"]
set dates [exec date "+%Y-%m-%d"]
set nombre "$dates-$router.cfg"
set comando "copy running-config tftp://$server//$nombre"

spawn telnet $ip
expect_after eof	{exit 0}
set timeout 10

#Desactiva el logueo del standar output ( en "0" desactiva en "1" activa )
log_user 0

#Loguea en este archivo
log_file /var/log/bkp/bkp.log

expect {
-re "(U|u)sername:" 	{send "$user\n" ; exp_continue}
-re "(P|p)assword:" 	{send "$password\n"}
}

expect {
-re "$prompt"		{send "$comando\n\r\r\r"}
}

sleep 10

expect {
"bytes"         {send_log "$dates | $dates1 | Servicio $service | Equipo: $router | IP: $ip | Backup Realizado\n"}
}

expect {
-re "$prompt"		{send "quit\r"}
}

## Movemos al directorio correspondiente del servicio el archivo backupeado.
exec /bin/bash -c "mv /bkp/tftp/$nombre /bkp/$service"

exit 0
