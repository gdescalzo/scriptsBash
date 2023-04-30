#!/usr/bin/expect

## Capturamos las variables del master.sh
set user [lindex $argv 0]
set ip [lindex $argv 1]
set password [lindex $argv 2]
set server [lindex $argv 3]

## Variables de entorno
set prompt "(%|% |#|# |>|> |\\\$|\\\$ )$"

## Comienzo de script

spawn scp $user@$ip:/usr/local/sandvine/etc/\{subnets.txt,rc.conf,policy.conf} /tmp/sandvine

expect {
"yes/no"                {send "yes\r"}
}

expect {
-re "(P|p)assword:"     {send "$password\n" ; exp_continue}
}

exit 0
