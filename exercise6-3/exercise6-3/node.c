//
//  node.c
//  exercise6-3
//
//  Created by Sabrina on 29/2/16.
//  Copyright © 2016 yunda. All rights reserved.
//

#include "node.h"
#include <string.h>
#include <malloc/malloc.h>
#include "SAstring.h"

void printlist( struct linelist *list )
{
    if (list)
    {
        printf("%3d", list->line);
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
struct wordtree *addword( struct wordtree *node, char *word, int line )
{
    struct wordtree *wordloc = NULL;
    struct linelist *newline = NULL;
    struct wordtree *temp = NULL;
    int diff = 0;

    if (NULL == word)
        return NULL;

    // 没有节点
    if ( NULL == node)
    {
        node = (struct wordtree *)malloc(sizeof(struct wordtree));
        node->left = NULL;
        node->right = NULL;
        node->word = SAdupstr(word);
        node->firstline = addlink(line);

    }
    // 有节点
    else
    {
        diff = strcmp(node->word, word);
        
        // 匹配成功.将新的line节点添到fir
        if (0 == diff)
        {
            newline = addlink(line);
            newline->next = node->firstline;
            node->firstline = newline;
        }
        // word比node->word大
        else if (0 > diff)
        {
           node->right = addword( node->right, word, line );
        }
        // word小，加到左边
        else if (0 < diff)
        {
           node->left = addword( node->left, word, line );
        }
    }
    
    return node;
}

