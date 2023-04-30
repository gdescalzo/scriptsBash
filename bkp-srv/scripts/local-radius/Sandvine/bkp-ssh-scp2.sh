#!/usr/bin/expect

## Capturamos las variables del master.sh
set user [lindex $argv 0]
set ip [lindex $argv 1]
set password [lindex $argv 2]
set router [lindex $argv 3]
set service [lindex $argv 4]
set server [lindex $argv 5]

## Variables de entorno
set prompt "(%|% |#|# |>|> |\\\$|\\\$ )$"
set dates [exec date "+%Y-%m-%d"]
set dates1 [exec date "+%H:%M:%S"]

## Comienzo de script
spawn scp $user@$ip:/usr/local/sandvine/etc/\{subnets.txt,rc.conf,policy.conf} /tmp/sandvine

#Desactiva el logueo del standar output ( en "0" desactiva en "1" activa )
log_user 0

#Loguea en este archivo
log_file /var/log/bkp/bkp.log

expect {
"yes/no"                {send "yes\r"}
}

expect {
-re "(P|p)assword:"     {send "$password\n" ; exp_continue}
}

#Logueo en el archivo
#expect {
#"*OK"			{send_log "$dates | $dates1 | Servicio $service | Equipo: $router | IP: $ip | Backup Realizado\n"}
#}

#Comprimimos 
set comprime [exec rar a /bkp/$service/$dates-$router.rar /tmp/sandvine/]
puts $comprime

send_log "$dates | $dates1 | Servicio $service | Equipo: $router | IP: $ip | Backup Realizado\n"


#Borramos
#set borra [exec rm /tmp/sandvine/*]
#puts $borra
exit 0
