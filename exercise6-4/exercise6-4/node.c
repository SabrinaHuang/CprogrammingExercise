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

int printWordCntTree(struct wordCntTree *node)
{
    if (NULL == node)
    {
        return 0;
    }

    printWordCntTree(node->left);
    
    printf("word ");
    // 打印单词列表
    printWordList(node->firstword);
    printf("appear %4d times\n", node->wordNum);
    
    printWordCntTree(node->right);
   
    return 0;
}

int printWordCntList( struct wordCntNode *root)
{
    if (NULL == root)
    {
        return 0;
    }
    
    printf("word %4s appear %4d times\n", root->word, root->wordNum);
    
    return printWordCntList( root->next);
}

int printWordList( struct wordlist *word )
{
    if (NULL == word)
    {
        return 0;
    }
    
    printf("%s ",word->s);
    printWordList( word->next );
    
    return 0;
}

struct wordCntTree *addWordCnt( struct wordCntTree *node, char *word )
{
    if (!word)
    {
        return NULL;
    }

    if (!node)
    {
        node = (struct wordCntTree *)malloc(sizeof(struct wordCntTree ));
        node->left = NULL;
        node->right = NULL;
        node->wordNum = 1;
        node->firstword = wAlloc( word );
    }
    else
    {
        int cond = strcmp( word,node->firstword->s);
        if (0 == cond)
        {
            ++node->wordNum;
        }
        else if (cond < 0)
        {
            node->left = addWordCnt(node->left, word);
        }
        else if (cond > 0)
        {
            node->right = addWordCnt(node->right, word);
        }
    }
    
    return node;
}

struct wordlist *addWordList( struct wordlist *node ,char *word )
{
    // word为空，不处理
    if (NULL == word)
    {
        return node;
    }
    
    if (NULL == node)
        node = wAlloc(word);
    else
        node->next = addWordList(node->next, word);

    return node;
}

struct wordlist *wAlloc( char *word )
{
    struct wordlist *wordNode = malloc(sizeof(struct wordlist));
    if (NULL != word)
    {
        wordNode->s = word;
        wordNode->next = NULL;
    }
    
    return wordNode;
}

struct wordCntNode *wcAlloc( char *s )
{
    struct wordCntNode *wc = malloc(sizeof(struct wordCntNode));
    if (NULL != wc)
    {
        wc->next = NULL;
        wc->word = strdup(s);
        wc->wordNum = 1;
    }
    
    return wc;
}

struct wordCntTree *wtAlloc( struct wordCntNode *list )
{
    if (NULL == list)
    {
        return NULL;
    }
    
    // 新建一个wordCntTree类型的节点
    struct wordCntTree *wordTree = malloc(sizeof(struct wordCntTree));
    if (NULL != wordTree)
    {
        wordTree->left = NULL;
        wordTree->right = NULL;
        wordTree->wordNum = list->wordNum;
        wordTree->firstword = addWordList( wordTree->firstword,list->word );
    }
    
    return wordTree;
}

struct wordCntNode *addWordCntList( struct wordCntNode *w, char *s)
{
    if (NULL == s)
    {
        return NULL;
    }

    if (NULL == w)
    {
        w = wcAlloc(s);
    }
    else if ( 0 == strcmp(w->word, s))
    {
        ++w->wordNum;
        return w;
    }
    // 匹配失败，与下一个节点比较
    else
    {
        w->next = addWordCntList( w->next, s);
    }
    
    return w;
}

// 将wordCntNode中的字符按出现频率排列
struct wordCntTree *sortWordCnt( struct wordCntTree *root, struct wordCntNode *list )
{
    int cond;
    
    if (NULL == root)
    {
        root = wtAlloc(list);
    }
    // 字出现的频率相同，添加到列表中
    else if ( 0 == ( cond = list->wordNum - root->wordNum ))
    {
        root->firstword = addWordList(root->firstword, list->word);
    }
    // 字出现的频率小于当前频率节点，转给左节点处理
    else if (0 > cond )
        root->left = sortWordCnt(root->left, list);
    else if (0 < cond)
        root->right = sortWordCnt(root->right, list);
    
    return root;
}


