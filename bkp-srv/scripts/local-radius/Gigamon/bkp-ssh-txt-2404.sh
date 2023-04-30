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
set comando1 "upload -cmd -running -console"

#spawn sshpass -p $password  ssh -l $user $ip
spawn sshpass -p $password ssh -l $user -oStrictHostKeyChecking=no -b $server $ip
expect_after eof	{exit 0}
set timeout 8

expect {
"yes/no"		{send "yes\r"}
}

expect {
-re "$prompt"		{send "$comando1\r"}
}

log_file		/bkp/$service/$nombre

expect {
-re "$prompt"		{send "exit\r"}
}

exit 0