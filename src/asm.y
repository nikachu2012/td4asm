%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "src/op/op.h"
#include "src/log/log.h"

extern int isDebug;
%}


%union {
    char *keyword;
    char reg;
    int imdata;
    int opcode;
}

%token LF
%token SPLITTER

%token <imdata> IMDATA
%token <keyword> KEYWORD
%token <reg> REGISTER


%type <opcode> expr

%%
input : expr LF
| input expr LF
| LF { exit(0); }
;

expr : KEYWORD {
    devlogf("parse (line:%d) op: %s\n", @1.first_line, $1);

    operate_keyword p;
    if(search_keyword_list(&p, $1)){
        yyerror(@1.first_line, "undefined operation");
    }
    else{
        devlogf("convert to: 0x%x\n", p.opcode | 0x00);

        $$ = p.opcode | 0x00;
    }

}
| KEYWORD REGISTER SPLITTER IMDATA {
    devlogf("parse (line:%d) op: %s %c, 0x%x\n", @1.first_line, $1, $2, $4);

    operate_keyword_reg_im p;
    if(search_keyword_reg_im_list(&p, $1, $2 & 0x0f))
    {
        yyerror(@1.first_line, "undefined operation");
    }
    else
    {
        devlogf("convert to: 0x%x\n", p.opcode | ($4 & 0x0f));

        $$ = p.opcode | ($4 & 0x0f);
    }
}
| KEYWORD REGISTER SPLITTER REGISTER {
    devlogf("parse (line:%d) op: %s %c, %c\n", @1.first_line, $1, $2, $4);

    operate_keyword_reg_reg p;
    if(search_keyword_reg_reg_list(&p, $1, $2 & 0x0f, $4 & 0x0f))
    {
        yyerror(@1.first_line, "undefined operation");
    }
    else
    {
        devlogf("convert to: 0x%x\n", p.opcode);

        $$ = p.opcode;
    }
}
| KEYWORD REGISTER {
    devlogf("parse (line:%d) op: %s %c\n", @1.first_line, $1, $2);

    operate_keyword_reg p;
    if(search_keyword_reg_list(&p, $1, $2 & 0x0f)){
        yyerror(@1.first_line, "undefined operation");
    }
    else{
        devlogf("convert to: 0x%x\n", p.opcode);

        $$ = p.opcode;
    }
}
| KEYWORD IMDATA {
    devlogf("parse (line:%d) op: %s 0x%x\n", @1.first_line, $1, $2);

    operate_keyword_im p;
    if(search_keyword_im_list(&p, $1)){
        yyerror(@1.first_line, "undefined operation");
    }
    else{
        devlogf("convert to: 0x%x\n", p.opcode | ($2 & 0x0f));

        $$ = p.opcode | ($2 & 0x0f);
    }
}
;

%%

int main()
{
    isDebug = 1;

    yyparse();
    
    return 0;
}

void yyerror(int line, const char *msg) {
    fprintf(stderr, "ERROR  line: %d  %s\n", line, msg);
}
