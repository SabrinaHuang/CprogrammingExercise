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

struct wordNode *wAlloc( char *s );
struct varListNode *vAlloc( char *var );
struct wordNode *addWordNode( struct wordNode *node, char *s );
int printWordList( struct wordNode *node );
int printVarList( struct varListNode *root );

int g_compLimit = 0;

// 添加一个变量节点
struct varListNode *addVar( struct varListNode *root, char *var )
{
    int cond = 0;
    
    if (NULL == var)
    {
        return root;
    }
    
    if (NULL == root)
    {
        root = vAlloc(var);
    }
    // var的开头正是headWord，加入list里
    else if( 0 == (cond = strncmp(var, root->headWord, g_compLimit)))
    {
        root->list = addWordNode(root->list, var);
    }
    // var比headWord小，走左分支
    else if (0 > cond)
    {
        root->left = addVar( root->left, var );
    }
    else if (0 < cond)
    {
        root->right = addVar(root->right, var);
    }
    
    return root;
}


// 在变量链表中添加一项
struct wordNode *addWordNode( struct wordNode *node, char *s )
{
    int cond = 0;
    
    if (NULL == s)
    {
        return node;
    }
    
    if (NULL == node)
    {
        node = wAlloc(s);
    }
    else
    {
        // 当前节点就是word的节点
        if (0 == ( cond = strcmp( node->word, s )))
        {
            ;
        }
        else
        {
            node->next = addWordNode(node->next, s);
        }
    }
    
    return node;
}

// 添加节点
struct wordNode *wAlloc( char *s )
{
    struct wordNode *node = malloc( sizeof(struct wordNode));
    
    if (node)
    {
        node->word = strdup(s);
        node->next = NULL;
    }
    
    return node;
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
        v->list = addWordNode( NULL, var );
    }
    
    return v;
}

int printWordList( struct wordNode *node )
{
    if (NULL == node)
    {
        return 0;
    }
    
    printf("%s, ",node->word);
    printWordList(node->next);
    return 0;
}

int printVarList( struct varListNode *root )
{
    if (NULL == root)
    {
        return 0;
    }
    
    printVarList( root->left );
    
    printf("vars: ");
    printWordList(root->list);
    printf("has the begining %s.\n", root->headWord);
    
    printVarList( root->right );
    
    return 0;
}
