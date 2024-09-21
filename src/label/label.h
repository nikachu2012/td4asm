#ifndef LABEL_H
#define LABEL_H

#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include "../log/log.h"

typedef struct label
{
    /* data */
    int address;
    char *labelname;
} label;

typedef struct reference
{
    /* data */
    int refaddress;
    char *labelname;
} reference;

int addLabel(label add);
int addRef(reference add);

label *searchLabel(char *refName);

void freeLabelRef();

#endif
