%{
#include <string.h>
#include "hypiu-asm.tab.h"
extern void yyerror(char *s);
%}

%%
[ \t]       ;
[\n]        { return NEWLINE; }
[,]         { return COMMA; }
r[0-9]+     {
  int reg = atoi(yytext+1);
  if (reg < 8) {
    yylval.ival = reg;
    return REGISTER;
  } else {
    yyerror("Register number too large.");
  }
}
[0-9]+      {
  int lit = atoi(yytext);
  if (lit < (1<<12)) {
    yylval.ival = lit;
    return LITERAL;
  } else {
    yyerror("Literal too large.");
  }
}
[A-Z]+:     { yylval.sval = strdup(yytext); yylval.sval[strlen(yytext)-1] = 0; return LABEL_DEF; }
[A-Z]+      { yylval.sval = strdup(yytext); return LABEL_USE; }

ldi         { return LDI; }
addi        { return ADDI; }
subi        { return SUBI; }
brz         { return BRZ; }
add         { return ADD; }
mov         { return MOV; }
jmp         { return JMP; }
%%
