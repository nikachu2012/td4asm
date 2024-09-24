FLEX = flex -I
BISON = bison -d

OUTNAME = td4asm
OBJ = asm.tab.o lex.yy.o src/op/op.o src/log/log.o src/label/label.o
LIBS = -ly -lfl -lm
CC = gcc


.PHONY: all
all: td4asm

$(OUTNAME): $(OBJ)
	$(CC) -o $(OUTNAME) $(OBJ) $(LIBS) -Wall

asm.tab.c: src/asm.y
	$(BISON) src/asm.y

lex.yy.c: src/asm.l asm.tab.c
	$(FLEX) src/asm.l

.PHONY: clean
clean:
	rm -f td4asm asm.tab.c asm.tab.h lex.yy.c *.o

.PHONY: re
re: clean all 
