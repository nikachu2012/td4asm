#include "log.h"

int isDebug = 0;

void devlogf(const char *format, ...)
{
    if (isDebug)
    {
        va_list ap;
        va_start(ap, format);

        vprintf(format, ap); // to stdout
        va_end(ap);
    }
}
