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
#define TRUE 1
#define FALSE 0

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
    int inChar = TRUE;
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
            if ( FALSE == inChar || textrun >= SPLIT )
            {
                putchar('\n');
                inChar = TRUE;
                textrun = 0;
                binaryrun = 0;
            }
            
            putchar(ch);
            ++textrun;
        }
        // 非图形字符，以内存表的形式打印
        else
        {
            if (YES == inChar || binaryrun >= SPLIT)
            {
                inChar = FALSE;
                textrun = 0;
                binaryrun = HEADWIDTH;
                printf("\nBinary Stream: ");
            }
        
            printf(format,ch);
            binaryrun += WIDTH;
        }
    }
    
    putchar('\n');
    return 0;
}
