//
//  SAstring.c
//  exercise6-3
//
//  Created by Sabrina on 29/2/16.
//  Copyright © 2016 yunda. All rights reserved.
//

#include "SAstring.h"
#include <string.h>
#include <ctype.h>

char *dupstr(char *s)
{
    char *p = NULL;
    
    if (NULL != s)
    {
        p = malloc(strlen(s) + 1 );
        if (p)
        {
            strcpy(p, s);
        }
    }

    return p;
}

// 不区分大小写的文本比较
int SAstrcmp( const char *s, const char *t )
{
    while ( (tolower(*s) ==  tolower(*t)) && *s && *t )
    {
        ++s;
        ++t;
    }
    
    return tolower(*s) -  tolower(*t);
}

