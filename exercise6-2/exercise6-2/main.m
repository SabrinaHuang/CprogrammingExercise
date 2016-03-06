//
//  main.m
//  exercise6-2
//
//  Created by Sabrina on 3/3/16.
//  Copyright © 2016 yunda. All rights reserved.
//

/*
    没实现enum,struct,union等复杂类型的变量的识别
*/

#import <Foundation/Foundation.h>
#include <stdio.h>
#include "stack.h"
#include "SAstring.h"
#include "node.h"
#include "typeWord.h"

#define STRLIMIT 200

char *SAgetline();
int getWords( char *s );
int getVar(int *word, int lim);
char *intArrayToCharArray( const int iArray[] );

// 文件指针
FILE *fp = NULL;


int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        // 读取命令行参数
        if (argc < 2)
        {
            printf("no arg for varSorting!\n");
            return -1;
        }
        
        int i = 0;
        
        // 获取‘-n’参数
        while (0 < --argc)
        {
           g_compLimit =  atoi(argv[++i]);
            if (g_compLimit < 0)
            {
                break;
            }
        }
        
        // 没找到参数，直接返回
        if (0 == g_compLimit)
        {
            return -1;
        }
        
        // 获取执行参数
        g_compLimit *= -1;
        int c;
        
        int *word = malloc(sizeof(int) * STRLIMIT );
        struct varListNode *rootVar = NULL;
        stackClear();
        
        fp = fopen("var.h", "r");
        
        if (NULL == fp)
        {
            printf("打开文件资源失败！\n");
            return 0;
        }
        
        // 读取文本行，抽取参数
        while ( EOF != getVar(word, STRLIMIT) )
        {
            char *p = intArrayToCharArray(word);
            
            // 是类型声明，获取后续变量，直到';'终止
            if ( isTypeWord( p ))
            {
                // 单词长度大于等于截取的长度，放入排序队列
                while (';' !=  (c = getVar(word, STRLIMIT)) && (EOF != c) )
                {
                    char *p = intArrayToCharArray(word);
                    if (strlen(p) >= g_compLimit && (0 == isKeyWord( p )) )
                    {
                        push(p);
                    }
                }
            }
        }

        while ( (word = pop()) )
        {
                rootVar = addVar(rootVar, (char *)word);
        }
        
        // 打印var
        printVarList(rootVar);
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

// 获取一条语句中的变量声明（如果有），需按照c语法规定实现
int getVar(int *word, int lim)
{
    int c;
    int *w = word;
    
    // 清空
    memset(word, '\0', lim);
    
    // 跳过空白符
    while (isspace( c = getc(fp) ));
    
    // 获取一个字符
    if (EOF != c)
        *w++ = c;
    
    switch (c)
    {
        case '#':
            while ( '\n' != (c = getc(fp)) );
            word[0] = '\0';
            break;
        // 是注释 /**/ 或 //
        case '/':
            // 取下一个字符
            c = getc(fp);
            
            // 是行注释，格式为// …………  直接忽略
            if ('/' == c )
            {
                while ( '\n' != (c = getc(fp)) &&  (EOF != c) );
            }
            // 是段注释 /*的格式 也忽略
            else if ('*' == c )
            {
                int preChar = 0;
                // 需找结尾的'*/'
                do
                {
                    preChar = c;
                    
                }while ( !('/' == (c = getc(fp))  &&  ('*' == preChar) ) && ( EOF != c ) );
            }
            break;
        // 是字符 ‘’，忽略‘’内的所有字符
        case '\'':
            while ( ('\'' != ( c = getc(fp))) && (EOF != c));
            break;
        // 是字符串 ""，忽略""内的所有字符
        case '\"':
            while ( '\"' != ( c = getc(fp) ) && EOF != c );
            break;
        // 是小括号，忽略作用域里的所有字符
        case '(':
            while ( ')' != (c = getc(fp))  && EOF != c );
            break;
        // 是中括号，忽略作用域里的所有字符
        case '[':
            while ( ']' != (c = getc(fp))  && EOF != c);
            break;
        default:
            break;
    }
    
    // 倘若获取的字符不是字母，直接返回，这个条件判断兼顾了EOF和一般字符的情况
    if (!isalnum(c)  && ('_' != c))
    {
        word[0] = '\0';
        return c;
    }
    
    while (--lim > 0)
    {
        // 并非标识符，返回
        if (!isalnum(*w = getc(fp)) && ( '_' != *w ) )
        {
            ungetc(*w,fp);
            break;
        }
        
        ++w;
    }
    
    *w = '\0';
    
    return word[0];
}


char *intArrayToCharArray( const int iArray[] )
{
    int arraySize = 0;
    while (0 != iArray[arraySize++]);

    char *p = malloc( (arraySize + 1) * sizeof(char));
    
    for (int i = 0; i < arraySize; ++i)
    {
        p[i] = iArray[i];
    }
    
    return p;
}
