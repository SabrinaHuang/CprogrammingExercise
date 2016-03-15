#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>


#define  PERMS 0666	/* ∏¯À˘”–µƒ”√ªßø…∂¡ø…–¥»®œﬁ */
FILE _iob[FOPEN_MAX];

FILE *SAfopen( char *name, char *mode );
int _fillbuf(FILE *fp);



int main(int argc,const char *argv[])
{
    FILE *fp;
    int ch;
    
    fp = SAfopen("var.h", "r");
    
    if( NULL == fp )
    {
        exit(-1);
    }
    
    while( EOF != (ch = getc( fp )))
    {
        putchar(ch);
    }
    return EXIT_SUCCESS;
}

// ≥ı ºªØ–¥µƒª∫≥Â«¯
int _fillbuf(FILE *fp)
{
    int bufsize;
    
    //  
    if( (fp->_flags & ( __SRD | EOF | __SERR )) != __SRD )
        return EOF;
    //  «∑Ò”–buf( readƒ£ Ω√ª”–buf,∆‰À˚”–buf )
    bufsize = ( fp->_flags & __SNBF )? 1:BUFSIZ;
    
    // 生成缓冲区
    if( NULL == fp->_bf._base )
        if( NULL == ( fp->_bf._base = ( unsigned char *)malloc(bufsize) ))
            return EOF;
    
    fp->_p = fp->_bf._base;
    
    fp->_lbfsize = fp->_read( fp->_file, fp->_p, bufsize );
    
    // ª∫≥Â«¯ø’¡À
    if( --fp->_r < 0 ){
        if( -1 == fp->_r )
            fp->_flags = EOF;
        else
            fp->_flags = __SERR;
        
        fp->_lbfsize = 0;
        return EOF;
    }
    
    return (unsigned char) *fp->_p++;
}

FILE *SAfopen( char *name, char *mode )
{
    int fd;
    FILE *fp;
    
    if( ('r' != *mode) &&  ( 'w' != *mode ) && ( 'a' != *mode ) )
        return NULL;
    
    for( fp = _iob; fp < _iob + FOPEN_MAX; ++fp )
    {
        // 找到空槽位
        if( 0 == (fp->_flags & ( __SRD | __SWR)) )
            break;
    }
    
    // √ª’“µΩø’≤€
    if( fp >= _iob + FOPEN_MAX )
    {
        puts("No alloc space for FILE.\n");
        return NULL;
    }
    
    // 以读模式打开，用create
    if( 'w' == *mode )
        fd = create(name, PERMS);
    else if( 'a' == *mode )
    {
        // 打开失败，创建
        if( 0 > ( fd = open( name, O_WRONLY, 0 )))
        {
            fd = creat(name, PERMS);
        }
        // 定位到文件末尾，实现a操作
        fp->_seek( fp,0L,2 );
    }
    // ∂¡ƒ£ Ω
    else
        fd = open( name, O_RDONLY );
    // ¥Úø™ ß∞‹£¨∑µªÿNULL÷∏’Î
    if( 0 > fd )
        return NULL;
    
    fp->_file = fd;
    fp->_lbfsize = 0;
    fp->_bf._base = NULL;
    fp->_flags = ( 'r' == *mode )? __SRD:__SWR ;
    
    return fp;
}
