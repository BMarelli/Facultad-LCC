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
