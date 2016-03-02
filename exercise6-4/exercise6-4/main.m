//
//  main.m
//  exercise6-4
//
//  Created by Sabrina on 1/3/16.
//  Copyright © 2016 yunda. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "node.h"
#include "SAstring.h"
#include "stack.h"

int getWords( char *s );
char *SAgetline();

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        char *line = nil;
        char *word = nil;
        struct wordCntNode *wordCnt = nil;
        struct wordCntTree *wordTree = nil;
        
        while ( (line = SAgetline()))
        {
            getWords(line);
            while ((word = pop()))
            {
                wordCnt = addWordCntList(wordCnt, word);
            }
        }
        
        // 按wordcnt排序二叉树
        do
        {
            wordTree = sortWordCnt(wordTree, wordCnt);
        }while ( NULL != (wordCnt = wordCnt->next) );
        
        // 打印二叉树
        printWordCntTree(wordTree);
    }
    return 0;
}

// 获取一行读入
char *SAgetline()
{
    static int i = 0;
    
    static char *content[] =
    {
        "add missing constraints",
        "ios add new constraints",
        "add new constraints",
        "add constraints ios swift",
        "ios add constraints by code",
        "excel add in tab missing",
        "xcode add new constraints",
        "add missing toll",nil
    };
    
    return content[i++];
}



// 取出一行中的所有单词，放入栈中，返回值为获取到的单词数
int getWords( char *s )
{
    //    char s[] = "add missing constraints";
    int nWord = 0;
    char *temp_s = SAdupstr(s);
    char *n = strtok(temp_s, " ");
    
    // 匹配失败
    if (NULL == n || 0 == strcmp(n, s))
    {
        return nWord;
    }
    
    stackClear();
    
    do
    {
        push(n);
        ++nWord;
    } while ( (n = strtok(NULL, " ")));
    
    return nWord;
}
