#!/usr/bin/expect

## Capturamos las variables del master.sh
set user [lindex $argv 0]
set ip [lindex $argv 1]
set password [lindex $argv 2]
set server [lindex $argv 3]

## Variables de entorno
set prompt "(%|% |#|# |>|> |\\\$|\\\$ )$"
set comando "display current-configuration"

## Comienzo de script
spawn sshpass -p $password  ssh -l $user -oStrictHostKeyChecking=no -b $server $ip

expect_after eof	{exit 0}
set timeout 8

#expect {
#"yes/no"			{send "yes\r"}
#}

expect {
-re "$prompt"           {send "$comando1\n"}
}

log_file /tmp/bkp-huawei-tmp.log

expect {
-ex "---- More ----"    {send "\n" ; exp_continue}
}

expect {
-re "$prompt"           {send "exit\r"}
}

log_file

exit 0