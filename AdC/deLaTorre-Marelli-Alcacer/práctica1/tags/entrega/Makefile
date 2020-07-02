all: ejercicio5 main

main: main.c nro.o util.o
	gcc -o main main.c util.o nro.o -Wall -pedantic

ejercicio5: ejercicio5.c
	gcc -o ejercicio5 ejercicio5.c -Wall -pedantic

nro.o: nro.c
	gcc -c nro.c -Wall -pedantic

util.o: util.c
	gcc -c util.c -Wall -pedantic
