//
//  preCompileMacroSample.h
//  lookupTableSample
//
//  Created by 昭蕾王 on 16/3/6.
//  Copyright © 2016年 personal. All rights reserved.
//

#ifndef preCompileMacroSample_h
#define preCompileMacroSample_h

#include <stdio.h>

struct SAnlist *install( char *key, char *value );
struct SAnlist *lookup( char *key );
int printChainList();
int undef( char *key );
unsigned hash(char *s);

#endif /* preCompileMacroSample_h */
