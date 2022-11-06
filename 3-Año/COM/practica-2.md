# Practica 2
## Ejercicio 1
1. Tenemos 5 clases:
	- A: Tiene un rango de 2^24 -> 1.0.0.0 a 127.0.0.0
	- B: Tiene un rango de 2^16 -> 128.0.0.0 a 191.255.0.0
	- C: Tiene un rango de 2^8 -> 192.0.0.0 a 233.255.255.0
	- D: Es dedicada para el multicast -> 224.0.0.0 a 239.255.255.255
	- E: Reservada -> 240.0.0.0 a 255.255.255.255
2. La mascara de subred por defecto es:
	- A: /8
	- B: /16
	- C: /24
	- D: /4
	- E: /4
3. Tenemos:
	- A:
	- B:
	- C:

## Ejercicio 2
1. 220.200.23.1 => 1101 1100.200.23.1
	- Clase C
	- Parte Host: 1
	- Parte NetId: 220.200.23
	- /24 (255.255.255)
2. 148.17.9.1 => 1001 0100.17.9.1
	- Clase B
	- Parte Host: 9.1
	- Parte NetId: 148.17
	- /16 (255.255)
3. 33.15.4.13 => 0010 0001.15.4.13
	- Clase A
	- Parte Host: 15.4.13
	- Parte NetId: 33
	- /8 (255)


## Ejercicio 3
IP = 174.56.7.0 => 1010 1110.56.7.0 -> Clase B => La mascara es de /16
Para representar 1020 subredes con 10bits
Luego la mascara es de /26
Nos quedan 6 bits para representar los host, lo cual podemos representar
60 host pues: (2^6) - 1 = 63 > 60

## Ejercicio 4
IP = 210.66.56.0 => 1101 0010.66.56.0 -> Clase C => La mascara es de /24
Como queremos representar 6 subredes, necesitamos 3bits
Luego la mascara es de /27
Nos quedan 5 bits para representar los host. (2^5) - 1 = 31 > 30. OK

## Ejercicio 5
IP : 193.52.57.0 => Clase C => /24
- Numero total de subredes = 2^4
- Numero total de host = 2^4
- Numero host utiles = (2^4) - 2 [LoopBack y Multicast]

Queremos representar 8 sucursales => Usamos 4bits => /28
SUC1 : 193.52.57.0000 ++++ => 193.52.57.0 a 193.52.57.15
SUC2 : 193.52.57.0001 ++++ => 193.52.57.16 a 193.52.57.31
...
SUC8 : 193.52.57.1000 ++++ => 193.52.57.128 a 193.52.57.143

## Ejercicio 7
**a)**
Int R-Red1 = 200.13.147.1
Int R-Red2 = 200.13.148.1
Int R-Red3 = 200.13.149.1

A = 200.23.147.2
B = 200.23.147.3
C = 200.23.147.4
MultCast = 200.23.147.255
LoopBack = 200.23.147.0

D = 200.13.148.2
E = 200.13.148.3

F = 200.13.149.2
G = 200.13.149.3

**Tabla Ruteo**
|  Direccion   | Mascara | Transmicion |
|:------------:|:-------:|:-----------:|
| 200.23.147.0 |   /24   |   Directa   |
| 200.23.148.0 |   /24   |   Directa   |
| 200.23.149.0 |   /24   |   Directa   |

**b)**
IP : 200.13.147.0
Como tenemos que representar 3 subredes, tenemos una mascara /26
| Red |   Direccion    | Mascara |
|:---:|:--------------:|:-------:|
|  1  |  200.13.147.0  |   /26   |
|  2  | 200.13.147.64  |   /26   |
|  3  | 200.13.147.128 |   /26   |

**Red 1**
| PCs |   Direccion   |
|:---:|:-------------:|
|  A  |  200.13.147.1 |
|  B  |  200.13.147.2 |
|  C  |  200.13.147.3 |
| MuC | 200.13.147.63 |
| LpB |  200.13.147.0 |

**Red 2**
| PCs |    Direccion   |
|:---:|:--------------:|
|  D  | 200.13.147.65  |
|  E  | 200.13.147.66  |
| MuC | 200.13.147.127 |
| LpB | 200.13.147.64  |

