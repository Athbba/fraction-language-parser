CC      = gcc
CFLAGS  = -Wall -Wno-unused-function

all: fraction_parser

fraction.tab.c fraction.tab.h: fraction.y
	bison -d fraction.y

lex.yy.c: fraction.l fraction.tab.h
	flex fraction.l

fraction_parser: fraction.tab.c lex.yy.c
	$(CC) $(CFLAGS) -o fraction_parser fraction.tab.c lex.yy.c

clean:
	rm -f fraction.tab.c fraction.tab.h lex.yy.c fraction_parser

.PHONY: all clean
