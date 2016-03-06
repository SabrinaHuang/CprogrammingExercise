//
//  main.m
//  ex7-1
//
//  Created by 昭蕾王 on 16/3/6.
//  Copyright © 2016年 personal. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <stdio.h>

// 一个放函数指针的数组
int (*convCase[2])( int c) = { tolower, toupper};

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        int func;
        int c;
        if (argc < 2 )
        {
            printf("没有转换参数");
            return -1;
        }
    
        if ( 'U' == toupper(argv[1][0]) )
        {
            func = 1;
        }
        else
        {
            func = 0;
        }
        
        while (EOF != (c = getchar()) )
        {
            c = convCase[func](c);
            putchar(c);
        }
        
    }
    return 0;
}
