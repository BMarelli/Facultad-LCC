## Ejercicio 1

- Tenemos como domain name: fceia.unr.ar.
- IP=192.168.0.100
- Necesitamos 12 host (pcs): 192.168.0.101 a 192.168.0.112
- Servidor web: pc11 (192.168.0.111)
- Servidor mail, servidor dns: pc12 (192.168.0.112)

**Archivo named.conf**
```
zone "fceia.unr.ar" {
	type master;
	file "etc/bind/db.fceia";
	allow-query{any;}
	allow-transfer{slaves;}
}

zone "0.168.192.in-addr.arpa {
	type master;
	file "etc/bin/rev.192";
}
```

**Archivo db.fceia**
```
$TTL 2d ; 172800 seconds
$ORIGIN fceia.unr.ar.
@		IN	SOA	dns.fceia.unr.ar.	hostmaster.isp.com. (
								2003080800 ; serial number
                              					3h         ; refresh
				                                15m        ; update retry
                              					3w         ; expiry
				                                3h         ; nx = nxdomain ttl
                              				)

		IN	NS	dns.fceia.unr.ar.
		IN	MX	mail.fceia.unr.ar.

PC1		IN	A	192.168.0.101
PC2             IN      A       192.168.0.102
...
PC12            IN      A       192.168.0.112
www		IN	CNAME	PC11
mail		IN	CNAME	PC12
dns		IN	CNAME	PC12
```
**Archivo rev.192**
```
$TTL 2d ; 172800 seconds
$ORIGIN 192.168.0.in-addr.arpa.
@		IN      SOA     dns.fceia.unr.ar.       hostmaster.isp.com. (
                                                                2003080800 ; serial number
                                                                3h         ; refresh
                                                                15m        ; update retry
                                                                3w         ; expiry
                                                                3h         ; nx = nxdomain ttl
                                                        )
		IN	NS	dns.fceia.unr.ar.
		IN	MX	mail.fceia.unr.ar.

101		IN	PTR	pc1.fceia.unr.ar.
102		IN	PTR	pc2.fceia.unr.ar.
...
112		IN	PTR	pc12.fceia.unr.ar.
111		IN	PTR	www.fceia.unr.ar.
112		IN	PTR	mail.fceia.unr.ar.
112		IN	PTR	dns.fceia.unr.ar.
```

---

## Ejercicio 2

- Domain Name 1: netflix.ar
- Domain Name 2: lucifer.netflix.ar
- ns1.netflix.ar => 200.13.147.60 (Directa e inversa)
- ns2.lucifer.netflix.ar => 200.13.147.90

**Archivo name.conf.ns1**
```
zone "netflix.ar" {
	type master;
	file "etc/bin/netflix.db";
	allow-query {any;};
	allow-transfer {slave;};
}

zone 147.13.200.in-addr-arpa {
	type master;
	file "etc/bin/rev.db";
}

zone "lucifer.netflix.ar" {
	type slave;
	file "etc/bin/netflix.db";
}
```
**Archivo name.conf.ns2 ?**

**Archivo netflix.db**
```
$TTL 2d ; 172800 seconds
$ORIGIN netflix.ar
@			IN	SOA	ns1.netflix.ar	hostmaster.isp.com. (
                        				2003080800 ; serial number
                        				3h         ; refresh
                              	15m        ; update retry
                              	3w         ; expiry
                              	3h         ; nx = nxdomain ttl
                          		)
			IN	NS		ns1.netflix.ar
			IN	NS		ns2.lucifer.netflix.ar
			IN 	MX 10	mx.netflix.ar
			IN	MX 20	mx.lucifer.netflix.ar

www		IN	A	200.13.147.60
ns1		IN	CNAME	www
ns2.lucifer	IN	A	200.13.147.90
mx		IN	A	200.13.147.59
mx.lucifer	IN	A	200.13.147.113
```

