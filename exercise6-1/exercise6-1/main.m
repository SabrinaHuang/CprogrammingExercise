//
//  main.m
//  exercise6-1
//
//  Created by 昭蕾王 on 2/3/16.
//  Copyright © 2016 personal. All rights reserved.
//

//   这里的XXXX都不能算word
//   “XXXX”
//   #include XXXX
//   // XXX
//   /* XXXX */
//
//   这个XXXX应该连着_XXXX算成完整的单词
//   _XXXX

/*
    按优先级来 先判断
    if(")
    if(#)
    if(/)
 */

#import <Foundation/Foundation.h>
#include <curses.h>
#include <stdio.h>

#define LIMIT 200

int getword( int *word, int lim );

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        int *word = malloc(sizeof(int) * LIMIT );
        
        while( EOF != getword(word, LIMIT))
        {
            puts(word);
        }
    }
    return 0;
}

int getword( int *word, int lim )
{
    int c;

    int *w = word;
    
    // 跳过空白符
    while (isspace( c = getc(stdin) ));

    // 获取一个字符
    if (EOF != c)
        *w++ = c;
    
    // 是预编译条件，则读到\n，直接返回
    if ( '#' == c )
    {
        while ( '\n' != (c = getc(stdin)) );
        *(w -1) = '\0';
        return '\0';
    }
    
    // 是注释行
    if ('/' == c)
    {
        // 是行注释，格式为// …………  直接忽略
        if ('/' == (c = getc(stdin)) )
        {
            while ( '\n' != (c = getc(stdin)) &&  (EOF != c) );
            *(w -1) = '\0';
            return c;
        }
        
        // 是段注释 /*的格式 也忽略
        if ('*' == c )
        {
            // 需找结尾 */
            while ( EOF != (c = getc(stdin)) )
            {
                if ('*' == c )
                {
                    if ( '/' != ( c = getc(stdin)))
                    {
                        ungetc(c,stdin);
                        continue;
                    }
                    // 找到结尾
                    else
                    {
                        *(w -1) = '\0';
                        return c;
                    }
                }
            }

        }
    }
    
    // 是
    
    // 倘若获取的字符不是字母，直接返回，这个条件判断兼顾了EOF和一般字符的情况
    if (!isalpha(c))
    {
        *w = '\0';
        return c;
    }
    
    while (--lim > 0)
    {
        if (!isalnum(*w = getc(stdin)))
        {
            ungetc(*w,stdin);
            break;
        }
        
        ++w;
    }
    
    *w = '\0';
    
    return word[0];
}
