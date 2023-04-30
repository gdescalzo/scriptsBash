#!/usr/bin/expect
## Script para Huawei

## Seteamos el servidor de Backup
set server "172.18.74.70";

## Password encriptado
set pass [exec echo "U2FsdGVkX19tCtbe3JaEb/Fya8xdUtvJ" | openssl enc -base64 -d | openssl enc -des3 -k mysalt -d]

## Capturamos las variables del master.sh
set user [lindex $argv 0]
set ip [lindex $argv 1]
set password [lindex $argv 2]
set password_en [lindex $argv 3]
set router [lindex $argv 4]
set service [lindex $argv 5]

## Variables de entorno
set prompt "(%|% |#|# |>|> |\\\$|\\\$ )$"
set dates [exec date "+%Y-%m-%d"]
set dates1 [exec date "+%H:%M:%S"]
set nombre "$dates-$router.cfg"
set comando "system-view"
set comando1 "user-interface vty 0 4"
set comando2 "acl 2099 inbound"
set comando3 "authentication-mode scheme"

## Comienzo de script
#spawn sshpass -p $password  ssh -l $user $ip
sshpass -p $password  ssh -l $user -oStrictHostKeyChecking=no -oCheckHostIP=no -b $server $ip
expect_after eof	{exit 0}
set timeout 8

#Desactiva el logueo del standar output ( en "0" desactiva en "1" activa )
log_user 1

#Loguea en este archivo
log_file /var/log/bkp/cambios.log

expect {
"yes/no)?"		{send "yes\r"}
}

expect {
-re "$prompt"		{send "enable\r"}
}

expect {
-re "(P|p)assword:" 	{send "$password_en\n"}
}

expect {
-re "$prompt"		{send "$comando\r"}
}

expect {
-re "$prompt"		{send "$comando1\r"}
}

expect {
-re "$prompt"		{send "$comando2\r"}
}

expect {
-re "$prompt"		{send "$comando3\r"}
}

expect {
-re "$prompt"		{send "end\r"}
}

expect {
-re "$prompt"		{send "wr\r"}
}

expect {
-re "$prompt"		{send "exit\r"}
}

exit 0