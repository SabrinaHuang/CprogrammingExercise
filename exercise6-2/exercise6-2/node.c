//
//  node.c
//  exercise6-2
//
//  Created by Sabrina on 3/3/16.
//  Copyright © 2016 yunda. All rights reserved.
//

#include "node.h"
#include <malloc/malloc.h>
#include <string.h>

int g_compLimit = 0;

struct varListNode *addVar( struct varListNode *root, char *var )
{
    if (NULL == root)
    {
        
    }
    
}


struct varListNode *vAlloc( char *var )
{
    struct varListNode *v = malloc( sizeof(struct varListNode) );
    
    if (v)
    {
        v->left = NULL;
        v->right = NULL;
        
        char *str = malloc(sizeof(char) * (g_compLimit + 1 ) );
        strncpy(str, var, g_compLimit);
        
        v->headWord = str;
        v->list = 
    }

}