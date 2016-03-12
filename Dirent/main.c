#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "syscalls."
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include "dirent.h"

#define NAME_MAX 14 // �ļ��������󳤶� 
#define MAX_PATH 1024 

void fsize(char *);

// ��ϵͳ�޹ص�Ŀ¼�� 
typedef struct
{
	long ino;
	char name[NAME_MAX + 1];	
} Dirent;

typedef struct
{
	int fd;
	Dirent d;
} DIR;

DIR *opendir( char *dirname );
Dirent *readdir(DIR *dfd);
void closedir(DIR *dfd);

char *name;
struct stat stbuf;
int stat( char *, struct stat * );
void dirwalk( char *, void (*fcn)(char *));

int main(int argc, char *argv[]) 
{
	// ��ӡ��ǰĿ¼ 
	if( 1 == argc )
		fsize(".");
	else
		while( --argc > 0 )
			fsize( *++argv );
			
	return 0;
}

void fsize(char *)
{
	struct stat stbuf;
	
	if( -1 == stat( name, &stbuf ) )
	{
		fprintf( stderr, "fsize:can't access %s\n", name);
		return;
	}
	// ������·�� 
	if( S_IFDIR == ( stbuf.st_mode & S_IFMT ) )
		dirwalk(name, fsize);	

	// ��ӡ��С���ļ��� 
	printf("%8ld %s\n", stbuf.st_size, name);	
} 

void dirwalk( char *dir, void (*fcn)(char *))
{
	char name[MAX_PATH];
	Dirent *dp;
	DIR *dfd;
	
	if( NULL == (dfd = opendir(dir)) )
	{
		fprintf(stderr, "dirwalk:can't open %s\n", dir);
		return;
	}
	
	// ��ȡָ����һ���ļ���ָ�� 
	while( NULL != ( dp = readdir(dfd) ) )
	{
		// ��·������͸�·�������� 
		if( 0 = (strcmp( dp->name, "." ) | strcmp( dp->name, ".." ) ))
			continue;
		// ·����̫��	dir + ��������� 
		if( strlen(dir) + strlen(dp->name) - 2 > sizeof( name ))	
			fprintf( stderr, "dirwalk:name %s/%s too long\n",dir, dp->name );
		// ��ӡ�����ݹ鴦����·��	
		else
		{
			sprint( name, "%s/%s",dir,dp->name );	
			(*fn)(name);
		}	
	}
	
	closedir(dfd);
}

DIR *opendir( char *dirname )
{
	int fd;
	struct stat, stbuf;
	DIR *dp;
	
	// ���ļ�������Ŭ����ʧ���� 
	if( 0 > fd = open(dirname, O_RDONLY, 0) \
		| 0 > fstat( fd, &stbuf )
		| S_IFDIR != ( stbuf.st_mode & S_IFMT )
		| (NULL == ( dp = (DIR *)malloc(sizeof(DIR)) ))
		  )
		 return NULL;
		 
	dp->fd = fd;
	return dp;	  
} 

void closedir(DIR *dp)
{
	if(dp)
	{
		close(dp->fd);
		free(dp);
	}
}

Dirent *readdir( DIR *dp )
{
	// ϵͳ��ص�dir�ṹ 
	struct directt dirbuf;
	static Dirent d;
	
	// ���ζ�ȡ��ǰĿ¼�µ�·�� 
	while( sizeof(dirbuf) ==  read( dp->fd,(char *) &dirbuf, sizeof(dirbuf) ) )
	{
		if( 0 >= dirbuf.d_ino )
			continue;
			
		d.ino = dirbuf.d_ino;
		strncpy( d.name, dirbuf.d_name, DIRSIZ );
		d.name[DIRSIZ] = '\0';
		return &d;
	}
	
	return NULL;
}
