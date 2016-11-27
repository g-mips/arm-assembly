all: sudoku sudoku_debug

release: sudoku

debug: sudoku_debug

sudoku_debug: sudoku_debug.o tools_debug.o
	ld -o $@ $+ -g

sudoku_debug.o: main.s
	as -o $@ $< -g

sudoku: sudoku.o tools.o
	ld -o $@ $+

sudoku.o: main.s
	as -o $@ $<

tools.o: tools.s
	as -o $@ $<

tools_debug.o: tools.s
	as -o $@ $< -g

clean:
	rm -vf sudoku_debug sudoku *.o
