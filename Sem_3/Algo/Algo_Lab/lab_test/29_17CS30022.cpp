// NAME: Kousshik Raj
// ROLL NO: 17CS30022
// PC NO: 29

#include<bits/stdc++.h>
using namespace std;

/* 
		SUBPROBLEM
		==========
		
		Let DP(i,j) represent the probability of success for the first i components when j people are assigned to it.
		
		=> When the number of people assigned is less than the number of components
		   the probability of success is 0
		
		=> If the number of components is 0, the success rate is anyway 1
		
		=> So, DP(i,j) will be the maximum of the success rates,
		   when x people are assined to the ith job, where x varies from 0 to j.
		   So, j-x people will be assigned to the i-1 jobs.
		 
		This gives us the recursive formulation for the problem.

		RECURSIVE DEFINITION
		====================
		
		DP[i][j] = 1 if(i==0)
		DP[i][j] = 0 if(j<i)
		DP[i][j] = {0<=k<=j max{DP[i-1][j-k]*prob[i][k]}} else
*/

int main()
{
	// Input of N and P
	int N,P;
	cout<<"Enter N:";
	cin>>N;
	cout<<"Enter P:";
	cin>>P;
	
	double prob[N+1][P+1];
	cout<<"Enter the probabilities\n";
	
	// 0 people assigned to a component makes the probability 0
	for(int i=1;i<=N;i++)
		prob[i][0]=0;
	
	//Probability input
	for(int i=1;i<=N;i++)
		for(int j=1;j<=P;j++)
			cin>>prob[i][j];
	
	double DP[N+1][P+1];
	int people[N+1][P+1];
	
	for(int i=0;i<=P;i++)
		DP[0][i]=1;
		
	for(int i=1;i<=N;i++)
		for(int j=0;j<=P;j++)
		{
			// If the number of people available is less than the number of components, the success rate is 0
			if(j<i)
				DP[i][j]=0;
			else
			{
				double temp=0;
				for(int k=0;k<=j;k++)
				{
					// From the recursive formulation
					if(temp<DP[i-1][j-k]*prob[i][k])
					{
						temp=DP[i-1][j-k]*prob[i][k];
						
						// Used to find the number of people assigned in various components
						people[i][j]=k;
					}
				}
				DP[i][j]=temp;
			}
		}
	
	// Finding number of people assigned to each component
	int assign[N+1],prev=P;
	for(int i=N;i>0;i--)
	{
		int t=people[i][prev];
		assign[i]=t;
		prev-=t;
	}
	
	cout<<"The maximum success probability is "<<DP[N][P]<<endl;
	cout<<"The assignment of people for maximum success probability:\n";
	for(int i=1;i<=N;i++)
		cout<<"Component "<<i<<": "<<assign[i]<<endl;
	return 0;
}
