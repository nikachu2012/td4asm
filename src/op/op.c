#include "op.h"

operate_keyword operate_keyword_list[] = {
    {"NOP", 0x00} // nop (mov a,0)
};

operate_keyword_reg_im operate_keyword_reg_im_list[] = {
    {"MOV", REG_A, 0x30}, // mov a, im
    {"MOV", REG_B, 0x70}, // mov b, im
    {"ADD", REG_A, 0x00}, // add a, im
    {"ADD", REG_B, 0x50}, // add b, im
};

operate_keyword_reg_reg operate_keyword_reg_reg_list[] = {
    {"MOV", REG_A, REG_B, 0x10}, // mov a, b
    {"MOV", REG_B, REG_A, 0x40}, // mov b, a
};

operate_keyword_reg operate_keyword_reg_list[] = {
    {"IN", REG_A, 0x20},  // in a
    {"IN", REG_B, 0x60},  // in b
    {"OUT", REG_B, 0x90}, // out b
};

operate_keyword_im operate_keyword_im_list[] = {
    {"OUT", 0xB0}, // out im
    {"JMP", 0xF0}, // jmp im
    {"JNC", 0xE0}, // jnc im
};

BOOL search_keyword_list(operate_keyword *writeto, char *opname)
{
    for (size_t i = 0; i < (sizeof(operate_keyword_list) / sizeof(operate_keyword)); i++)
    {
        if (strcmp(operate_keyword_list[i].name, opname) == 0)
        {
            *writeto = operate_keyword_list[i];
            return 0;
        }
        else
        {
            continue;
        }
    }
    return 1;
}
BOOL search_keyword_reg_im_list(operate_keyword_reg_im *writeto, char *opname, REGISTER_VAL reg)
{
    for (size_t i = 0; i < (sizeof(operate_keyword_reg_im_list) / sizeof(operate_keyword_reg_im)); i++)
    {
        if (strcmp(operate_keyword_reg_im_list[i].name, opname) == 0 && operate_keyword_reg_im_list[i].dest_reg == reg)
        {
            *writeto = operate_keyword_reg_im_list[i];
            return 0;
        }
        else
        {
            continue;
        }
    }
    return 1;
}
BOOL search_keyword_reg_reg_list(operate_keyword_reg_reg *writeto, char *opname, REGISTER_VAL dest_reg, REGISTER_VAL source_reg)
{
    for (size_t i = 0; i < (sizeof(operate_keyword_reg_reg_list) / sizeof(operate_keyword_reg_reg)); i++)
    {
        if (strcmp(operate_keyword_reg_reg_list[i].name, opname) == 0 && operate_keyword_reg_reg_list[i].dest_reg == dest_reg && operate_keyword_reg_reg_list[i].source_reg == source_reg)
        {
            *writeto = operate_keyword_reg_reg_list[i];
            return 0;
        }
        else
        {
            continue;
        }
    }
    return 1;
}
BOOL search_keyword_reg_list(operate_keyword_reg *writeto, char *opname, REGISTER_VAL reg)
{
    for (size_t i = 0; i < (sizeof(operate_keyword_reg_list) / sizeof(operate_keyword_reg)); i++)
    {
        if (strcmp(operate_keyword_reg_list[i].name, opname) == 0 && operate_keyword_reg_list[i].target_reg == reg)
        {
            *writeto = operate_keyword_reg_list[i];
            return 0;
        }
        else
        {
            continue;
        }
    }
    return 1;
}
BOOL search_keyword_im_list(operate_keyword_im *writeto, char *opname)
{
    for (size_t i = 0; i < (sizeof(operate_keyword_im_list) / sizeof(operate_keyword)); i++)
    {
        if (strcmp(operate_keyword_im_list[i].name, opname) == 0)
        {
            *writeto = operate_keyword_im_list[i];
            return 0;
        }
        else
        {
            continue;
        }
    }
    return 1;
}
