//
//  stack.c
//  exercise6-3
//
//  Created by Sabrina on 1/3/16.
//  Copyright © 2016 yunda. All rights reserved.
//

#include "stack.h"
#include <memory.h>

#define MAXSIZE 100

static void *dataArray[MAXSIZE];

static int SAindex = 0;

void *pop()
{
    if (0 == SAindex)
    {
        return NULL;
    }
    
    return dataArray[--SAindex];
}

void push( void *s)
{
    if (SAindex < MAXSIZE - 1)
    {
        dataArray[SAindex++] = s;
    }
}

void stackClear()
{
    SAindex = 0;
    memset( dataArray, '\0', MAXSIZE );
}