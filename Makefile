file: trab.lex
	flex trab.lex
	gcc lex.yy.c -lfl -o file
