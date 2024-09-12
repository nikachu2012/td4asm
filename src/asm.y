%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <stdint.h>

#include "src/op/op.h"
#include "src/log/log.h"

int isDebug;
extern FILE *yyin;
extern FILE *yyout;

int current_line = 1;
char *input, *output;

extern int yylex(void);
void yyerror(const char *msg);
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
input : expr LF { current_line++; }
| input expr LF { current_line++; }
| LF { exit(0); }
;

expr : KEYWORD {
    devlogf("parse (line:%d) op: %s\n", current_line, $1);

    operate_keyword p;
    if(search_keyword_list(&p, $1)){
        yyerror("undefined operation");
    }
    else{
        devlogf("convert to: 0x%x\n", p.opcode | 0x00);

        uint8_t opcode = p.opcode | 0x00;
        fwrite(&opcode, sizeof(uint8_t), 1, yyout);
    }
    free($1);
}
| KEYWORD REGISTER SPLITTER IMDATA {
    devlogf("parse (line:%d) op: %s %c, 0x%x\n", current_line, $1, $2, $4);

    operate_keyword_reg_im p;
    if(search_keyword_reg_im_list(&p, $1, $2 & 0x0f))
    {
        yyerror("undefined operation");
        
    }
    else
    {
        devlogf("convert to: 0x%x\n", p.opcode | ($4 & 0x0f));

        uint8_t opcode = p.opcode | ($4 & 0x0f);
        fwrite(&opcode, sizeof(uint8_t), 1, yyout);
    }
    free($1);
}
| KEYWORD REGISTER SPLITTER REGISTER {
    devlogf("parse (line:%d) op: %s %c, %c\n", current_line, $1, $2, $4);

    operate_keyword_reg_reg p;
    if(search_keyword_reg_reg_list(&p, $1, $2 & 0x0f, $4 & 0x0f))
    {
        yyerror("undefined operation");
    }
    else
    {
        devlogf("convert to: 0x%x\n", p.opcode);

        uint8_t opcode = p.opcode;
        fwrite(&opcode, sizeof(uint8_t), 1, yyout);
    }
    free($1);
}
| KEYWORD REGISTER {
    devlogf("parse (line:%d) op: %s %c\n", current_line, $1, $2);

    operate_keyword_reg p;
    if(search_keyword_reg_list(&p, $1, $2 & 0x0f)){
        yyerror("undefined operation");
    }
    else{
        devlogf("convert to: 0x%x\n", p.opcode);

        uint8_t opcode = p.opcode;
        fwrite(&opcode, sizeof(uint8_t), 1, yyout);
    }
    free($1);

}
| KEYWORD IMDATA {
    devlogf("parse (line:%d) op: %s 0x%x\n", current_line, $1, $2);

    operate_keyword_im p;
    if(search_keyword_im_list(&p, $1)){
        yyerror("undefined operation");
    }
    else{
        devlogf("convert to: 0x%x\n", p.opcode | ($2 & 0x0f));

        uint8_t opcode = p.opcode | ($2 & 0x0f);
        fwrite(&opcode, sizeof(uint8_t), 1, yyout);
    }
    free($1);
}
;

%%
int main(int argc, char **argv)
{
    int opt, flg = 0;
    
    while ((opt = getopt(argc, argv, "i:o:d")) != -1)
    {
        switch (opt)
        {
            case 'd':
                isDebug = 1;
                break;

            case 'i':
                if ((input = strdup(optarg)) == NULL)
                {
                    fprintf(stderr, "error:  Input memory allocate error.\n");
                    return 1;
                }
                flg++;
                break;

            case 'o':
                if ((output = strdup(optarg)) == NULL)
                {
                    fprintf(stderr, "error:  Output memory allocate error.\n");
                    return 1;
                }
                flg++;
                break;

            default:
                printf("Usage: %s [-i inputfile] [-o outputfile] [-d]\n", argv[0]);
                return 1;
                break;
        }
    }

    if (flg < 2) {
        printf("Usage: %s [-i inputfile] [-o outputfile] [-d]\n", argv[0]);
        return 1;
    }

    yyin = fopen(input, "r");
    if(yyin == NULL)
    {
        // error handling
        fprintf(stderr, "error:  Input file (%s) reading error.\n", argv[1]);
        return 1;
    }

    yyout = fopen(output, "wb");
    if(yyout == NULL)
    {
        // error handling
        fprintf(stderr, "error:  Output file (%s) reading error.\n", argv[1]);
        fclose(yyin);
        return 1;
    }

    if(yyparse()){
        fprintf(stderr, "error:  parse error (yyparse() is not returned 0).\n");
        fclose(yyin);
        fclose(yyout);
        return 1;
    }
    fclose(yyin);
    fclose(yyout);
    
    free(input);
    free(output);
    return 0;
}

void yyerror(const char *msg) {
    fprintf(stderr, "%s:%d: error:  %s\n", input, current_line, msg);
}
