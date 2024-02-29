CC=gcc
CFLAGS=-Wall
LDFLAGS=-Wall -lfl


bin/tpcas:obj/tree.o obj/bison.o obj/flex.o obj/option.o
	$(CC) $^ $(LDFLAGS) -o $@

obj/tree.o: src/tree.c src/tree.h
	$(CC) -o $@ -c $< $(CFLAGS)

obj/option.o: src/option.c src/option.h
	$(CC) -o $@ -c $< $(CFLAGS)

obj/bison.c: src/TPC.y
	bison -d -t -o $@ $< -Wcounterexamples

obj/bison.o: obj/bison.c
	$(CC) -o $@ -c $< $(CFLAGS)

obj/flex.c: src/TPC.lex
	flex -o $@ $<

obj/flex.o: obj/flex.c obj/bison.c
	$(CC) -o $@ -c $< $(CFLAGS)

clean: 
	rm -f bin/*
	rm -f obj/*
	rm -f result.txt

