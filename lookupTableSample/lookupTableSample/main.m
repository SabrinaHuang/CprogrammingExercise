//
//  main.m
//  lookupTableSample
//
//  Created by 昭蕾王 on 16/3/6.
//  Copyright © 2016年 personal. All rights reserved.
//  实现功能：收集所有的宏定义文本，并在执行语句中替换

#import <Foundation/Foundation.h>
#include "chainList.h"
#include "preCompileMacroSample.h"
#include <string.h>

#define STRLIMIT 200
#define DEFINE 0
#define UNDEF 1

FILE *fp;

int getVar(char *word, int lim);
int SApreProcess( const char *s );
int isWord( const char *s );

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        // 存放获得的字符
        struct SAnlist *np;
        char *word = malloc(sizeof(char) * STRLIMIT );
        int c;
        
        if (NULL == word)
        {
            printf("内存错误，程序退出");
            return -1;
        }

        fp = fopen("var.h", "r");
        
        if (NULL == fp )
        {
            printf("读写文件错误，程序退出");
            return -2;
        }
        
        while ( EOF != (c = getVar( word , STRLIMIT)) )
        {
            switch (c)
            {
                // 预定义，判断处理
                case '#':
                    SApreProcess( word );
                    printf( "%s ", word);
                    break;
                // 是其他字符，检查是否为宏定义，倘若是，用value 替换key
                default:
                    if (  NULL != ( np = lookup(word) ) )
                    {
                        printf("%s ", np->defn);
                    }
                    else
                    {
                        printf("%s ", word);
                    }
                    break;
            }
        }
        
        fclose(fp);
    }
    return 0;
}

// 模仿预处理程序，实现define和undef功能
int SApreProcess( const char *s )
{
    char *dp = strdup(s);
    char *tmp ;
    char *value;
    
    tmp = strtok(dp, " ");

    if (0  == strcmp(tmp, "#define"))
    {
        tmp = strtok( NULL, " ");
        value = strtok(NULL, " ");
        
        if ( isWord(tmp) && isWord(value))
        {
            install(tmp, value);
        }
    }
    else if( 0  == strcmp(tmp, "#undef") )
    {
        // 获取要取消macro的标识
        tmp = strtok(dp, NULL);
        undef(tmp);
    }
    
    return 0;
}

// 获取一条语句中的变量声明（如果有），需按照c语法规定实现
int getVar(char *word, int lim)
{
    int c;
    char *w = word;
    
    // 清空
    memset(w, '\0', lim);
    
    // 跳过空白符
    while (isspace( c = getc(fp) ));
    
    switch (c)
    {
        // 是预定义行，抽取整行
        case '#':
            do *w++ = c;
            while ( '\n' != (c = getc(fp)) && ( EOF != c ) );
            break;
            // 是注释 /**/ 或 //
        case '/':
            *w++ = c;
            
            // 取下一个字符
            c = getc(fp);
            
            // 是行注释，格式为// …………  不解析
            if ('/' == c )
            {
                do *w++ = c;
                while ( '\n' != (c = getc(fp)) &&  (EOF != c) );
            }
            // 是段注释 /*的格式 也不解析
            else if ('*' == c )
            {
                int preChar = 0;
                // 需找结尾的'*/'
                do
                {
                    preChar = c;
                    *w++ = c;
                }while ( !('/' == (c = getc(fp))  &&  ('*' == preChar) ) && ( EOF != c ) );
            }
            break;
            // 是字符 ‘’，不解析‘’内的所有字符
        case '\'':
            do *w++ = c;
            while ( ('\'' != ( c = getc(fp))) && (EOF != c)) ;
            break;
            // 是字符串 ""，不解析""内的所有字符
        case '\"':
            do *w++ = c;
            while ( '\"' != ( c = getc(fp) ) && EOF != c );
            break;
        default:
            *w++ = c;
            break;
    }
    
    // 倘若获取的字符不是标识符，直接返回，这个条件判断兼顾了EOF和一般字符的情况
    if (!isalnum(c)  && ('_' != c))
    {
        *w++ = '\0';
        return word[0];
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

// 判断是否为字符
int isWord( const char *s )
{
    if (NULL == s || 0 == strlen(s) )
    {
        return 0;
    }
    
    while ('\0' != *s )
    {
        if (isalnum(*s) || '_' == *s )
        {
            ++s;
        }
        else
        {
        return 0;
        }
    }

    return 1;
}
