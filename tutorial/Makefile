# Makefile
# $@ - get target name
# $< - first item in the dependencies
# $+ - The rest of the items in the dependencies
# gcc -o first first.o
# as -o first.o first.s
all: first

first: first.o
	gcc -o $@ $<

first.o : first.s
	as -o $@ $<

clean:
	rm -vf first *.o
