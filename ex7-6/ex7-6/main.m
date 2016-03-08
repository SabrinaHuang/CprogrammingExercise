//
//  main.m
//  ex7-6
//
//  Created by Sabrina on 8/3/16.
//  Copyright © 2016 yunda. All rights reserved.
//

#import <Foundation/Foundation.h>

#define arraySize 200

int cmpareFile( FILE *fp1,FILE *fp2);

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        FILE *fp1, *fp2;
        fp1 = fopen("var.h", "r");
        fp2 = fopen("var2.h", "r");
        
        if (NULL != fp1 && NULL != fp2)
        {
            cmpareFile( fp1, fp2);
            fclose(fp1);
            fclose(fp2);
        }
        
    }
    return 0;
}


int cmpareFile( FILE *fp1,FILE *fp2)
{
    int lineSize = arraySize * sizeof(char);
    int ret = -1;
    
    if (NULL == fp1 || NULL == fp2)
    {
        fprintf(stderr, "打开文件失败。");
        return 0;
    }
    
    char *s1 = malloc(lineSize);
    char *s2 = malloc(lineSize);
    
    while( ( NULL !=  fgets(s1, lineSize, fp1)) &&  ( NULL != fgets(s2, lineSize, fp2) ) )
    {
        if( 0 != (ret = strcmp(s1, s2)))
            break;
    }
    
    if (ferror(fp1) || ferror(fp2))
    {
        fprintf(stderr, "文件出错。\n");
        return 0;
    }
    
    if (0 !=  ret)
    {
        printf("the first unequal lines are: \n%s \n%s\n", s1, s2);
    }
    else
    {
        printf("two files are definitly equal.\n");
    }
    
    return ret;
}