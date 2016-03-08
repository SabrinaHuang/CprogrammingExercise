//
//  main.m
//  ex7-5
//
//  Created by Sabrina on 8/3/16.
//  Copyright © 2016 yunda. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "stack.h"

#define STRLIMIT 200

int antiPoly(char *s);

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        char *line = malloc(STRLIMIT);
        size_t maxLen = STRLIMIT * sizeof(char);
        float result ;
        
        while (getline(&line, &maxLen, stdin))
        {
            char *tmp = strdup(line);
            char *s = tmp;
            
            // 将行的末尾改成'\0'
            while ( '\n' != *s  && s < tmp + STRLIMIT )
            {
                ++s;
            }
            
            if ('\n' == *s)
            {
                *s = '\0';
            }
            
            s = strtok(tmp, " ");
            
            do
            {
                antiPoly(s);
            }while ((s = strtok(NULL, " ")));
            
            // 打印一行的计算结果
            result = pop();
            printf("result is %.2f", result);
        }
        
    }
    return 0;
}

int antiPoly(char *s)
{
    double var;
    double num;
    
    if (NULL == s)
    {
        return -1;
    }
    
    // word长度大于一，做运算数来解析，解析完直接返回
    if (strlen(s)  > 1)
    {
        if ( (var = atof(s)))
        {
            push(var);
        }
        
        return 1;
    }

    switch (s[0])
    {
        case '+':
            push(pop() + pop());
            break;
        case '-':
            num = pop();
            push(pop() - num);
            break;
        case '*':
            push(pop() * pop());
            break;
        case '/':
            num = pop();
            // 被除数非零
            if (fabs(num) > 0.00001f )
            {
                push(pop() / num );
            }
            break;
            
        default:
            if (isnumber(s[0]))
            {
                push(atof(s));
            }
            break;
    }
    
    
    return 0;
}