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
set comando1 "acl number 2099"
set comando2 "rule 0 permit source 192.168.92.0 0.0.0.255"
set comando3 "rule 1 permit source 172.18.74.0 0.0.0.255"
set comando4 "rule 2 permit source 172.28.0.0 0.0.255.255"
set comando5 "rule 3 permit source 172.29.0.0 0.0.255.255"
set comando6 "rule 4 permit source 192.168.165.0 0.0.0.255"
set comando7 "rule 5 permit source 10.206.19.45 255.255.255.255"
set comando8 "rule 6 permit source 10.206.19.46 255.255.255.255"
set comando9 "rule 7 permit source 10.206.19.47 255.255.255.255"
set comando10 "rule 8 permit source 10.206.19.48 255.255.255.255"


## Comienzo de script
#spawn sshpass -p $password  ssh -l $user $ip
spawn sshpass -p $password  ssh -l $user -oStrictHostKeyChecking=no -oCheckHostIP=no -b $server $ip
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
-re "$prompt"		{send "$comando4\r"}
}

expect {
-re "$prompt"		{send "$comando5\r"}
}

expect {
-re "$prompt"		{send "$comando6\r"}
}

expect {
-re "$prompt"		{send "$comando7\r"}
}

expect {
-re "$prompt"		{send "$comando8\r"}
}

expect {
-re "$prompt"		{send "$comando9\r"}
}

expect {
-re "$prompt"		{send "$comando10\r"}
}

expect {
-re "$prompt"		{send "end\r"}
}

expect {
-re "$prompt"		{send "wr\r"}
}

expect {
-re "$prompt"		{send "quit\r"}
}



exit 0