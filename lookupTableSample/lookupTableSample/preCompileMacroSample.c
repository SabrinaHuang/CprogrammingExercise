//
//  preCompileMacroSample.c
//  lookupTableSample
//
//  Created by 昭蕾王 on 16/3/6.
//  Copyright © 2016年 personal. All rights reserved.
//

#include "preCompileMacroSample.h"
#include "chainList.h"
#include <stdlib.h>

#define  HASHSIZE 101

static struct SAnlist *hashtab[HASHSIZE];

// 移除键值为key的哈希表项
int undef( char *key )
{
    struct SAnlist *np;
    struct SAnlist *head;
    
    // 找到定义项，移除
    if (NULL != (np = lookup(key)))
    {
        head = hashtab[ hash(key) ];
        
        if (np == head)
        {
            hashtab[ hash(key) ] = NULL;
        }
        else
        {
            while ( np != head->next )
            {
                head = head->next;
            }
            head->next = np->next;
        }
        
        free((void *)np);
    }
    
    return 0;
}

// 为键值生成hash表中的下标
unsigned hash(char *s)
{
    unsigned hashval;
    
    for (hashval = 0; '\0' != *s ; ++s)
    {
        hashval = *s + hashval * 31;
    }
    
    return hashval %HASHSIZE;
}

struct SAnlist *install( char *key, char *value )
{
    struct SAnlist *np;
    unsigned hashval;
    
    // 不存在，创建
    if (NULL == (np = lookup(key)))
    {
        np = malloc(sizeof(struct SAnlist));
        if ( NULL != np )
        {
            np->name = strdup(key);
            np->defn = strdup(value);
            hashval = hash(key);
            
            // 即使数组元素是NULL，也可以用此方法
            np->next = hashtab[hashval];
            hashtab[hashval] = np;
        }
    }
    // 已存在，用新的defn替换旧的
    else
    {
        free((void *)np->defn);
        np->defn = strdup(value);
    }
    
    return np;
}


struct SAnlist *lookup( char *key )
{
    struct SAnlist *np ;
    
    for (np = hashtab[hash(key)]; NULL != np;  np = np->next )
    {
        // 找到匹配项
        if (0 == strcmp(key, np->name))
        {
            return np;
        }
    }
    
    return NULL;
}

int printChainList(  )
{
    int index;
    struct SAnlist *np;
    
    for (index = 0 ; index < HASHSIZE; ++index)
    {
        if (NULL !=  (np = hashtab[index]))
        {
            for (; NULL != np; np = np->next)
            {
                printf("#define %s %s\n", np->name, np->defn);
            }
        }
    }
    
    return 0;
}