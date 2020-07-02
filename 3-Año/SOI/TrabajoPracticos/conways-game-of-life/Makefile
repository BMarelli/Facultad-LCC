CFLAGS = -O3 -g -Wall -Wextra -pedantic -Wno-unused-result -lpthread

main: main.c board.o game.o barrier.o
	gcc main.c board.o game.o barrier.o -o simulador $(CFLAGS)

board.o: board.c
	gcc board.c -c $(CFLAGS)

game.o: game.c
	gcc game.c -c $(CFLAGS)

barrier.o: barrier.c
	gcc barrier.c -c $(CFLAGS)

.PHONY: clean
clean:
	rm -rf *.o && rm -rf simulador

.PHONY: valgrind
valgrind:
	valgrind --tool=memcheck --leak-check=full --track-origins=yes ./a.out game1.txt
