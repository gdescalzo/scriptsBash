#!/usr/bin/expect

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
set comando2 "terminal length 0"
set comando1 "show running-config"

## Comienzo del script
spawn sshpass -p $password  ssh -l $user -oStrictHostKeyChecking=no -b $server $ip
expect_after eof	{exit 0}
set timeout 8


expect {
"yes/no"                {send "yes\r"}
}

expect {
-re "*"           {send "enable\n"}
}

expect {
-re "(P|p)assword:"     {send "$password_en\n"}
}

expect {
-re "$prompt"           {send "$comando1\n"}
}

expect {
-re "*"           {send "$comando2\n"; exp_continue}
}

log_file                /bkp/$service/$nombre

exit 0