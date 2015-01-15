hypiu-asm.tab.c hypiu-asm.tab.h: hypiu-asm.y
	bison -d hypiu-asm.y

lex.yy.c: hypiu-asm.l hypiu-asm.tab.h
	flex hypiu-asm.l

hypiu-asm: lex.yy.c hypiu-asm.tab.c hypiu-asm.tab.h
	gcc -std=gnu99 hypiu-asm.tab.c lex.yy.c -lfl -o hypiu-asm

clean:
	rm -f hypiu-asm hypiu-asm.tab.c hypiu-asm.tab.h lex.yy.c
