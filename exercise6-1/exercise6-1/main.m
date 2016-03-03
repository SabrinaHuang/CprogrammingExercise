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

int putIntArray( int array[] );
int getword( int *word, int lim );

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        int *word = malloc(sizeof(int) * LIMIT );
        
        while( EOF != getword(word, LIMIT))
        {
            putIntArray(word);
        }
    }
    return 0;
}

int getword( int *word, int lim )
{
    int c;
    int *w = word;
    int next;
    
    // 清空
    memset(word, '\0', lim);
    
    // 跳过空白符
    while (isspace( c = getc(stdin) ));

    // 获取一个字符
    if (EOF != c)
        *w++ = c;
    
    switch (c)
    {
        case '#':
            while ( '\n' != (c = getc(stdin)) );
            word[0] = '\0';
            break;
        
        case '\"':
            while ( '\"' != ( c = getc(stdin) ) && EOF != c );
            if ('\"' == c )
            {
                word[0] = '\0';
            }
            break;
            
        case '/':
            // 取下一个字符
            c = getc(stdin);
            
            // 是行注释，格式为// …………  直接忽略
            if ('/' == c )
            {
                while ( '\n' != (c = getc(stdin)) &&  (EOF != c) );
                word[0] = '\0';
            }
            
            // 是段注释 /*的格式 也忽略
            if ('*' == c )
            {
                int preChar = 0;
                // 需找结尾的'*/'
                do
                {
                    preChar = c;
                    
                }while ( !('/' == (c = getc(stdin))  &&  ('*' == preChar) ) && ( EOF != c ) );
                
                word[0] = '\0';
            }
            break;
         case '\'':
            while ( ('\'' != ( c = getc(stdin))) && (EOF != c));
            word[0] = '\0';
            break;
         // 下划线，倘若下一个是字母，认定是合法
         case '_':
            next = getc(stdin);
            if (isalpha(next))
            {
                *w++ = next;
                c = next;
            }
            else
            {
                ungetc(next, stdin);
            }
            break;
        default:
            break;
    }
    
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

// 打印int数组
int putIntArray( int array[] )
{
    int i ;
    
    for (int i = 0; '\0' != array[i]; ++i)
    {
        putchar(array[i]);
    }

    putchar('\n');
    
    return i;
}
