CFLAGS = -g -Wall -pedantic -pthread

all:
	gcc -o Server Server.c $(CFLAGS)
	gcc -o Client Client.c $(CFLAGS)

clean:
	rm -rf *.o && rm -rf Client Server

valgrind-Server:
	valgrind --tool=memcheck --leak-check=full --track-origins=yes ./Server 5000

valgrind-Client:
	valgrind --tool=memcheck --leak-check=full --track-origins=yes ./Client 127.0.0.1 5000
