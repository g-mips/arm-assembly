all: pro

pro: pro.o
	ld -o $@ $<

pro.o: proficiencies2.s
	as -o $@ $<

clean:
	rm -vf pro *.o