**Archivo rev.db**
```
$TTL 2d
$ORIGIN	147.13.200.in-addr-arpa
@			IN	SOA	ns1.netflix.ar	hostmaster.isp.com. (
                                                        2003080800 ; serial number
                                                        3h         ; refresh
                                                        15m        ; update retry
                                                        3w         ; expiry
                                                        3h         ; nx = nxdomain ttl
                                                	)
			IN	NS	ns1.netflix.ar
			IN 	NS	ns2.lucifer.netflix.ar
			IN	MX 10	mx.netflix.ar
			IN	MX 20	mx.lucifer.netflix.ar

60		IN	PTR	ns1.netflix.ar
60		IN	PTR	www.netflix.ar
59		IN	PTR	mx.netflix.ar
90		IN	PTR	ns2.lucifer.netflix.ar
113		IN	PTR	mx.lucifer.netflix.ar
```

---

## Ejercicio 3 

- Rosario: 2001:67c:2294:1000::/64
- Capital Federal: 2a03:2880:f113:8083::/64
- Domain Nama: basel.net
- Domain Name Rosario: ros.basel.net
- Domain Name Capital Federal: ba.basel.net

-  ns1.basel.net: 2001:67c:2294:1000:0:0:0:f199 (master directa, esclavo inversa)
-  ns2.ba.basel.net: 2a03:2880:f113:8083:face:b00c:0:25de (esclavo directa, master inversa)

**Archivo name.conf.ns1**
```
zone "basel.net" {
	type master;
	file "etc/bin/basel.db";
	allow-query {any;};
	allow-transfer {slave;};
}

zone 0.0.0.1.4.9.2.2.c.7.6.1.0.0.2.IP6.ARPA {
	type slave;
	master {2a03:2880:f113:8083:face:b00c:0:25de;};
	file "etc/bin/basel.rev.db";
}
```
**Archivo name.conf.ns2**
```
zone 3.8.0.8.3.1.1.f.0.8.8.2.3.0.a.2.IP6.ARPA. {
	type master;
	file "etc/bin/ba.basel.db";
	allow-query {any;};
	allow-transfer {slave;};
}

zone "ba.basel.net" {
	type slave;
	master {2001:67c:2294:1000:0:0:0:f199;};
	file "etc/bin/ba.base.db";
}
```
**Archivo basel.db**
```
$TTL 2d
$ORIGIN basel.net
@				IN	SOA	ns1.basel.net	hostmaster.example.com. (
                        				2010121500 ; sn = serial number
                        				12h        ; refresh = refresh
                        				15m        ; retry = refresh retry
                        				3w         ; expiry = expiry
                        				2h         ; nx = nxdomain ttl
                        			)
				IN	NS	ns1.basel.net
				IN	NS	ns2.ba.basel.net
				IN	MX 10	mx.ros.basel.net

ns1			IN	AAAA	2001:067c:2294:1000:0000:0000:0000:f199
ns2.ba	IN	AAAA	2a03:2880:f113:8083:face:b00c:0000:25de
mx.ros	IN	AAAA	2001:067c:2294:1000:0000:0000:00fe:f199
```
**Archivo basel.rev.db**
```
$TTL 2d
$ORIGIN 0.0.0.1.4.9.2.2.c.7.6.1.0.0.2.IP6.ARPA
@               IN      SOA     ns1.basel.net   hostmaster.example.com. (
                                                  2010121500 ; sn = serial number
                                                  12h        ; refresh = refresh
                                                  15m        ; retry = refresh retry
                                                  3w         ; expiry = expiry
                                                  2h         ; nx = nxdomain ttl
                                                )

								IN			NS			ns1.basel.net
                IN      NS      ns2.ba.basel.net
                IN      MX 10   mx.ros.basel.net

9.9.1.f.0.0.0.0.0.0.0.0.0.0.0.0				IN	PTR	ns1.basel.net
9.9.1.f.f.e.0.0.0.0.0.0.0.0.0.0				IN	PTR	mx.ros.basel.net
2a03:2880:f113:8083:face:b00c:0:25de.	IN 	PTR	ns2.basel.net (1?)
```

Consultas:
- **(1?)**: La direccion se pone como esta o reverse?
-  

---

## Ejercicio 4

<!-- TODO: Diapo 16 porque esto: 129 IN CNAME 129.0/25
														160 IN CNAME 160.0/25.235.168.192.in-addr-arpa
														161 IN CNAME 161.0/25.235.168.192.in-addr-arpa -->
