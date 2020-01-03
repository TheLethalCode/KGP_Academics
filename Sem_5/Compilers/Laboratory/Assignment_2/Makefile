a.out: main.o libass2_17CS30022.a
	cc main.o -L. -lass2_17CS30022

main.o: main.c myl.h
	cc -c main.c

libass2_17CS30022.a: ass2_17CS30022.o
	ar -rcs libass2_17CS30022.a ass2_17CS30022.o

ass2_17CS30022.o: ass2_17CS30022.c myl.h
	cc -c ass2_17CS30022.c

clean:
	rm a.out main.o libass2_17CS30022.a ass2_17CS30022.o