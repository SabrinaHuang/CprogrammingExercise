//
//  main.m
//  exercise6-3
//
//  Created by Sabrina on 29/2/16.
//  Copyright © 2016 yunda. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "noiseWord.h"
#include "node.h"
#include "SAstring.h"
#include "stack.h"

char *SAgetline();
int getWords( char *s );

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        int nline = 0;
        char *line = NULL;
        char *word = NULL;
        struct wordtree *root  = NULL;
        
        while ( (line = SAgetline()) )
        {
            ++nline;
            getWords(line);
            
            while ( (word = pop()) )
            {
                // 并非噪声字符，将其加入列表
                if ( NO == isNoise(word))
                {
                    root = addword(root, word, nline);
                }
            }
        }
        
        printTree(root);
    }
    
    return 0;
}

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

// 取出一行中的所有单词,返回获取到的单词数
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
    
    do
    {
        push(n);
        ++nWord;
    } while ( (n = strtok(NULL, " ")));
    
    return nWord;
}

