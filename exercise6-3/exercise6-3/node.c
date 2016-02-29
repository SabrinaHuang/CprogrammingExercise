//
//  node.c
//  exercise6-3
//
//  Created by Sabrina on 29/2/16.
//  Copyright © 2016 yunda. All rights reserved.
//

#include "node.h"

void printlist( struct linelist *list )
{
    if (list)
    {
        printf("%4d ", list->line);
        printlist(  list->next );
    }
}

void printTree( struct wordtree *node )
{
    if (node)
    {
        printTree( node->left );
        printf("%s appears in lines:", node->word);
        printlist(node->firstline);
        puts("\n");
        printTree( node->right );
    }
}

// 生成一个linelist对象
struct linelist *addlink( int line )
{
    struct linelist *new = malloc(sizeof(*new));
    if (new)
    {
        new->line = line;
        new->next = NULL;
    }
    
    return new;
}

// 生成一个wordtree对象
struct wordtree *addtree( struct wordtree *node, char *word, int line )
{
    struct wordtree *wordloc = NULL;
    struct linelist *newline = NULL;
    struct wordtree *temp = NULL;
    int diff = 0;

    if (node && word)
    {
        
    }
}