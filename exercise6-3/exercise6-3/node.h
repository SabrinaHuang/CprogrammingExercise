//
//  node.h
//  exercise6-3
//
//  Created by Sabrina on 29/2/16.
//  Copyright © 2016 yunda. All rights reserved.
//

#ifndef node_h
#define node_h

#include <stdio.h>

struct linelist
{
    struct linelist *next;
    int line;
};

struct wordtree
{
    char *word;
    struct linelist *firstline;
    struct wordtree *left;
    struct wordtree *right;
};

void printlist( struct linelist *list );
struct wordtree *addword( struct wordtree *node, char *word, int line );
void printTree( struct wordtree *node );

#endif /* node_h */
