//
//  node.h
//  exercise6-2
//
//  Created by Sabrina on 3/3/16.
//  Copyright © 2016 yunda. All rights reserved.
//

#ifndef node_h
#define node_h

#include <stdio.h>

// 用于比较的开头处的字符个数
extern int g_compLimit;

struct varListNode{
    // 开头的字符串
    char *headWord;
    struct wordNode *list;
    
    struct varListNode *left;
    struct varListNode *right;
};

struct wordNode
{
    char *word;
    struct wordNode *next;
};

struct varListNode *addVar( struct varListNode *root, char *var );
int printVarList( struct varListNode *root );


#endif /* node_h */
