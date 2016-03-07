//
//  main.m
//  ex7-2
//
//  Created by 昭蕾王 on 16/3/6.
//  Copyright © 2016年 personal. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <stdio.h>

#define OCTAL 8 
#define HEXADECIMAL 16
#define SPLIT 80
#define HEADWIDTH 15
#define WIDTH 4

void ProcessArgs(int argc, char *argv[], int *output);
int can_print(int ch);

void ProcessArgs(int argc, char *argv[], int *output)
{
    int i = 0; while(argc > 1)
    {
        *output = EOF;
        
        --argc;
        
        if( '-' == argv[argc][0] )
        {
            i = 1;
            
            while(argv[argc][i] != '\0')
            {
                if(argv[argc][i] == 'o')
                {
                    *output = OCTAL;
                }
                else if(argv[argc][i] == 'x')
                {
                    *output = HEXADECIMAL;
                }
                ++i;
            }
        }
    }
}

int can_print(int ch)
{
    char *printable = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!\"#% &'()*+,-./:;<=>?[\\]^_{|}~\t\f\v\r\n";
    char *s;
    int found = 0;
    
    for(s = printable; !found && *s; s++)
    {
        if(*s == ch)
        {
            found = 1;
        }
    }
    
    return found;
}

int main(int argc, char *argv[])
{
    int output = EOF;
    int ch;
    int textrun = 0;
    int binaryrun = 0;
    char *format = " " ;

    
    ProcessArgs(argc, argv, &output);
    
    if(output == HEXADECIMAL)
    {
        format = "%02X ";
    }
    else if( OCTAL == output )
    {
        format = "%3o ";
    }
   
    while((ch = getchar()) != EOF)
    {
        // 图形字符
        if(can_print(ch))
        {
            if(binaryrun > 0)
            {
                putchar('\n');
                binaryrun = 0;
                textrun = 0;
            }
            
            putchar(ch);
            ++textrun;
            
            if(ch == '\n')
            {
                textrun = 0;
            }
            
            if(textrun >= SPLIT)
            {
                putchar('\n');
                textrun = 0;
            }
        }
        // 非图形字符，以内存表的形式打印
        else
        {
            if (HEXADECIMAL == output || OCTAL == output)
            {
                if(textrun > 0 || binaryrun + WIDTH >= SPLIT)
                {
                    printf("\nBinary stream: ");
                    textrun = 0;
                    binaryrun = 15;
                }
                
                printf(format, ch);
                binaryrun += WIDTH;
            }
        }
    }
    
    putchar('\n');
    return 0;
}

/*
 if( isChar )
	{
 if( NO == inChar || textRun >= SPLIT )
 {
 putchar(‘\n’);
 inChar = true;
 textRun = 0;
 binaryRun = 0;
 }
 putchar(c)
 ++textRun
	}
	// 非字符
	else
	{
 if( !octal && !hexdecimal )
 continue;
 
 // 前一个是字符，或文本该折行了 新开一行，刷新参数
 if(YES == inChar || binaryRun >= SPLIT )
 {
 inChar = false;
 textRun = 0;
 binaryRun = HEADWIDTH;
 printf(“\nBinary Stream: ”);
 }
 
 printf( format,c );
 binaryRun += WIDTH;
	}
 */

