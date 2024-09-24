#ifndef OP_H
#define OP_H

#include <stdint.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>

#define REG_A 1
#define REG_B 2

typedef uint8_t REGISTER_VAL;
typedef int BOOL;

// nop
typedef struct
{
    char *name;
    uint8_t opcode;
} operate_keyword;

// mov a,10
typedef struct
{
    char *name;
    REGISTER_VAL dest_reg;

    uint8_t opcode;
} operate_keyword_reg_im;

// mov a,b
typedef struct
{
    char *name;
    REGISTER_VAL dest_reg;
    REGISTER_VAL source_reg;

    uint8_t opcode;
} operate_keyword_reg_reg;

// out b
typedef struct
{
    char *name;
    REGISTER_VAL target_reg;

    uint8_t opcode;
} operate_keyword_reg;

// out 10
typedef struct
{
    char *name;

    uint8_t opcode;
} operate_keyword_im;

char *opCopyUpper(char *opname);

BOOL search_keyword_list(operate_keyword *writeto, char *opname);
BOOL search_keyword_reg_im_list(operate_keyword_reg_im *writeto, char *opname, REGISTER_VAL reg);
BOOL search_keyword_reg_reg_list(operate_keyword_reg_reg *writeto, char *opname, REGISTER_VAL dest_reg, REGISTER_VAL source_reg);
BOOL search_keyword_reg_list(operate_keyword_reg *writeto, char *opname, REGISTER_VAL reg);
BOOL search_keyword_im_list(operate_keyword_im *writeto, char *opname);

#endif
