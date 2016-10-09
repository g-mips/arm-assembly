all: pro pro3

pro3: pro3.o
	ld -o $@ $<

pro3.o: proficiencies3.s
	as -o $@ $<

pro: pro.o
	ld -o $@ $<

pro.o: proficiencies2.s
	as -o $@ $<

clean:
	rm -vf pro* *.o
