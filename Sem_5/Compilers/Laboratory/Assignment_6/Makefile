tinyc: y.tab.o lex.yy.o ass6_17CS10038_17CS30022_translator.o ass6_17CS10038_17CS30022_target_translator.o 
	g++ -g ass6_17CS10038_17CS30022_translator.o ass6_17CS10038_17CS30022_target_translator.o lex.yy.o y.tab.o -lfl -o tinyc
	 ./tinyc < ass6_17CS10038_17CS30022_test1.c
	 ./tinyc < ass6_17CS10038_17CS30022_test2.c 
	 ./tinyc < ass6_17CS10038_17CS30022_test3.c
	 ./tinyc < ass6_17CS10038_17CS30022_test4.c
	 ./tinyc < ass6_17CS10038_17CS30022_test5.c	
	# Run "make run" to execute all the test files at once
lex.yy.c: ass6_17CS10038_17CS30022.l
	flex ass6_17CS10038_17CS30022.l
y.tab.c: ass6_17CS10038_17CS30022.y
	yacc -dtv ass6_17CS10038_17CS30022.y
ass6_17CS10038_17CS30022_target_translator.o: ass6_17CS10038_17CS30022_target_translator.cxx
	g++ -g -c ass6_17CS10038_17CS30022_target_translator.cxx
ass6_17CS10038_17CS30022_translator.o: ass6_17CS10038_17CS30022_translator.cxx
	g++ -g -c ass6_17CS10038_17CS30022_translator.cxx
lex.yy.o: lex.yy.c
	g++ -g -c lex.yy.c
y.tab.o:    y.tab.c
	g++ -g -DYYDEBUG -c y.tab.c
libass2_16CS10042.a: ass2_16CS10042.o
	ar -rcs libass2_16CS10042.a ass2_16CS10042.o

ass2_16CS10042.o: ass2_16CS10042.c myl.h
	gcc -Wall  -c ass2_16CS10042.c
clean:
	rm test1 test2 test3 test4 test5 lex.yy.c y.tab.h y.output y.tab.c lex.yy.o y.tab.o ass6_17CS10038_17CS30022_translator.o pointerhandling.o ass6_17CS10038_17CS30022_target_translator.o ass6_17CS10038_17CS30022_test1.o ass6_17CS10038_17CS30022_test2.o ass6_17CS10038_17CS30022_test3.o ass6_17CS10038_17CS30022_test4.o ass6_17CS10038_17CS30022_test5.o libass2_16CS10042.a ass2_16CS10042.o output.o pointerhandling.out ass6_17CS10038_17CS30022_quad1.out ass6_17CS10038_17CS30022_quad2.out ass6_17CS10038_17CS30022_quad3.out ass6_17CS10038_17CS30022_quad4.out ass6_17CS10038_17CS30022_quad5.out ass6_17CS10038_17CS30022_test1.s ass6_17CS10038_17CS30022_test2.s ass6_17CS10038_17CS30022_test3.s ass6_17CS10038_17CS30022_test4.s ass6_17CS10038_17CS30022_test5.s


test1: ass6_17CS10038_17CS30022_test1.o libass2_16CS10042.a
	gcc -g ass6_17CS10038_17CS30022_test1.o -o test1 -L. -lass2_16CS10042
ass6_17CS10038_17CS30022_test1.o: ass6_17CS10038_17CS30022_test1.s myl.h
	gcc -g -Wall  -c ass6_17CS10038_17CS30022_test1.s -o ass6_17CS10038_17CS30022_test1.o

test2: ass6_17CS10038_17CS30022_test2.o libass2_16CS10042.a
	gcc -g  ass6_17CS10038_17CS30022_test2.o -o test2 -L. -lass2_16CS10042
ass6_17CS10038_17CS30022_test2.o: ass6_17CS10038_17CS30022_test2.s myl.h
	gcc -g -Wall -c ass6_17CS10038_17CS30022_test2.s

test3: ass6_17CS10038_17CS30022_test3.o libass2_16CS10042.a
	gcc -g  ass6_17CS10038_17CS30022_test3.o -o test3 -L. -lass2_16CS10042
ass6_17CS10038_17CS30022_test3.o: ass6_17CS10038_17CS30022_test3.s myl.h
	gcc -g -Wall  -c ass6_17CS10038_17CS30022_test3.s

test4: ass6_17CS10038_17CS30022_test4.o libass2_16CS10042.a
	gcc -g  ass6_17CS10038_17CS30022_test4.o -o test4 -L. -lass2_16CS10042
ass6_17CS10038_17CS30022_test4.o: ass6_17CS10038_17CS30022_test4.s myl.h
	gcc -g -Wall  -c ass6_17CS10038_17CS30022_test4.s

test5: ass6_17CS10038_17CS30022_test5.o libass2_16CS10042.a
	gcc -g  ass6_17CS10038_17CS30022_test5.o -o test5 -L. -lass2_16CS10042
ass6_17CS10038_17CS30022_test5.o: ass6_17CS10038_17CS30022_test5.s myl.h
	gcc -g -Wall -c ass6_17CS10038_17CS30022_test5.s

pointerhandling:pointerhandling.o libass2_16CS10042.a
	gcc -g  pointerhandling.o -o pointerhandling -L. -lass2_16CS10042
pointerhandling.o: pointerhandling.s myl.h
	gcc -g -Wall -c pointerhandling.s

#output: output.o
output: output.o libass2_16CS10042.a
	gcc -g  output.o -o output -L. -lass2_16CS10042
output.o: output.s myl.h
	gcc -g -Wall -c output.s

run: 
		
	./tinyc < ass6_17CS10038_17CS30022_test1.c > ass6_17CS10038_17CS30022_quad1.out
  	
	mv output.s ass6_17CS10038_17CS30022_test1.s
	
	make test1
	
	./tinyc < ass6_17CS10038_17CS30022_test2.c > ass6_17CS10038_17CS30022_quad2.out

	mv output.s ass6_17CS10038_17CS30022_test2.s
	
	make test2

	./tinyc < ass6_17CS10038_17CS30022_test3.c > ass6_17CS10038_17CS30022_quad3.out

	mv output.s ass6_17CS10038_17CS30022_test3.s

	make test3

	./tinyc < ass6_17CS10038_17CS30022_test4.c > ass6_17CS10038_17CS30022_quad4.out
	
	mv output.s ass6_17CS10038_17CS30022_test4.s

	make test4

	./tinyc < ass6_17CS10038_17CS30022_test5.c > ass6_17CS10038_17CS30022_quad5.out
	
	mv output.s ass6_17CS10038_17CS30022_test5.s

	make test5
	
	./tinyc < pointerhandling.c > pointerhandling.out
	
	mv output.s pointerhandling.s

	make pointerhandling
	#Below are the individual commands for compiling each test file
	#./test1
	#./test2
	#./test3
	#./test4
	#./test5
	#./pointerhandling

