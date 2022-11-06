## Ejercicio 20201216
```sh
#! /bin/sh
LAN=10.0.1.0/24
SERVERS=10.0.2.0/24
DMZ=181.16.1.16/28
WWW=181.16.1.18
I=/sbin/iptables
case $1 in
	start)
# Politica por defecto: DROP
$I -P FORWARD DROP

# Estado
$I -A FORWARD -m state --state INVALID -j DROP
$I -A FORWARD -m state --state RELATED, ESTABLISHED -j ACCEPT

# PC de LAN no tienen acceso a los servidores
$I -A FORWARD -i eth0 -s $LAN -o eth1 -d $SERVERS -j DROP
# PC de LAN tiene acceso al resto
$I -A FORWARD -i eth0 -s $LAN -j ACCEPT

# Hacia la DMZ
$I -A FORWARD -o eth2 -d DMZ -p tcp --dport 53 -j ACCEPT
$I -A FORWARD -o eth2 -d DMZ -p udp --dport 53 -j ACCEPT
$I -A FORWARD -m multiport -o eth2 -d WWW -p tcp --dports 80, 443 -j ACCEPT

# Desde la DMZ
$I -A FORWARD -i eth2 -s DMZ -o eth3 -p tcp --dport 53 -j ACCEPT
$I -A FORWARD -i eth2 -s DMZ -o eth3 -p udp --dport 53 -j ACCEPT
$I -A FORWARD -i eth2 -s DMZ -o eth1 -d DB -p tcp 3306 -j ACCEPT
```

## Ejercicio 20181128
```sh
#! /bin/sh
I=/sbin/iptables

# Definiciones extras
PC_ADM=10.0.1.22
LAN=10.0.1.0/24
DMZ=181.16.1.16/28

$I -P FORWARD DROP

# PC_ADM puede acceder por ssh
$I -A FORWARD -i eth0 -s $PC_ADM -p --dport 22 -j ACCEPT
# PC LAN pueden acceder a la DMZ
$I -A FORWARD -i eth0 -s $LAN -o eth1 -d $DMZ -j ACCEPT
```
