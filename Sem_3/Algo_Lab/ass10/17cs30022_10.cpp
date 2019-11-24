#include<bits/stdc++.h>
using namespace std;

typedef struct _rwd 
{
	int start_time;
	int service_time;
} reqWD;

typedef struct _rsd 
{
	int service_time;	
	int target_time;
} reqSD;

typedef struct _rw 
{
	int id;
	reqWD req;
} reqW;

typedef struct _rs 
{
	int id;
	reqSD req;
} reqS;

void merge1(reqS *T,int a, int b, int c)
{
	reqS l[b-a+1],r[c-b];
	for(int i=0;i<b-a+1;i++) l[i]=T[a+i];
	for(int i=0;i<c-b;i++) r[i]=T[b+1+i];
	int k=a,x=0,y=0;
	while(x<b-a+1 && y<c-b)
	{
		if(l[x].req.target_time < r[y].req.target_time) T[k++]=l[x++];
		else T[k++]=r[y++];
	}
	while(x<b-a+1) T[k++]=l[x++];
	while(y<c-b) T[k++]=r[y++];	
}

void sort1(reqS *T,int a,int b)
{
	if(a>=b) return;
	int mid=(a+b)/2;
	sort1(T,a,mid);
	sort1(T,mid+1,b);
	merge1(T,a,mid,b);
}

void merge(reqW *T,int a, int b, int c)
{
	reqW l[b-a+1],r[c-b];
	for(int i=0;i<b-a+1;i++) l[i]=T[a+i];
	for(int i=0;i<c-b;i++) r[i]=T[b+1+i];
	int k=a,x=0,y=0;
	while(x<b-a+1 && y<c-b)
	{
		if(l[x].req.start_time < r[y].req.start_time) T[k++]=l[x++];
		else T[k++]=r[y++];
	}
	while(x<b-a+1) T[k++]=l[x++];
	while(y<c-b) T[k++]=r[y++];	
}

void sort(reqW *T,int a,int b)
{
	if(a>=b) return;
	int mid=(a+b)/2;
	sort(T,a,mid);
	sort(T,mid+1,b);
	merge(T,a,mid,b);
}

void schedule1(reqW *A,int n)
{
	sort(A,0,n-1);
	//for(int i=0;i<n;i++) cout<<A[i].id<<" ";
	int check[n]={0};
	int c_id=0;
	int po = 0;
	while(po<n)
	{
		int cnt=po;
		int prev_cnt=-1;
		printf("Counter %d\n",c_id);
		while(cnt<n)
		{
			if(prev_cnt==-1) 
			{
				printf("%d %d %d\n",A[cnt].id,A[cnt].req.start_time,A[cnt].req.service_time+A[cnt].req.start_time);
				check[cnt]=1;
				prev_cnt=cnt;
			}
			else if((A[prev_cnt].req.start_time + A[prev_cnt].req.service_time <= A[cnt].req.start_time) && !check[cnt])
			{
				printf("%d %d %d\n",A[cnt].id,A[cnt].req.start_time,A[cnt].req.service_time+A[cnt].req.start_time);
				check[cnt]=1;
				prev_cnt=cnt;
			}
			cnt++;
		}
		c_id++;
		int i=0;
		while(i<n)
		{
			if(check[i]==0)break;
			i++;
		}
		po=i;
	}
}

void schedule2(reqS *A,int n)
{
	sort1(A,0,n-1);
	int prev_fin=0;
	for(int i=0;i<n;i++)
	{
		printf("%d %d %d\n",A[i].id,prev_fin,A[i].req.service_time+prev_fin);
		prev_fin=A[i].req.service_time+prev_fin;
	}
}

int main()
{
	int n;
	reqW *A;
	cout<<"Enter the number of requests over weekday: ";
	cin>>n;
	A = (reqW *)malloc(n*sizeof(reqW));
	cout<<"Enter the start time and length for each of the requests:-\n";
	for(int i=0;i<n;i++)
	{
		cout<<"request "<<i<<" :-";
		cin>>A[i].req.start_time;
		cin>>A[i].req.service_time;
		A[i].id=i;
	}
	cout<<endl;
	schedule1(A,n);

	int m;
	reqS *B;
	cout<<"Enter the number of requests over Saturday: ";
	cin>>m;
	B = (reqS *)malloc(m*sizeof(reqS));
	cout<<"Enter the length and deadline for each of the requests:-\n";
	for(int i=0;i<m;i++)
	{
		cout<<"request "<<i<<" :-";
		cin>>B[i].req.service_time;
		cin>>B[i].req.target_time;
		B[i].id=i;
	}
	cout<<endl;
	schedule2(B,m);
	return 0;
}
