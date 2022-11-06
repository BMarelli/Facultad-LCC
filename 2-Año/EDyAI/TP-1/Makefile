all: parte1 parte2

util.o: util.c
	gcc -c util.c -Wall -pedantic

glist.o: glist.c
	gcc -c glist.c -Wall -pedantic

parte1: parte1.c glist.o util.o
	gcc -o parte1 parte1.c glist.o util.o -Wall -pedantic

parte2: parte2.c glist.o util.o
	gcc -o parte2 parte2.c glist.o util.o -Wall -pedantic
