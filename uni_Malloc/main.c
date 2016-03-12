#include <stdio.h>
#include <stdlib.h>

// ÿ������ĵ�Ԫ�� 
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
	// û�п����� ��ָ��base�Ŀ�ͷ 
	if( NULL == ( prevp = freep ) )	{
		base.s.ptr = freep = prevp = &base;
		base.s.size = 0;
	} 
	
	// ���ҿ����� 
	for( p = prevp->s.ptr; ; prevp = p, p = p->s.ptr ){
		// �㹻�� 
		if( p->s.size >= nunits ){
			// ���ô� 
			if( nunits == p->s.size )
				prevp->s.ptr = p->s.ptr;
			// ���ڣ������������ĩβ	
			else{
				p->s.size -= nunits;
				p += p->s.size;
				p->s.size = nunits;
			}
			
			freep = prevp;
			return (void *)(p+1);	
		}
		
		// ָ������б� 
		if( freep == p )
		{
			if( NULL == (p = morecore(nunits)) )
				return NULL;
		}
		
	}
	
}

// ����ռ䣬���������ϵͳ��� 
static Header *morecore(unsigned nu)
{
	char *cp, *sbrk(int);
	Header *up;
	
	nu = ( nu < NALLOC )?NALLOC:nu;
	
	cp = sbrk( nu *sizeof(Header) );
	
	// ����ռ�ʧ�� 
	if( cp == (char *)-1 )
		return NULL;
	
	up = (Header *)cp;
	up->s.size = nu;
	free((void *)(up + 1));
	return freep;
}

// ��ap��������б����������б� 
void free(void *ap)
{
	Header *bp, *p;
	
	bp = (Header *)ap - 1;
	for( p = freep; !( bp > p && bp < p->s.ptr ); p = p->s.ptr )
		// �����б�Ŀ�ʼ��ĩβ 
		if( p >= p->s.ptr && ( bp > p || bp < p->s.ptr ) )
			break;
			
	// �ϲ����ϸ��� 
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
