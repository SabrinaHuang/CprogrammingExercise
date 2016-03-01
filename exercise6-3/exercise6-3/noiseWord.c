//
//  noiseWord.c
//  exercise6-3
//
//  Created by Sabrina on 1/3/16.
//  Copyright © 2016 yunda. All rights reserved.
//

#include "noiseWord.h"
#include "SAstring.h"
#include <string.h>

#define NKEY ( sizeof(noiseList) / sizeof(noiseList[0]))

static char *noiseList[] =
{
    "a",
    "an",
    "and",
    "be",
    "but",
    "by",
    "he",
    "I",
    "is",
    "it",
    "off",
    "on",
    "she",
    "so",
    "the",
    "they",
    "you"
};

// 判断word是否为噪音,倘若是，返回1，不是，返回0
int isNoise( const char *word )
{
    return binSearch( word, 0, NKEY - 1 );
}

// 用二分法来查找排序好的字符，就是二叉树的原理吧
int binSearch( const char *word, int low, int high )
{
    // 匹配失败
    if (low >= high)
    {
        return 0;
    }
    
    int mid = ( low + high )/2;
    int cond;
    int result;
    
    cond = SAstrcmp( word, noiseList[mid]);
    if (0 == cond)
    {
        result = 1;
    }
    else if (0 > cond)
    {
        result = binSearch(word, low, mid - 1 );
    }
    else if (0 < cond)
    {
        result = binSearch(word, mid + 1 , high);
    }
    
    return result;
}