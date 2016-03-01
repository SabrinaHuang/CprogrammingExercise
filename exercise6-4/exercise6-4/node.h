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

struct wordlist
{
    struct wordlist *next;
    char *s;
};

struct wordCntTree
{
    int wordNum;
    struct wordlist *firstword;
    struct wordCntTree *left;
    struct wordCntTree *right;
};

struct wordtree
{
    char *word;
    struct linelist *firstline;
    struct wordtree *left;
    struct wordtree *right;
};

void printlist( struct linelist *list );
void printTree( struct wordtree *node );
struct wordtree *addword( struct wordtree *node, char *word, int line );
struct wordCntTree *addWordCnt( struct wordCntTree *node, char *word );
struct wordlist *wAlloc( char *word );


#endif /* node_h */
