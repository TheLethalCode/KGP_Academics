all: a.out asgn4_17CS30022_test.c 
	./a.out < asgn4_17CS30022_test.c

a.out: lex.yy.c y.tab.c asgn4_17CS30022.c
	gcc lex.yy.c y.tab.c asgn4_17CS30022.c -lfl

lex.yy.c: asgn4_17CS30022.l
	flex asgn4_17CS30022.l

y.tab.c: asgn4_17CS30022.y
	yacc -dtv asgn4_17CS30022.y

clean:
	rm lex.yy.c y.tab.c y.tab.h y.output a.out