FLEX = flex -I
BISON = bison -d

CC = gcc

.PHONY: all
all: td4asm

td4asm: asm.tab.o lex.yy.o op.o log.o
	$(CC) -o td4asm asm.tab.o lex.yy.o op.o log.o -Wall -ly -lfl -lm

asm.tab.o: asm.tab.h
lex.yy.o: lex.yy.c

op.o: 
	$(CC) -o op.o -c src/op/op.c

log.o: 
	$(CC) -o log.o -c src/log/log.c

asm.tab.c: src/asm.y
	$(BISON) src/asm.y

lex.yy.c: src/asm.l asm.tab.c
	$(FLEX) src/asm.l

.PHONY: clean
clean:
	rm -f td4asm asm.tab.c asm.tab.h lex.yy.c *.o

.PHONY: re
re: clean all 
