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
set nombre "$dates-$router.cfg"
set comando1 "show configuration | display set | no-more"


spawn telnet $ip
expect_after eof	{exit 0}
set timeout 10

expect {
-re "(L|l)ogin:" 	{send "$user\n" ; exp_continue}
-re "(P|p)assword:" 	{send "$password\n"}
}

expect {
-re "$prompt"		{send "$comando1\n"}
}

log_file                /bkp/$service/$nombre

expect {
-re "$prompt"		{send "exit\r"}
}

exit 0
