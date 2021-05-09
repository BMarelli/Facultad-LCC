main: main.c util.o slist.o spila.o trie.o
			gcc -g -o main main.c util.o slist.o spila.o trie.o -Wall -pedantic

util.o: util.c
				gcc -g -c util.c -Wall -pedantic

slist.o: slist/slist.c
				 gcc -g -c slist/slist.c -Wall -pedantic

spila.o: spila/spila.c
				 gcc -g -c spila/spila.c -Wall -pedantic

trie.o: trie/trie.c
				gcc -g -c trie/trie.c -Wall -pedantic