**Red 3**
| PCs |    Direccion   |
|:---:|:--------------:|
|  F  | 200.13.147.129 |
|  G  | 200.13.147.130 |
| MuC | 200.13.147.191 |
| LpB | 200.13.147.128 |

**Router R**
IP = 200.13.147.192

|    Direccion   | Mascara | Transmicion |
|:--------------:|:-------:|:-----------:|
|  200.13.147.0  |   /26   |   Directa   |
| 200.13.147.64  |   /26   |   Directa   |
| 200.13.147.128 |   /26   |   Directa   |
| 200.13.147.192 |   /26   |   Directa   |

## Ejercicio 8
IP = 199.199.20.6 /24 => 199.199.20.0
Red 1 y Red 5 -> 50 host
Red 2, Red 3, Red 4 -> 28 host

Primer sub-neteo: Queremos 4 redes => /26

199.199.20.00++ ++++ -> Red 1

199.199.20.01++ ++++ -> Red 5

199.199.20.10++ ++++ -> sub-sub-neteo Red 2, Red 3

199.199.20.11++ ++++ -> sub-sub-neteo Red 4(, Internet?)


Segundo sub-neteo: Queremos 2 => Robamos 1bits => /27

199.199.20.10|0+ ++++ -> Red 2

199.199.20.10|1+ ++++ -> Red 3 

199.199.20.11|0+ ++++ -> Red 4

199.199.20.224 -> Internet

**TABLA ROUTERS**
|    Direccion   | Mascara | Transmicion |
|:--------------:|:-------:|:-----------:|
| 199.199.20.0   |   /26   |   Directa   |
| 199.199.20.01  |   /26   |   Directa   |
| 199.199.20.10  |   /27   |   Directa   |
| 199.199.20.101 |   /27   |   Directa   |
| 199.199.20.110 |   /27   |   Directa   |
| 199.199.20.224 |   ---   |   Directa   |

## Ejercicio 9
(11 host en la red 2)

IP = 200.113.2.192/26 => 200.113.2.11++ ++++

Primer sub-neteo => /27

200.113.2.110+ ++++ -> Red 3 => BC: 200.113.2.1101 1111 ~ LpB: 200.113.2.1100 0000

200.113.2.111+ ++++ -> sub-sub-neteo Red 1, 2, 4

Segundo sub-neteo => /28

200.113.2.111|0 ++++ -> Red 1 => BC: 200.113.2.111|0 1111 ~ LpB: 200.113.2.111|0 000

200.113.2.111|1 ++++ -> sub-sub-sub-neteo Red

**TODO:** _Hacerlo bien, ni idea de como se hace!!!_

---

# Practica para FINAL
## Ejercicio 1
- Clase A:
1. 0.0.0.0 - 127.0.0.0
2. 255.0.0.0/8
3. 10.0.0.0 - 10.255.255.255

- Clase B:
1. 128.0.0.0 - 191.255.000.000
2. 255.255.0.0/16
3. 172.16.0.0 - 172.31.255.255

- Clase C:
1. 192.0.0.0 - 223.255.255.0
2. 255.255.255.0/25
3. 192.168.0.0 - 196.168.255.255

- Clase D:
1. 224.0.0.0 - 239.255.255.255
2. /4

- Clase E:
1. 240.0.0.0 - 255.255.255.255
2. /4

## Ejercicio 2
1. IP: 220.200.23.1
- Clase: C
- red: 220.200.23
- host: 1
- mascara: 255.255.255.0

2. IP: 148.17.9.1
- Clase: B
- red: 148.17
- host: 9.1
- mascara: 255.255.0.0

3. IP: 33.15.4.13
- Clase: A
- red: 33
- host: 15.4.13
- mascara: 255.0.0.0

4. IP: 249.240.80.78
- Clase: E

5. IP: 230.230.45.68
- Clase: D

6. 192.68.12.8
- Clase: C
- red: 192.68.12
- host: 8
- mascara: 255.255.255.0

## Ejercicio 3
Tenemos la IP=174.56.7.0 => Sabemos que es de categoria B => mascara de /16.

Si nosotros queremos representar 1020, busquemos n talque 2^n >= 1020.

Si tomamos n=10 => 2^10 = 1024 > 1020. Luego utilizamos 10 bits para representar
las subredes.

Por lo tanto nos queda una mascara de 10+16 = /26
Luego 32-26 = 6 -> 2^6 = 64 > 60 => Nos quedan 6 bits para los host y podemos representar los 60 host que queremos.

