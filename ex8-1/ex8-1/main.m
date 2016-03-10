//
//  main.m
//  ex8-1
//
//  Created by Sabrina on 10/3/16.
//  Copyright © 2016 yunda. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <assert.h>

int catUnix( char *f1 );
int catStdio( char *f1 );

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        clock_t start,finish;
        double duration1,duration2;
        
        // 没有参数
        if (argc < 2)
        {
            fprintf(stderr, "no cat file name\n");
            exit(-1);
        }
        
        // 计算时间
        fprintf(stdout, "\n====================unix output begin====================");

        start = clock();
        catUnix( (char *)argv[1]);
        finish = clock();
        
        duration1 = finish - start;
        
        fprintf(stdout, "\n====================stdio output begin====================");
        
        start = clock();
        catStdio( (char *)argv[1]);
        finish = clock();
        
        duration2 = finish - start;
        
        fprintf(stdout, "\nunix IO costs %s time than stdio.\n", (duration1 > duration2)?"more":"less");
    }
    return 0;
}

// 调用unix系统方法实现的cat功能
int catUnix( char *f1 )
{
    int fp, n;
    char BUF[BUFSIZ];
    char *bufp;
    
    if( 0 > (fp = open(f1, O_RDONLY, 0 ) ))
    {
        fprintf(stderr, "Fail to open file %s", f1);
        exit(-1);
    }
    
    // 读取成功
    while (0 < (n = (int)read(fp, BUF, BUFSIZ)) )
    {
        bufp = BUF;
        while ( n-- > 0)
        {
            putc(*bufp++, stdout);
        }
    }

    close(fp);
    
    return 0;
}

// 调用标准库方法实现cat
int catStdio( char *f1 )
{
    FILE *fp;

    int ch;
    fp = fopen(f1, "r");
    
    assert(fp);
    
    // 每次从fp里获取一个字符
    while ( EOF != (ch = fgetc(fp)))
    {
        fputc(ch, stdout);
    }
    
    fclose(fp);
    
    return 0;
}