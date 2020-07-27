C = gcc

librsocket.a : rsocket.o
	ar rcs $@ rsocket.o

rsocket.o : rsocket.c rsocket.h
	$(C) -c rsocket.c -o $@

clean:
	rm rsocket.o librsocket.a