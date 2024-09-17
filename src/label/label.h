#ifndef LABEL_H
#define LABEL_H

typedef struct reference
{
    /* data */
    int refaddress;
    char *labelname;
} reference;

typedef struct label
{
    /* data */
    int address;
    char *labelname;
} label;

#endif
