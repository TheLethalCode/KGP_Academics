#include<bits/stdc++.h>
using namespace std;

typedef struct
{
	int subpartID;
	int cost_per_day;
	int duration;
}subpart_data;

typedef struct
{
    int predecessorID;
    int successorID;
}dependency_info;

void merge(subpart_data *T,int a, int b, int c)
{
	subpart_data l[b-a+1],r[c-b];
	for(int i=0;i<b-a+1;i++) l[i]=T[a+i];
	for(int i=0;i<c-b;i++) r[i]=T[b+1+i];
	int k=a,x=0,y=0;
	while(x<b-a+1 && y<c-b)
	{
		if(l[x].cost_per_day*1.0/l[x].duration < r[y].cost_per_day/r[y].duration) T[k++]=l[x++];
		else T[k++]=r[y++];
	}
	while(x<b-a+1) T[k++]=l[x++];
	while(y<c-b) T[k++]=r[y++];	
}

void sort(subpart_data *T,int a,int b)
{
	if(a>=b) return;
	int mid=(a+b)/2;
	sort(T,a,mid);
	sort(T,mid+1,b);
	merge(T,a,mid,b);
}

void print_schedule1(subpart_data *A, int K, dependency_info *B, int l)
{
    int n=K;
    int dep[n+1]={0},check[n+1]={0};
    int cnt=0;
    for(int i=0;i<l;i++)
    {
        dep[B[i].successorID]=B[i].predecessorID;
    }
    sort(A,0,n-1);
    int day=0;
    int cost=0;
    while(cnt<n)
    {
        for(int i=0;i<n;i++)
        {
            if(check[A[i].subpartID]) continue;
            if(dep[A[i].subpartID])
            {
                if(check[dep[A[i].subpartID]])
                {
                    day+=A[i].duration;
                    cost+=day*A[i].cost_per_day;
                    check[A[i].subpartID]=1;
                    cnt++;
                }
            }
            else
            {
                day+=A[i].duration;
                cost+=day*A[i].cost_per_day;
                check[A[i].subpartID]=1;
                cnt++;
            }
        }
    }
    cout<<"cost = "<<cost<<endl;
    
}

void print_schedule(subpart_data *A, int K)
{
	int n=K;
	sort(A,0,n-1);
	int day=0;
	int cost=0;
	for(int i=0;i<n;i++)
	{
	    day+=A[i].duration;
	    cost+= day*A[i].cost_per_day;
		//cout<<A[i].cost_per_day<<" ";
	}
	cout<<"cost = "<<cost<<endl;
}

int main()
{
	int n;
	cin>>n;
	subpart_data A[n];
	for(int i=0;i<n;i++)
	{
		cin>>A[i].duration;
		A[i].subpartID = i+1;
	}
	for(int i=0;i<n;i++)
	{
		cin>>A[i].cost_per_day;
	}
	print_schedule(A,n);
	
	int l;
	cin>>l;
	dependency_info B[l];
	for(int i=0;i<l;i++)
	{
	    cin>>B[i].predecessorID;
	    cin>>B[i].successorID;
	}
	print_schedule1(A,n,B,l);
	return 0;
}
