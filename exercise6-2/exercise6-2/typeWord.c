//
//  typeWord.c
//  exercise6-2
//
//  Created by Sabrina on 4/3/16.
//  Copyright © 2016 yunda. All rights reserved.
//

#include "typeWord.h"
#include <string.h>

#define NKEY (sizeof(typeList)/sizeof(typeList[0]))
#define NDECORATEKEY ( sizeof(keyList)/sizeof(keyList[0]) )

int binSearch( const char *word, const char *list[], int low, int high );

static const char *typeList[] =
{
    "FILE",
    "char",
    "double",
    "float",
    "int",
    "long",
    "size_t",
    "void"
};

// c语言中的类型修饰符
static const char *keyList[] =
{
    "auto",
    "const",
    "extern",
    "register",
    "short",
    "signed",
    "static",
    "unsigned",
    "volatile"
};

int isTypeWord(const char *w)
{
    int c = binSearch(w, typeList, 0, NKEY - 1);
    
    return c;
}

int isKeyWord(const char *w)
{
    return binSearch(w,keyList, 0, NDECORATEKEY - 1);
}

int binSearch( const char *word, const char *list[], int low, int high )
{
    if (  NULL == word || NULL == list)
    {
        return 0;
    }

    // 匹配失败
    if (low >= high)
    {
        return 0;
    }
    
    int mid = ( low + high )/2;
    int cond;
    int result;
    
    cond = strcmp( word, list[mid]);
    if (0 == cond)
    {
        return 1;
    }
    else if (0 > cond)
    {
        result = binSearch(word,list, low, mid - 1 );
    }
    else if (0 < cond)
    {
        result = binSearch(word,list, mid + 1 , high);
    }
    
    return result;
}


