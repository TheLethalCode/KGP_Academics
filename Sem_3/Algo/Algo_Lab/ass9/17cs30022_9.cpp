#include<bits/stdc++.h>
using namespace std;

int bin_find(int N,int T,int **dp)
{
	int fir=0,la=T-1,mid;
	while(fir<=la)
	{
		mid=(fir+la)/2;
		if(dp[N-1][mid] == dp[N][T-1-mid]) 
		{
			return dp[N-1][mid];
		}
		else if(dp[N-1][mid] < dp[N][T-1-mid])
		{
			fir=mid+1;
		} 
		else la=mid-1;
	}
	return min(max(dp[N-1][la],dp[N][T-1-la]),max(dp[N-1][fir],dp[N][T-1-fir]));
}

int findMinimumDaysFaster(int N, int T)
{
	int **dp;
	dp = (int **)malloc((N+1)*sizeof(int *));
	for(int i=0;i<=N;i++)
	{
		 dp[i]=(int *)malloc((T+1)*sizeof(int));
	}
	for(int i=0;i<=N;i++) 
	{
		dp[i][0]=0;
	}	
	for(int i=0;i<=T;i++) 
	{
		dp[1][i]=i;
	}
	for(int i=2;i<=N;i++)
	{
		for(int j=1;j<=T;j++)
		{
			dp[i][j]=1+bin_find(i,j,dp);
		}
	}
	int ans = dp[N][T];
	free(dp);
	return ans;
}


int findMinimumDays(int N, int T)
{
	int **dp;
	dp = (int **)malloc((N+1)*sizeof(int *));
	for(int i=0;i<=N;i++) dp[i]=(int *)malloc((T+1)*sizeof(int));
	for(int i=0;i<=N;i++) dp[i][0]=0;
	for(int i=0;i<=T;i++) dp[1][i]=i;
	for(int i=2;i<=N;i++)
	{
		for(int j=1;j<=T;j++)
		{
			int ans=1e9;
			for(int x=1;x<=j;x++)
			{
				ans=min(ans,max(dp[i-1][x-1],dp[i][j-x]));
			}
			dp[i][j]=1+ans;
		}
	}
	int ans = dp[N][T];
	free(dp);
	return ans;
}

int main()
{
	int N,T;
	cout<<"Enter N:- ";
	cin>>N;
	cout<<"Enter T:- ";
	cin>>T;
	printf("g(%d,%d) = %d\n",N,T,findMinimumDays(N,T));
	cout<<"Enter N:- ";
	cin>>N;
	cout<<"Enter T:- ";
	cin>>T;
	printf("g(%d,%d) = %d\n",N,T,findMinimumDaysFaster(N,T));
	return 0;
}
