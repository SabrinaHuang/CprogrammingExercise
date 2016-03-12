#include <stdio.h>
#include <stdlib.h>

// 每次申请的单元数 
#define NALLOC 1024

typedef long Align;

typedef union header{
	struct{
		union header *ptr;
		unsigned size;
	}s;
	
	Align x;
}Header;

static Header base;
static Header *freep = NULL;
static Header *morecore(unsigned nu);

int main(int argc, char *argv[]) 
{
	return 0;
}

void *SAmalloc(unsigned nbytes)
{
	Header *p, *prevp;
	Header *morecore(unsigned);
	unsigned nunits;
	
	nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
	// 没有空闲区 ，指向base的开头 
	if( NULL == ( prevp = freep ) )	{
		base.s.ptr = freep = prevp = &base;
		base.s.size = 0;
	} 
	
	// 查找空闲区 
	for( p = prevp->s.ptr; ; prevp = p, p = p->s.ptr ){
		// 足够大 
		if( p->s.size >= nunits ){
			// 正好大 
			if( nunits == p->s.size )
				prevp->s.ptr = p->s.ptr;
			// 大于，分配空闲区的末尾	
			else{
				p->s.size -= nunits;
				p += p->s.size;
				p->s.size = nunits;
			}
			
			freep = prevp;
			return (void *)(p+1);	
		}
		
		// 指向空闲列表 
		if( freep == p )
		{
			if( NULL == (p = morecore(nunits)) )
				return NULL;
		}
		
	}
	
}

// 申请空间，这个方法和系统相关 
static Header *morecore(unsigned nu)
{
	char *cp, *sbrk(int);
	Header *up;
	
	nu = ( nu < NALLOC )?NALLOC:nu;
	
	cp = sbrk( nu *sizeof(Header) );
	
	// 分配空间失败 
	if( cp == (char *)-1 )
		return NULL;
	
	up = (Header *)cp;
	up->s.size = nu;
	free((void *)(up + 1));
	return freep;
}

// 将ap放入空闲列表，遍历空闲列表 
void free(void *ap)
{
	Header *bp, *p;
	
	bp = (Header *)ap - 1;
	for( p = freep; !( bp > p && bp < p->s.ptr ); p = p->s.ptr )
		// 块在列表的开始或末尾 
		if( p >= p->s.ptr && ( bp > p || bp < p->s.ptr ) )
			break;
			
	// 合并到上个块 
	if( bp + bp->s.size == p->s.ptr ){
		bp->s.size += p->s.ptr->s.size;
		bp->s.ptr = p->s.ptr->s.ptr;
	}else
		bp->s.ptr = p->s.ptr;
		
	if( p +p->s.size == bp ){
		p->s.size += bp->s.size;
		p->s.ptr = bp->s.ptr;
	}else
		p->s.ptr = bp;
	
	freep = p;	
}
