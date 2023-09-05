C_SOURCES = $(wildcard kernel/*.c drivers/*.c *.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h *.h)
OBJ = ${C_SOURCES:.c=.o}

# test
test: ../karasu/string.h test.c
	gcc test.c -g -o test

clean:
	rm -rf *.o test
