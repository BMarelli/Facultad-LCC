## Ejercicio Firewall Aldu
```sh
I=/sbin/iptable
# Definiciones extras
WEB=10.0.2.1
ADMIN=10.2.3.4
SERVERS=10.0.0.1/24
LAN=10.0.4.0/24
VIS=192.162.x.x/24

# Protocolo default
$I -P DROP

# Regla 1
$I -A FORWARD -m multiport -o eth0 -d $WEB -p tcp --dports 80, 443, 53 -j ACCEPT
$I -A FORWARD -m multiport -o eth0 -d $WEB -p udp --dports 80, 443, 53 -j ACCEPT

# Regla 2
$I -A FORWARD -i eth0 -s $WEB -j DROP

# Regla 3
$I -A FORWARD -i eth1 -s $ADMIN -o eth0 -d $SERVERS -p tcp --dport 22 -j ACCEPT
$I -A FORWARD -i eth1 -s $ADMIN -o eth0 -d $SERVERS -p udp --dport 22 -j ACCEPT

# Regla 4
$I -A FORWARD -i eth1 -s $LAN -o eth3 -j ACCEPT
$I -A FORWARD -i eth2 -s $LAN -o eth3 -j ACCEPT

# Regla 5
$I -A FORWARD -i eth2 -s $VIS -o eth3 -p --dport dns -j ACCEPT

# Regla 6
$I -t nat -A POSTROUTING -s $LAN -o eth3 -j SNAT --to 20.x.x.1
$I -t nat -A POSTROUTING -s $VIS -o eth3 -j SNAT --to 20.x.x.2
```

## Version Fari
```sh
#! /bin/bash

# Def de variables
I = /sbin/iptables
DMZ = 10.0.0.0/24
IF_DMZ = eth0
LAN = 10.0.40/24
IF_LAN = eth1
VISIT = 192.162.7.3/24
IF_VISIT = eth2
IP_EXT_LAN = 200.12.51.1
IP_EXT_VISIT = 200.12.51.2
IF_EXT = eth3
SERV = 10.0.2.1
ADMIN = 10.2.3.4

# Limpio reglas anteriores
$I -F -t filter
$I -F -t nat

# Políticas para evitar cualquier otra conexión posible
$I -P INPUT DROP
$I -P OUTPUT DROP
$I -P FORWARD DROP

# Reglas de estado
for i in INPUT OUTPUT FORWARD; do
    $I -A $i -m state -state INVALID -j DROP
    $I -A $i -m state -state RELATED, ESTABLISHED -j ACCEPT
done

# A partir de acá, es todo NEW
for i in tcp udp; do
    $I -A FORWARD -o $IF_DMZ -d SERV -p $i -m multiport -dports 80, 443, 53 -j ACCEPT
    $I -A FORWARD -i $IF_LAN -s $ADMIN -o $IF_DMZ -d $DMZ -p $i -dport 22 -j ACCEPT
    $I -A INPUT -i $IF_LAN -s $ADMIN -p $i -dport 22 -j ACCEPT
done

$I -A FORWARD -i $IF_LAN -s $LAN -o $IF_EXT -j ACCEPT
$I -A FORWARD -i $IF_VISIT -s $VISIT -o $IF_EXT -j ACCEPT

$I -t nat -A POSTROUTING -s $LAN -o $IF_EXT -j SNAT --to $IP_EXT_LAN
$I -t nat -A POSTROUTING -s $VISIT -o $IF_EXT -j SNAT --to $IP_EXT_VISIT
```
