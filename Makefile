all: pro

pro: pro.o
	gcc -o $@ $<

pro.o: proficiencies.s
	as -o $@ $<

clean:
	rm -vf pro *.o
