#!/usr/bin/expect

## Password encriptado
set pass [exec echo "U2FsdGVkX19tCtbe3JaEb/Fya8xdUtvJ" | openssl enc -base64 -d | openssl enc -des3 -k mysalt -d]

## Capturamos las variables del master.sh
set user [lindex $argv 0]
set ip [lindex $argv 1]
set password [lindex $argv 2]
set password_en [lindex $argv 3]
set router [lindex $argv 4]
set service [lindex $argv 5]
set server [lindex $argv ]

## Variables de entorno
set prompt "(%|% |#|# |>|> |\\\$|\\\$ )$"
set dates [exec date "+%Y-%m-%d"]
set dates1 [exec date "+%H:%M:%S"]
set nombre "$dates-$router.cfg"
set comando "configuration upload active scp://mrse:$pass@172.18.74.70/bkp/$service/$nombre"

## Comienzo de script
spawn sshpass -p $password  ssh -l $user -oStrictHostKeyChecking=no -b $server $ip

expect_after eof	{exit 0}
set timeout 8

#Desactiva el logueo del standar output ( en "0" desactiva en "1" activa )
#log_user 1

#Loguea en este archivo
log_file /var/log/bkp/bkp.log

expect {
-re "Are"		{send "yes\r"}
}

expect {
-re "$prompt"		{send "enable\r"}
}

expect {
-re "$prompt"		{send "conf t\r"}
}

expect {
-re "$prompt"		{send "$comando\n"}
}

sleep 15

send_log "$dates | $dates1 | Servicio $service | Equipo: $router | IP: $ip | Backup Realizado\n"

expect {
-re "$prompt"		{send "exit\r"}
}

exit 0
