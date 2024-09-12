%{
#include "asm.tab.h"

// extern int yylval;
%}

WHITESPACE [ \t]

KEYWORD ^[a-zA-Z]+
REGISTER [ABab]

SPLITTER ,

DEC_IMDATA [0-9]+

ZEROX_IMDATA 0x([0123456789abcdefABCDEF]+)
h_IMDATA ([0123456789abcdefABCDEF])+h

ZEROB_IMDATA 0b[01]+
b_IMDATA [01]+b

LF         "\n"

%%


{DEC_IMDATA} { 
    yylval.imdata = (int)strtol(yytext, NULL, 10);
    return IMDATA;
}

{ZEROX_IMDATA} { 
    sscanf(yytext, "0x%x", &yylval.imdata);
    return IMDATA; 
}

{h_IMDATA} { 
    sscanf(yytext, "%xh", &yylval.imdata);
    return IMDATA; 
}

{ZEROB_IMDATA} {
    yylval.imdata = (int)strtol(yytext+2, NULL, 2);
    return IMDATA;
}

{b_IMDATA} {
    yylval.imdata = (int)strtol(yytext, NULL, 2);
    return IMDATA;
}


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