## Ejercicio 4
Tenemos la IP=210.66.56.0 => Categoria C => mascara de /24.

Si queremos representar 6 subredes, necesitamos 3 bits => 2^3 = 8 > 6.

La mascara nos queda 24+3 = /27.

Nos quedan 32-27 = 5 bits para representar host. Para poder representar 30 hosts,
necesitamos 5 bits, ya que 2^5 = 32 > 30.

## Ejercicio 5
1. Tenemos la IP=193.52.57.0 => Categoria C => mascara de /24.

Supongamos que queremos representar 8 subredes (una por cada sucursal), necesitamos 3 bits, ya que 2^3 = 8.

Luego la mascara nos queda 24+3 = /27

Con esto, nos quedan 32-27 = 5 bits para represntar los hosts.
=> 2^5 = 32 => 30 host podemos representar (dejamos para el loopback y brodcast) 

2. Los rangos son:
- IP-SUC1=193.52.57.0 (000+ ++++) => Rango: 193.52.57.1 - 193.52.57.30
-> 193.52.57.0 loopback, 193.52.57.31 brodcast
- IP-SUC2=193.52.57.32 (001+ ++++) => Rango: 193.52.57.32 - 193.52.57.62
-> 193.52.57.32 loopback, 193.52.57.63 brodcast

- IP-SUC8=193.52.57.224 (111+ ++++) => Rango: 193.52.57.225 - 193.52.57.254
-> 193.52.57.224 loopback, 193.52.57.255 brodcast
3. IP brodcast 193.52.57.127

## Ejercicio 7
1. Tenemos:
- RED1=200.13.147.0
- RED2=200.13.148.0
- RED3=200.13.149.0

Luego nos queda:
- RED1:
	- loopback=200.13.147.0
	- brodcast=200.13.147.255
	- A=200.13.147.1
	- B=200.13.147.2
	- C=200.13.147.3
- RED2:
	- loopback=200.13.148.0
	- brodcast=200.13.148.255
	- D=200.13.148.1
	- E=200.13.148.2
- RED3:
	- loopback=200.13.149.0
	- brodcast=200.13.149.255
	- F=200.13.149.1
	- G=200.13.149.2

Tabla de ruteo de **R**:
|       IP     | Mascara | Transmicion |
|:------------:|:-------:|:-----------:|
| 200.13.147.0 |   /26   |      ED     |
| 200.13.148.0 |   /26   |      ED     |
| 200.13.149.0 |   /26   |      ED     |


2. Tenemos la IP=200.13.147.0 => Clase C => mascara /24

Queremos crear 3 subredes => necesitamos 2 bits => mascara de /26.

Podemos tener 32-26=6 bits para los host

Nos queda:
- RED1=200.13.147.0
	- loopback=200.13.147.0
	- brodcast=200.13.147.63
	- A=200.13.147.1
	- B=200.13.147.2
	- C=200.13.147.3
- RED2=200.13.147.64
	- loopback=200.13.147.64
	- brodcast=200.13.147.127
	- D=200.13.147.65
	- E=200.13.147.66
- RED=200.13.147.128
	- loopback=200.13.147.128
	- brodcast=200.13.147.191
	- F=200.13.147.129
	- G=200.13.147.130
- Internet=200.13.147.192

Tabla de ruteo de **R**:
|        IP      | Mascara | Transmicion |
|:--------------:|:-------:|:-----------:|
| 200.13.147.0   |   /26   |      ED     |
| 200.13.147.64  |   /26   |      ED     |
| 200.13.147.128 |   /26   |      ED     |
| 200.13.147.192 |   /26   |      ED     |

## Ejercicio 8
Tenemos la IP=199.199.20.0

1. Como la la IP es de categoria C => mascara /24.

* RED1 y RED5 -> 50 hosts => necesitamos 6 bits
* RED2, RED3, RED4 -> 28 hosts

Vamos a utilizar 2 bits para realizar sub-neteos:

- RED1=199.199.20.0/26 (00)
- RED5=199.199.20.64/26 (01)
- RED2=199.199.20.128/27 (10|0+)
- RED3=199.199.20.160/27 (10|1+)
- RED4=199.199.20.192/27 (11|0+)
- INTERNET=199.199.20.224/27 (11|1+)
