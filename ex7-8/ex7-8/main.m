//
//  main.m
//  ex7-8
//
//  Created by 昭蕾王 on 16/3/8.
//  Copyright © 2016年 personal. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <assert.h>
#include <stdio.h>

#define LINES_PER_PAGE 5
#define TRUE 1
#define FALSE 0

int printFile( const char *file_Name );

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        int index = 1;
        
        // 没有文件
        if (argc < 2)
        {
            fprintf(stdout, "lack file name for print\n");
            exit(-1);
        }
        else
        {
            while (--argc > 0)
            {
                printFile(argv[index++]);
            }
        }
        
    }
    return 0;
}

int printFile( const char *file_Name )
{
    assert(file_Name);

    FILE *fp = NULL;
    int lineCnt = 0;
    int pageCnt = 1;
    int c = 0;
    
    // 标识新起了一页
    int newPage = TRUE;

    fp = fopen(file_Name, "r");
    assert(fp);
    
    while ( EOF != ( c = fgetc(fp) ) )
    {
        // 是新页，打印起始标识
        if ( TRUE == newPage)
        {
            fprintf(stdout, "\n======================[%s] page %d starts======================\n", file_Name, pageCnt);
            newPage = FALSE;
        }
        
        putc(c, stdout);
        
        // 一页结束，打印页脚
        if ('\n' == c )
        {
            if (++lineCnt >= LINES_PER_PAGE)
            {
                fprintf(stdout, "=======================[%s] page %d ends=======================\n",file_Name, pageCnt);
                fputc('\n', stdout);
                newPage = TRUE;
                ++pageCnt;
                lineCnt = 0;
            }
        }
        
    }
    
    // 多打印一行空白
    fputc('\n', stdout);    
    
    fclose(fp);
    
    if (feof(fp))
    {
        fprintf(stderr, "文件读写发生错误。\n");
    }
    
    return 0;
}