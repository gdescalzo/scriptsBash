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

## Variables de entorno
set prompt "(%|% |#|# |>|> |\\\$|\\\$ )$"
set dates [exec date "+%Y-%m-%d"]
set dates1 [exec date "+%H:%M:%S"]
set nombre "$dates-$router.cfg"
set comando "copy running-config scp://mrse:$pass@$server//bkp/$service/$nombre"

## Comienzo de script
spawn sshpass -p $password  ssh -l $user -oStrictHostKeyChecking=no -oCheckHostIP=no -b $server $ip 
expect_after eof	{exit 0}
set timeout 15

#Desactiva el logueo del standar output ( en "0" desactiva en "1" activa )
log_user 1

expect {
#Errores de conexion
-re "Connection refused"						{ 
									log_file /var/log/bkp/error.log
									send_log "$dates | $dates1 | Servicio $service | Equipo: $router | IP: $ip | $expect_out(buffer)\n";exit 2
									}

-re "Connection closed"							{ 
									log_file /var/log/bkp/error.log
									send_log "$dates | $dates1 | Servicio $service | Equipo: $router | IP: $ip | $expect_out(buffer)\n";exit 3
									}


-re "(C|c)onnection closed by remote host"				{
									log_file /var/log/bkp/error.log
									send_log "$dates | $dates1 | Servicio $service | Equipo: $router | IP: $ip | $expect_out(buffer)\n";exit 4
									}

-re "ssh_rsa_verify: RSA modulus too small: 512 < minimum 768 bits"	{ 
									log_file /var/log/bkp/error.log
									send_log "$dates | $dates1 | Servicio $service | Equipo: $router | IP: $ip | $expect_out(buffer)\n";exit 5
									}

timeout									{
									log_file /var/log/bkp/error.log
									send_log "$dates | $dates1 | Servicio $service | Equipo: $router | IP: $ip | ssh: connect to host $ip Connection timed out\n"; exit 6
									}


#Login
-re "$prompt"		{ send "enable\r"}
}
expect {
-re "(P|p)assword:" 	{ send "$password_en\n"}
}

#Errores de logueo
expect {
"*Access denied" 		{ 
			log_file /var/log/bkp/error.log
			send_log "$dates | $dates1 | Servicio $service | Equipo: $router | IP: $ip | Enable Mode Failed - Check Password\n"; exit 5 
			}
}

#Comando
expect {
-re "$prompt"		{send "$comando\n\r\r\r"}
}

sleep 15

#Logueo de transferencia completada
expect {
"*bytes*"		{
			log_file /var/log/bkp/bkp.log
			send_log "$dates | $dates1 | Servicio $service | Equipo: $router | IP: $ip | Backup Realizado\n"
}
}

log_file

#Salida
expect {
-re "$prompt"		{send "exit\r"}
-re "$prompt"		{send "exit\r"}
}

exit 0