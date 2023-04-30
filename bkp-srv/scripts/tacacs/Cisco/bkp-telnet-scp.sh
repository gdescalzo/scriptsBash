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
set server [lindex $argv 6]

set prompt "(%|% |#|# |>|> |\\\$|\\\$ )$"
set dates [exec date "+%Y-%m-%d"]
set dates1 [exec date "+%H:%M:%S"]
set nombre "$dates-$router.cfg"
set comando "copy running-config scp://mrse:$pass@$server//bkp/$service/$nombre"
set timeout 8

## Comienzo de script
spawn telnet $ip
expect_after eof	{exit 0}

#Desactiva el logueo del standar output ( en "0" desactiva en "1" activa )
log_user 1

#Loguea en este archivo
log_file /var/log/bkp/bkp.log

expect {
-re "(U|u)sername:"		{send "$user\n" ; exp_continue}
-re "(P|p)assword:"		{send "$password\n"}
}

set timeout 5

expect {
-re "$prompt"		{send "$comando\n\r\r\r"}
}

sleep 20

send_log "$dates | $dates1 | Servicio $service | Equipo: $router | IP: $ip | Backup Realizado\n"

expect {
-re "$prompt"		{send "exit\r"}
}

exit 0
