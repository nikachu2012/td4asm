%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <stdint.h>

#include "src/op/op.h"
#include "src/log/log.h"
#include "src/label/label.h"

#define MEMORY_SIZE 16

int isDebug;
extern FILE *yyin;
extern FILE *yyout;

extern int currentLabelIndex;
extern int currentRefIndex;
extern label labelList[];
extern reference referenceList[];

uint8_t result[MEMORY_SIZE];
int current_line = 1, nowAddress = 0;
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
%token LABEL

%token <imdata> IMDATA
%token <keyword> KEYWORD
%token <reg> REGISTER

%type <opcode> expr

%%
input : line LF { current_line++; }
| input line LF { current_line++; }
| LF { exit(0); }
;

line : expr {
    nowAddress++;
    if(nowAddress >= MEMORY_SIZE)
    {
        YYACCEPT;
    }
}
| KEYWORD LABEL expr {    
    label labelData = { nowAddress, strdup($1) };
    printf("label address 0x%02x, %s\n", labelData.address, labelData.labelname);

    int status = addLabel(labelData);

    nowAddress++;
    if(nowAddress >= MEMORY_SIZE)
    {
        YYACCEPT;
    }
}


expr : KEYWORD {
    devlogf("parse (line:%d) op: %s\n", current_line, $1);

    operate_keyword p;
    if(search_keyword_list(&p, $1)){
        yyerror("undefined operation");
    }
    else{
        uint8_t opcode = p.opcode | 0x00;
        devlogf("output: %02x: 0x%x\n", nowAddress, opcode);

        result[nowAddress] = opcode;
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
        uint8_t opcode = p.opcode | ($4 & 0x0f);
        devlogf("output: %02x: 0x%x\n", nowAddress, opcode);

        result[nowAddress] = opcode;
    }
    free($1);
}
| KEYWORD REGISTER SPLITTER KEYWORD {
    devlogf("%s:%d: parsed: OP REGISTER WITH KEYWORD / op: %s label: %s, 0x%x\n", input, current_line, $1, $4, $2);
    // add keyword reference   

    operate_keyword_reg_im p;
    if(search_keyword_reg_im_list(&p, $1, $2 & 0x0f))
    {
        yyerror("undefined operation");
    }
    else
    {
        uint8_t opcode = p.opcode;
        devlogf("output: %02x: 0x%x\n", nowAddress, opcode);

        result[nowAddress] = opcode;

        reference addReference = { nowAddress, strdup($4) };
        addRef(addReference);
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
        uint8_t opcode = p.opcode;
        devlogf("output: %02x: 0x%x\n", nowAddress, opcode);

        result[nowAddress] = opcode;
    }
    free($1);
}
| KEYWORD REGISTER {
    devlogf("parse (line:%d) op: %s %c\n", current_line, $1, $2);

    operate_keyword_reg p;
    if(search_keyword_reg_list(&p, $1, $2 & 0x0f)){
        yyerror("undefined operation");
    }
    else
    {
        uint8_t opcode = p.opcode;
        devlogf("output: %02x: 0x%x\n", nowAddress, opcode);

        result[nowAddress] = opcode;
    }
    free($1);

}
| KEYWORD IMDATA {
    devlogf("parse (line:%d) op: %s 0x%x\n", current_line, $1, $2);

    operate_keyword_im p;
    if(search_keyword_im_list(&p, $1)){
        yyerror("undefined operation");
    }
    else
    {
        uint8_t opcode = p.opcode | ($2 & 0x0f);
        devlogf("output: %02x: 0x%x\n", nowAddress, opcode);

        result[nowAddress] = opcode;
    }
    free($1);
}
| KEYWORD KEYWORD {
    devlogf("parse (line:%d) op: %s label:%s\n", current_line, $1, $2);

    operate_keyword_im p;
    if(search_keyword_im_list(&p, $1)){
        yyerror("undefined operation");
    }
    else
    {
        uint8_t opcode = p.opcode;
        devlogf("output: %02x: 0x%x\n", nowAddress, opcode);

        result[nowAddress] = opcode;

        // save reference
        reference tempRef = {nowAddress, strdup($2)};
        addRef(tempRef);
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

    for (int i = 0; i < currentRefIndex; i++)
    {   
        label *targetLabel = searchLabel(referenceList[i].labelname);

        if (targetLabel != NULL){
            devlogf("gen:   Label %s address 0x%02x to address 0x%02x\n", referenceList[i].labelname, referenceList[i].refaddress, targetLabel->address & 0x0f);
            result[referenceList[i].refaddress] |= (targetLabel->address & 0x0f);
        }
        else{
            fprintf(stderr, "error:  label: %s is not defined.\n", referenceList[i].labelname);
            return 1;
        }
    }

    for (int i = 0; i < MEMORY_SIZE; i++)
    {
        fwrite(&result[i], sizeof(uint8_t), 1, yyout);
    }
    
    fclose(yyin);
    fclose(yyout);
    
    free(input);
    free(output);
    freeLabelRef();
    
    return 0;
}

void yyerror(const char *msg) {
    fprintf(stderr, "%s:%d: error:  %s\n", input, current_line, msg);
}
