//
//  stack.c
//  ex7-5
//
//  Created by Sabrina on 8/3/16.
//  Copyright © 2016 yunda. All rights reserved.
//

#include "stack.h"

#define STACKSIZE 200

static double stack[STACKSIZE] = {0};
static int sp = 0;

double pop(void)
{
    if (sp > 0)
    {
        return stack[--sp];
    }
    
    return 0;
}

void push( double f)
{
    if (sp >= STACKSIZE - 1)
    {
        printf("stack OverFlow!");
        return;
    }
    
    stack[ sp++ ] = f;    
}