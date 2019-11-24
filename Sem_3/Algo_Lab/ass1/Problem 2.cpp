#include<iostream>
#include<bits/stdc++.h>
using namespace std;

int main(int argc, char **argv)
{
	int n;
	cout<<"Enter the number of days: ";
	cin>>n;
	vector<int> v(n);
	cout<<"Enter the data values"<<endl;
	for(int i=0; i<n ;i++)
	{
		cin>>v[i];
	}
	int max=v[0], in=0, fi=0,fin,ffi,fmax=v[0];
	for(int i=1;i<n;i++)
	{	
		if(v[i] + max >v[i])
		{
			max+=v[i];
			fi=i;
		}
		else
		{
			max=v[i];
			fi=i;
			in=i;			
		}
		if(fmax<max)
		{
			fmax=max;
			fin=in;
			ffi=fi;
		}
	}
	cout<<"The best pair is i="<<fin+1<<", j="<<ffi+1<<endl;
}
