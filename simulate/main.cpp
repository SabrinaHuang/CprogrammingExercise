#include <stdlib.h>
#include <unistd.h>
#define BUFSIZ 1024
#define EOF   (-1)
#define OPEN_MAX 20

typedef struct __iobuf{
	int cnt;	// ���µ�δ��ȡ���ַ���
	char *ptr;	// ��ǰ������λ��
	char *base;	// �ļ��Ŀ�ʼ
	int flag;	// ��¼�����ļ���״̬
	int fd;		// �ļ��ı�ʶ��
	
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

// ���p�Ŀռ�Ϊ0����Ϊp���ٴ洢�ռ�
#define getc(p) ( --(p)->cnt >=0 \
				? (unsigned char) *(p)->ptr++: _fillbuf(p)  )
				
// ���p�Ŀռ�Ϊ0����Ϊp���ٴ洢�ռ�				
#define putc(x,p) (--(p)->cnt >= 0 \
					? *(p)->ptr++ = (x):_flushbuf( (x),p )  )
					
#define getchar()  getc(stdin)					
#define putchar(x) putc( (x), stdout  )

#define  PERMS 0666	/* �����е��û��ɶ���дȨ�� */

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

// ��ʼ��д�Ļ�����
int _fillbuf(SAFILE *fp)
{
	int bufsize;
	
	// �Ƕ�ģʽ,���޴���
	if( _READ  != (fp->flag | _READ | _ERR | _EOF) )
		return _EOF;
	// �Ƿ���buf( readģʽû��buf,������buf )
	bufsize = ( fp->flag & _UNBUF )? 1:BUFSIZ;
	
	// ��û�л�����������
	if( NULL == fp->base )
		if( NULL == ( fp->base = (char *)malloc(bufsize) ))
			return EOF;
	
	fp->ptr = fp->base;
	fp->cnt = read( fp->fd, fp->ptr, bufsize );
	
	// ����������
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
		// �ҵ��ղ�
		if( 0 == (fp->flag & ( _READ | _WRITE)) )
			break;
	}
	
	// û�ҵ��ղ�
	if( fp >= sa_iob + OPEN_MAX )
	{
		puts("No alloc space for FILE.\n");
		return NULL;
	}
	
	// ���ݲ�ͬ��ģʽѡ��ͬ�Ĵ򿪷�ʽ
	// д�ļ�����createģʽ
	if( 'w' == *mode )
		fd = create(name, PERMS);
	else if( 'a' == *mode )
	{
		// ��ʧ��
		if( 0 > ( fd = open( name, O_WRONLY, 0 )))	
		{
			fd = creat(name, PERMS);
		}
		// ��ָ���Ƶ�����ĩβ
		lseek(fd,0L,2);
	}
	// ��ģʽ
	else
		fd = open( name, O_RDONLY );
	// ��ʧ�ܣ�����NULLָ��
	if( 0 > fd )
		return NULL;
	
	fp->fd = fd;
	fp->cnt = 0;
	fp->base = NULL;
	fp->flag = ( 'r' == *mode )? _READ:_WRITE ;
	
	return fp;
}
