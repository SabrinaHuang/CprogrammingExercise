//
//  main.m
//  ex7-4
//
//  Created by Sabrina on 8/3/16.
//  Copyright © 2016 yunda. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TRUE 1
#define FALSE 0
#define STRLIMIT 200

int minscanf( char *fmt, ... );
int can_print(int ch);

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        int day,month,year;
        char *monthStr = malloc(STRLIMIT);
        float f;
        char ch;
        
        if (0 <  minscanf("%d %k",&day, &ch) )
        {
            printf("match success\n");
        }
        else
        {
            printf("fail to get random word\n");
        }
    }
    return 0;
}

int minscanf( char *fmt, ... )
{
    va_list ap;
    char *p = fmt ;
    char *line = malloc(STRLIMIT);
    size_t strSize = STRLIMIT * sizeof(char);
    
    char *sVal;
    float *fVal;
    int *iVal;
    char *cVal;
    int ret = 1;
    
    va_start(ap, fmt);
    
    while (getline(&line, &strSize, stdin) && ret > 0 && *p)
    {
        char *tmp = line;
        
        // 解析打印参数
        for( ;*p && ret > 0  && *tmp; ++p )
        {
            // 并非可打印字符，忽略
            if (FALSE == can_print(*p) )
            {
                continue;
            }
            
            // 准备扫描，跳过不可读取的字符
            while ( FALSE == can_print(*tmp) && *tmp ) ++tmp;
            
            // 跳完后，行结束，跳到外循环，读取下一行
            if (!*tmp) break;
            
            // 读取一个普通字面值
            if ('%' != *p )
            {
                // 匹配成功
                if( (ret =  (*tmp == *p)?1:0 ))
                {
                     tmp++;
                }
                // 匹配失败，返回
                else
                {
                    printf("input doesn't match param.\n");
                    return -1;
                }
                continue;
            }
            
            // 此处比较的line都有内容，倘若scanf失败，说明不是行结束，而是内容匹配失败
            switch (*++p)
            {
                case 's':
                    sVal = va_arg(ap, char *);
                    // 读取%s成功,移动指针
                    if ((ret = sscanf(tmp, "%s", sVal)))
                    {
                        while (can_print(*tmp)) ++tmp;
                    }
                    break;
                    
                case 'f':
                    fVal = va_arg(ap, float *);
                    if((ret = sscanf( tmp, "%f", fVal)))
                    {
                        while (isnumber(*tmp))++tmp;
                        if ('.' == *tmp )
                        {
                            ++tmp;
                            while (isnumber(*tmp))++tmp;
                        }
                    }
                    break;
                    
                case 'd':
                    iVal = va_arg(ap, int *);
                    if((ret = sscanf(tmp,"%d", iVal)))
                    {
                        while (isnumber(*tmp)) ++tmp;
                    }
                    break;
                    
                case 'c':
                    cVal = va_arg(ap, char *);
                    if( (ret = sscanf(tmp,"%c", cVal))) ++tmp;
                    break;
                    
                default:
                    // 匹配成功，移动line的指针
                    if( (ret =  (*tmp == *p)?1:0 )) ++tmp;
                    break;
            }
        }
        
    }

    va_end(ap);

    return ret;
}

int can_print(int ch)
{
    char *printable = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!\"#%&'()*+,-./:;<=>?[\\]^_{|}~";
    char *s;
    int found = FALSE;
    
    for(s = printable; !found && *s; s++)
    {
        if(*s == ch)
        {
            found = TRUE;
        }
    }
    
    return found;
}