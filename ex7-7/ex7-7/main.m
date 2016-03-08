//
//  main.m
//  ex7-7
//
//  Created by 昭蕾王 on 16/3/8.
//  Copyright © 2016年 personal. All rights reserved.
//

#import <Foundation/Foundation.h>

#define STRLIMIT 200

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        FILE *fp;
        static  size_t lineLimit = STRLIMIT;
        char *matchStr;
        char *line = malloc(STRLIMIT);
        size_t lineCnt = 0;
        char *compRet = NULL;
        char *arg;
        int fileIndex = 1;
        
        // 没有匹配字符串，退出
        if ( 1 == argc )
        {
            fprintf(stderr, "no param for search.\n" );
            exit(-1);
        }
        // 没有输入文件，从标准输入中读取
        else if (2 == argc)
        {
            matchStr = (char *)argv[1];
            long n  = 0;
            
            while ( 0 < (n = getline(&line, &lineLimit, stdin)) )
            {
                // 查找line里是否有匹配
                if ( NULL != (  compRet = strstr(line, matchStr) ))
                {
                    fprintf(stdout, "model found in the line below: \n%s", line );
                    exit(0);
                }
            }
            
            // 匹配失败
            fprintf(stdout, "No match model found in input.\n");
        }
        else
        {
            matchStr = (char *)argv[1];
            lineCnt = 0;
            
            while (--argc > 1)
            {
                // 获取文件名
                arg = (char *)argv[ ++fileIndex ];
                
                fp = fopen(arg, "r");
                if (NULL == fp)
                {
                    fprintf(stderr, "打开文件出错");
                    exit(-1);
                }
                
                while (NULL != fgets(line, STRLIMIT, fp))
                {
                    ++lineCnt;
                    // 查找line里是否有匹配
                    if ( NULL != ( compRet = strstr(line, matchStr) ))
                    {
                        fprintf(stdout, "model %s found in the %dth line of file %s\n", compRet, lineCnt, arg );
                        exit(0);
                    }
                }
                
                // 文件出错，直接退出
                if (ferror(fp))
                {
                    fprintf(stderr, "文件损坏，程序退出\n");
                    exit(-1);
                }
                
            }
            
            // 没找到匹配字符串，提示
            // 匹配失败
            fprintf(stdout, "No match model found in files.\n");
        }
    }
    return 0;
}

