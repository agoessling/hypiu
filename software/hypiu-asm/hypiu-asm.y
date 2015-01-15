%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yyparse();
extern int yylex();
extern FILE *yyin;
void yyerror(const char *s);

int input_line_num = 1;
int output_addr = 0;

int cur_label_def = 0;
int cur_label_use = 0;
int label_use_flag = 0;
typedef struct {
  char *label;
  int addr;
} labelref_t;
labelref_t label_def[128];
labelref_t label_use[128];

FILE *mcode_f;

int encode(int opcode, int rd, int ra, int rb, int literal);
FILE *label_addr_seek(FILE *f, int addr);
void replace_label_refs(void);

#define OPCODE_LDI   0
#define OPCODE_STI   1
#define OPCODE_ADD   2
#define OPCODE_SUB   3
#define OPCODE_ADDI  4
#define OPCODE_SUBI  5
#define OPCODE_MOV   6
#define OPCODE_BRZ   7
#define OPCODE_JMP   8
%}

%union {
  int ival;
  char *sval;
}

%token <ival> REGISTER
%token <ival> LITERAL
%token <sval> LABEL_DEF
%token <sval> LABEL_USE
%token COMMA
%token NEWLINE
%token LDI
%token ADDI
%token SUBI
%token ADD
%token BRZ
%token MOV
%token JMP

%type <ival> statement
%type <ival> instruction
%type <ival> format_rd_imm
%type <ival> format_rd_ra_imm
%type <ival> format_label
%type <ival> format_rd_ra_rb
%type <ival> format_rd_ra

%%
input:    /* empty */
        | input line { input_line_num++; }
          ;
line:
          NEWLINE
        | statement NEWLINE
          ;
statement:
          instruction {
            fprintf(mcode_f, "%06x // %d\n", $1, input_line_num);
            output_addr++;
          }
        | LABEL_DEF {
            label_def[cur_label_def].label = $1;
            label_def[cur_label_def].addr = output_addr;
            cur_label_def++;
            fprintf(mcode_f, "// %s\n", $1);
          }
          ;
instruction:
          LDI format_rd_imm     { $$ = encode(OPCODE_LDI, 0, 0, 0, $2); }
        | ADDI format_rd_ra_imm { $$ = encode(OPCODE_ADDI, 0, 0, 0, $2); }
        | SUBI format_rd_ra_imm { $$ = encode(OPCODE_SUBI, 0, 0, 0, $2); }
        | BRZ format_label      { $$ = encode(OPCODE_BRZ, 0, 0, 0, $2); }
        | ADD format_rd_ra_rb   { $$ = encode(OPCODE_ADD, 0, 0, 0, $2); }
        | MOV format_rd_ra      { $$ = encode(OPCODE_MOV, 0, 0, 0, $2); }
        | JMP format_label      { $$ = encode(OPCODE_JMP, 0, 0, 0, $2); }
          ;
format_rd_ra_rb:
          REGISTER COMMA REGISTER COMMA REGISTER { $$ = encode(0, $1, $3, $5, 0); };
format_rd_ra:
          REGISTER COMMA REGISTER { $$ = encode(0, $1, $3, 0, 0); };
format_rd_ra_imm:
          REGISTER COMMA REGISTER COMMA LITERAL { $$ = encode(0, $1, $3, 0, $5); };
format_rd_imm:
          REGISTER COMMA LITERAL { $$ = encode(0, $1, 0, 0, $3); };
format_label:
          LABEL_USE {
            label_use[cur_label_use].label = $1;
            label_use[cur_label_use].addr = output_addr;
            cur_label_use++;
            $$ = 0;
          }
%%

int main(int argc, char *argv[]) {
  if (argc != 3) {
    printf("Not enough arguments given.\n");
    return -1;
  }

  FILE *asm_f = fopen(argv[1], "r");
  if (!asm_f) {
    printf("Could not open file: %s\n", argv[1]);
    return -1;
  }

  mcode_f = fopen(argv[2], "w+");
  if (!mcode_f) {
    printf("Could not open file: %s\n", argv[2]);
    return -1;
  }

  yyin = asm_f;
  do {
    yyparse();
  } while (!feof(yyin));

  replace_label_refs();

  return 0;
}

void replace_label_refs(void) {
  for (int i=0; i<cur_label_use; ++i) {
    mcode_f = label_addr_seek(mcode_f, label_use[i].addr);

    int def_addr = -1;
    for (int j=0; j<cur_label_def; ++j) {
      if (strcmp(label_use[i].label, label_def[j].label) == 0) {
        if (def_addr != -1)
          yyerror("Multiple label definitions.");
        def_addr = label_def[j].addr;
      }
    }
    if (def_addr == -1)
      yyerror("No matching label.");

    fprintf(mcode_f, "%03x", def_addr);
  }
}

FILE *label_addr_seek(FILE *f, int addr) {
  char *s = malloc(128);

  fseek(f, 0, SEEK_SET);

  int cur_addr = 0;
  while (cur_addr <= addr) {
    s = fgets(s, 128, f);
    if (!s) {
      yyerror("Could not seek to label use address.");
    }

    unsigned int hex;
    if (sscanf(s, "%6x", &hex) == 1) {
      cur_addr++;
    }
  }

  fseek(f, -strlen(s) + 3, SEEK_CUR);
  free(s);
  return f;
}

int encode(int opcode, int rd, int ra, int rb, int literal) {
  int mcode = 0;
  mcode |= opcode << 18;
  mcode |= rd << 15;
  mcode |= ra << 12;
  mcode |= rb << 9;
  mcode |= literal;
  return mcode;
}

void yyerror(const char *s) {
  printf("Parse error! Line: %d Message: %s\n", input_line_num, s);
  exit(-1);
}
