%{
#include "asm.tab.h"

// extern int yylval;
%}

WHITESPACE [ \t]

KEYWORD ^[a-zA-Z]+
REGISTER [ABab]

SPLITTER ,

DEC_IMDATA [0-9]+
HEX_IMDATA 0x([0123456789abcdef]+)|([0123456789abcdef])+h
BIN_IMDATA (0b[01]+|[01]+h)

LF         "\n"

%%


{DEC_IMDATA} { 
    yylval.imdata = atoi(yytext);
    return IMDATA;
}

{HEX_IMDATA} { 
    sscanf(yytext, "%x", &yylval.imdata);
    return IMDATA; 
}

{BIN_IMDATA} { printf("bin integer detected.\n"); }

{LF}      { return(LF); }

{SPLITTER} { return SPLITTER; }

{REGISTER} {
    yylval.reg = yytext[0];
    return REGISTER;
}

{KEYWORD} { 
    yylval.keyword = strdup(yytext);
    return KEYWORD; 
}

{WHITESPACE}
.
%%
