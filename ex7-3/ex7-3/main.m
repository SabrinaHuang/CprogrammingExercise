//
//  main.m
//  ex7-3
//
//  Created by Sabrina on 7/3/16.
//  Copyright © 2016 yunda. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <stdarg.h>

int minprintf( char *fmn, ... );

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        minprintf("%s %d", "adoegg", 3);
    }
    return 0;
}


int minprintf( char *fmn, ... )
{
    va_list ap; // 用于指向变量的指针
    
    // 以val结尾的变量均用于存放变元
    char *p, *sval;
    int ival;
    double dval;
    
    // 获取变元
    va_start(ap, fmn);
    for (p = fmn; *p; ++p) // 指向第一个无名变量
    {
        // 读到 %时，开始解析
        if ('%' != *p )
        {
            putchar(*p);
            continue;
        }
        
        // 根据格式控制字符决定变元的类型，用va_arg方法
        switch (*++p)
        {
            case 'd':
                ival = va_arg(ap, int);
                printf("%d",ival);
                break;
            case 'f':
                dval = va_arg(ap, double);
                printf("%f",dval);
                break;
            // va_arg用于取*p里的每一个字符
            case 's':
                for (sval = va_arg(ap, char *); *sval; ++sval)
                    putchar(*sval);
                break;
            default:
                putchar(*p);
                break;
        }
    }
    va_end(ap);
    
    
    return 0;
}