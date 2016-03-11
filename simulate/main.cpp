#include <stdlib.h>
#include <unistd.h>
#define BUFSIZ 1024
#define EOF   (-1)
#define OPEN_MAX 20

typedef struct __iobuf{
	int cnt;	// 余下的未读取的字符数
	char *ptr;	// 当前读到的位置
	char *base;	// 文件的开始
	int flag;	// 记录访问文件的状态
	int fd;		// 文件的标识符
	
}SAFILE;

enum _flags{
	_READ = 01,
	_WRITE = 02,
	_UNBUF = 04,
	_EOF = 010,
	_ERR = 020,	
};

int _fillbuf(SAFILE *);
int _flushbuf(int, SAFILE *);

SAFILE sa_iob[OPEN_MAX] = 
{
	{0, (char *)0,(char *)0, _READ, 0 },
	{0, (char *)0,(char *)0, _WRITE, 1 },
	{0, (char *)0,(char *)0, _WRITE | _UNBUF , 2 }	
};

#define stdin (&sa_iob[0])
#define stdout (&sa_iob[1])
#define stderr (&sa_iob[2])

#undef feof
#undef ferror
#undef fileno

#define feof(p) ( 0 != ( (p)->flag && _EOF ) )
#define ferror(p) ( 0 != ((p)->flag && _EOF) )
#define fileno ((p)->fd)

// 如果p的空间为0，则为p开辟存储空间
#define getc(p) ( --(p)->cnt >=0 \
				? (unsigned char) *(p)->ptr++: _fillbuf(p)  )
				
// 如果p的空间为0，则为p开辟存储空间				
#define putc(x,p) (--(p)->cnt >= 0 \
					? *(p)->ptr++ = (x):_flushbuf( (x),p )  )
					
#define getchar()  getc(stdin)					
#define putchar(x) putc( (x), stdout  )

#define  PERMS 0666	/* 给所有的用户可读可写权限 */

SAFILE *SAfopen( char *name, char *mode );
int _fillbuf(SAFILE *fp);

int main(int argc, char *argv[])
{
	SAFILE *fp;
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

// 初始化写的缓冲区
int _fillbuf(SAFILE *fp)
{
	int bufsize;
	
	// 是读模式,且无错误
	if( _READ  != (fp->flag | _READ | _ERR | _EOF) )
		return _EOF;
	// 是否有buf( read模式没有buf,其他有buf )
	bufsize = ( fp->flag & _UNBUF )? 1:BUFSIZ;
	
	// 还没有缓冲区，分配
	if( NULL == fp->base )
		if( NULL == ( fp->base = (char *)malloc(bufsize) ))
			return EOF;
	
	fp->ptr = fp->base;
	fp->cnt = read( fp->fd, fp->ptr, bufsize );
	
	// 缓冲区空了
	if( --fp->cnt < 0 ){
		if( -1 == fp->cnt )
			fp->flag = _EOF;
		else
			fp->flag = _ERR;
		fp->cnt = 0;
		return EOF;
	}
	
	return (unsigned char) *fp->ptr++;
}

SAFILE *SAfopen( char *name, char *mode )
{
	int fd;
	SAFILE *fp;

	if( ('r' != *mode) &&  ( 'w' != *mode ) && ( 'a' != *mode ) )	
		return NULL;
	
	for( fp = sa_iob; fp < sa_iob + OPEN_MAX; ++fp )
	{	
		// 找到空槽
		if( 0 == (fp->flag & ( _READ | _WRITE)) )
			break;
	}
	
	// 没找到空槽
	if( fp >= sa_iob + OPEN_MAX )
	{
		puts("No alloc space for FILE.\n");
		return NULL;
	}
	
	// 根据不同的模式选择不同的打开方式
	// 写文件，用create模式
	if( 'w' == *mode )
		fd = create(name, PERMS);
	else if( 'a' == *mode )
	{
		// 打开失败
		if( 0 > ( fd = open( name, O_WRONLY, 0 )))	
		{
			fd = creat(name, PERMS);
		}
		// 将指针移到数组末尾
		lseek(fd,0L,2);
	}
	// 读模式
	else
		fd = open( name, O_RDONLY );
	// 打开失败，返回NULL指针
	if( 0 > fd )
		return NULL;
	
	fp->fd = fd;
	fp->cnt = 0;
	fp->base = NULL;
	fp->flag = ( 'r' == *mode )? _READ:_WRITE ;
	
	return fp;
}
