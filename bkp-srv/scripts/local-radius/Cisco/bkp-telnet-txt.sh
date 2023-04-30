#!/usr/bin/expect

## Password encriptado
set pass [exec echo "U2FsdGVkX1/C16+FMF5IKx4uOH0nbn8QVCAvHN2SSSc=" | openssl enc -base64 -d | openssl enc -des3 -k mysalt -d]


## Capturamos las variables del master.sh
set user [lindex $argv 0]
set ip [lindex $argv 1]
set password [lindex $argv 2]
set password_en [lindex $argv 3]
set router [lindex $argv 4]
set service [lindex $argv 5]
set server [lindex $argv 6]

## Variables de entorno
set prompt "(%|% |#|# |>|> |\\\$|\\\$ )$"
set dates [exec date "+%Y-%m-%d"]
set nombre "$dates-$router.cfg"
set comando1 "terminal length 0"
set comando2 "show running-config"

spawn telnet $ip
expect_after eof	{exit 0}
set timeout 10

expect {
-re "(U|u)sername:" 	{send "$user\n" ; exp_continue}
-re "(P|p)assword:" 	{send "$password\n"}
}

expect {
-re "$prompt"		{send enable\r ; exp_continue}
-re "(P|p)assword:" 	{send "$password_en\n"}
}

expect {
-re "$prompt"		{send "$comando1\n"}
}

expect {
-re "$prompt"           {send "$comando2\n"}
}

log_file                /bkp/$service/$nombre

expect {
-re "$prompt"		{send "exit\r" ; exp_continue}
}

exit 0
