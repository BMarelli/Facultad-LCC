## Ejercicio DNS
- Domain name: magenta.com
- ns1.magenta.com (master) => IP:192.168.0.1
- ns2.magenta.com (slave) => IP:192.168.0.66
- ns3.impresiones.com (slave)
- www y FTP => IP:192.168.0.2
- host1: color => IP:192.168.0.3
- host2: monocromo => IP:192.168.0.4
- mail.impresiones.com
- Resolucion inversa en ns1.magenta.com

Archivo **named.conf.ns1**
```txt
zone "magenta.com" {
	type master;
	file "magenta.db";
	allow-query {any;};
	allow-transition {any;};
}

zone 0.168.192.in-addr.arpa {
	type master;
	file "rev.magenta.db";
}

```

Archivo **magenta.db**
```txt
TTL 1D
$ORIGIN magenta.com
@		IN	SOA	ns1.magenta.com		user@mail.com ()
		IN	NS	ns1
		IN	NS	ns2
		IN	MX 10	impresiones.com.

ns1		IN	A	192.168.0.1
ns2		IN	A	192.168.0.66
www		IN	A	192.168.0.2
FTP		IN	CNAME	www
color		IN	A	192.168.0.3
monocromo 	IN	A	192.168.0.4
```
Archivo **rev.magenta.db**
```txt
TTL 1D
$ORIGIN	0.168.192.in-addr.arpa
@		IN	SOA	ns1.magenta.com		user@mail.com ()
		IN	NS	ns1
		IN	NS	ns2
		IN	MX 10	impresiones.com

1		IN	PTR	ns1.magenta.com.
66		IN	PTR	ns1.magenta.com.
2		IN	PTR	www.magenta.com.
		IN	PTR	FTP.magenta.com.
3		IN	PTR	color.magenta.com.
4		IN	PTR	monocromo.magenta.com.
```
---
## Ejercicio Firewal
```sh
I=/sbin/iptable
LAN=172.30.80.0/17
DBS=172.30.80.6
DMZ=220.12.12.0/29
WWW=220.12.12.66
INTERNET=181.12.2.82
SOPORTE=200.11.20.0/29

$I -F -t filter
$I -F -t nat

# Politicas por defecto
for i in INPUT OUTPUT FORWARD; do
	$I -P $i DROP
done

# Reglas de estado
for i in INPUT OUTPUT FORWARD; do
    $I -A $i -m state -state INVALID -j DROP
    $I -A $i -m state -state RELATED, ESTABLISHED -j ACCEPT
done

# Permitimos el acceso desde LAN a la DMZ
$I -A FORWARD -m multiports -i if1 -s $LAN -o if0 -d $DMZ -p tcp --dports 80,443 -j ACCEPT
# LAN acceso a Internet
$I -A FORWARD -i if1 -s $LAN -d $INTERNET -j ACCEPT

# DMZ recibe acceso a los puertos web desde cualquier lado
$I -A FORWARD -m multiports -d $DMZ -p tcp --dports 80,443 -j ACCEPT

# DMZ recibe por ssh desde servicio soporte 
# Esto es trabajo del R2

# DMZ puede consultar dns al exterior
# Esto es trabajo del R2

# DMZ puede consultar al puerto 3306 de db
for protocolo in tcp udp; do
	$I -A FORWARD -i if0 -s $DMZ -o if1 -d $DBS -p $protocolo --dport 3306 -j ACCEPT
done

# Tabla NAT
# Nateo desde LAN a INTERNET
$I -t nat -A POSTROUTING -s $LAN -o if0 -j SNAT --to $INTERNET
```
