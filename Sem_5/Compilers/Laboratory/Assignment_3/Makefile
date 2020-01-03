all: a.out ass3_17CS30022_test.c
	./a.out < ass3_17CS30022_test.c

a.out: lex.yy.c
	gcc lex.yy.c -lfl

lex.yy.c: ass3_17CS30022.l ass3_17CS30022.c
	flex ass3_17CS30022.l ass3_17CS30022.c

clean:
	rm a.out lex.yy.c