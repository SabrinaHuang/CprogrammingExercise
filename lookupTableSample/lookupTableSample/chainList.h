//
//  chainList.h
//  lookupTableSample
//
//  Created by 昭蕾王 on 16/3/6.
//  Copyright © 2016年 personal. All rights reserved.
//

#ifndef chainList_h
#define chainList_h

#include <stdio.h>

struct SAnlist
{
    struct SAnlist *next;
    char *name;         // 键
    char *defn;         // 对应的键值
};



#endif /* chainList_h */
