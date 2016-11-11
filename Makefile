all: test pro pro2 pro3 pro4 pro5

# pro5
pro5: pro5.o
	gcc -o $@ $+ -g

pro5.o: proficiencies5.s
	as -o $@ $< -g -mfpu=neon-vfpv4

# pro4
pro4: pro4.o toolsT.o
	ld -o $@ $+ -g

pro4.o: proficiencies4.s
	as -o $@ $< -g

# pro3
pro3: pro3.o tools.o
	ld -o $@ $+ -g 

pro3.o: proficiencies3.s
	as -o $@ $< -g

# pro2
pro2: pro2.o tools.o
	ld -o $@ $+ -g

pro2.o: proficiencies2.s
	as -o $@ $< -g

# pro
pro: pro.o
	gcc -o $@ $+ -g

pro.o: proficiencies.s
	as -o $@ $< -g 

# test
test: test.o tools.o
	ld -o $@ $+ -g

test.o: test.s
	as -o $@ $< -g

# tools ARM and tools THUMB
tools.o: tools.s
	as -o $@ $< -g

toolsT.o: toolsT.s
	as -o $@ $< -g

clean:
	rm -vf pro pro2 pro3 pro4 pro5 tools toolsT *.o
