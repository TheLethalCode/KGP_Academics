#include "myl.h"
#define mx 20

int prints(char *s)
{
    int bytes=0;
    while(s[bytes]!='\0')bytes++;
    __asm__ __volatile__ (
        "movl $1, %%eax \n\t"
        "movq $1, %%rdi \n\t"
        "syscall \n\t"
        :
        :"S"(s), "d"(bytes)
    );
    return bytes;
}


int printi(int n)
{
    char buff[mx],zero='0';
    int i=0,j=0,bytes,k;
    if(n<0){n=-n;buff[i++]='-';}
    if(n==0)buff[i++]=zero;
    while(n!=0){
        buff[i++]= (char)(n%10 + zero);
        n=n/10;
    }
    if(buff[0]=='-')j=1;
    k=i-1;
    bytes=i;
    while(j<k){
        char tmp;
        tmp=buff[j];
        buff[j]=buff[k];
        buff[k]=tmp;
        j++;k--;
    }
  __asm__ __volatile__ (
        "movl $1, %%eax \n\t"
        "movq $1, %%rdi \n\t"
        "syscall \n\t"
        :
        :"S"(buff), "d"(bytes)
    );
	return bytes;
}

int printd(float f)
{
    int f_int=(int)f;
    int cnt=0,cnt2=0;
    if(f < 0 && (int)f==0 )prints("-");
    int ret=printi(f);
    ret+=prints(".");
    f=f-f_int;   //fractional part
    //printf("\nCheck=%f\n",f);
    while((f-(int)f)!=0){f*=10;cnt++;}
    int tmp=f;
    while(tmp!=0){tmp=tmp/10;cnt2++;}
    tmp=cnt-cnt2;
    while(tmp!=0){ret+=prints("0");tmp--;}
    if(f<0)f*=-1;
    ret+=printi(f);
    return ret;
}

int readi (int* eP) {
    int i=0;
    char str[10];
    int sign=1,val=0;
    *eP=OK;
    while(1){
        __asm__ __volatile__ ("syscall"::"a"(0), "D"(0), "S"(str), "d"(1));
        if(str[0]==' ' || str[0] == '\t' || str[0]=='\n')break;
        if(!i && str[0]=='-')sign=-1;
        else{
            if(str[0] >'9' || str[0]<'0' )*eP=ERR;
            else{
                val=10*val+(int)(str[0]-'0');
            }
        }
        i++;
    }
    return val*sign;
}


int readf(float *fP)
{
    int i=0,IsFraction=0,status=OK,frac_cnt=0,first=1;
    char str[10]={" "};
    int sign=1,val=0;
    float fraction=0;
    int Dot=0;
    while(1){
        __asm__ __volatile__ ("syscall"::"a"(0), "D"(0), "S"(str), "d"(1));
        if(str[0]==' ' || str[0] == '\t' || str[0]=='\n')break;
        if(str[0]=='.'){IsFraction=1;Dot++;continue;}
        if(!i && str[0]=='-')sign=-1;
        else{
            if(str[0] >'9' || str[0]<'0' )status = ERR;
            else{
                if(!IsFraction && status==OK)val=10*val+(int)(str[0]-'0');
                else if(IsFraction && Dot==1  && status==OK && (!first || (first && str[0]!='0') )){fraction=10*fraction+(int)(str[0]-'0');frac_cnt++;}
                else if(IsFraction && Dot==1 && first && str[0]=='0' && status==OK)frac_cnt++;
                else status = ERR;
                first=0;
            }
        }
        i++;
    }
    while(frac_cnt--)fraction/=10.0;
    *fP=(val+fraction)*sign;
    return status;
}
