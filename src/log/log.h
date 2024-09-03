#ifndef LOG_H
#define LOG_H

#include <stdio.h>
#include <stdarg.h>

extern int isDebug;

void devlogf(const char *format, ...);

#endif
