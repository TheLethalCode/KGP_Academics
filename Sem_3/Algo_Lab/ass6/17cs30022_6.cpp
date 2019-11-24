#include<bits/stdc++.h>
using namespace std;
// Preprocessing
void preprocess(int X[], int B[], int nB, int nX)
{
	for(int i=0;i<nX;i++) X[i]=0; // Initialising all elements to 0
	for(int i=0;i<nB;i++) X[B[i]]=i; // Storing the positions of all elements using the array index as key, thus allowing O(1) access
}

void combineSelf(int A[],int left,int middle,int right,int X[])
{
	int n1=middle-left+1, n2=right-middle;
	int *L = new int[n1], *R = new int[n2];
	for(int i=0;i<n1;i++) L[i]=A[i+left];
	for(int i=0;i<n2;i++) R[i]=A[i+1+middle];
	int a=0,b=0,c=left;
	while(a<n1 && b<n2)
	{
		if(X[L[a]]<X[R[b]]) A[c++]=L[a++];      // checking the position of L[a] in X with respect to R[b]
		else A[c++]=R[b++];	
	}
	while(a<n1) A[c++]=L[a++];
	while(b<n2) A[c++]=R[b++];
	delete [] L;
	delete [] R;
}

void superbSortingSelf(int A[], int sizeOfA, int B[], int sizeOfB)
{
	int n=sizeOfA;
	int x=ceil(log2(n)),val=1;
	int *X= new int[10*n+1];                            // Declaring an array for preprocessing, assuming 10*n is the element li,it
	preprocess(X,B,sizeOfB,10*sizeOfA+1);
	for(int i=0;i<x;i++)
	{
		int j=0;
		while(j<n)
		{
			int left=j, middle=min(j+val-1,n-1), right=min(j+2*val-1,n-1);
			combineSelf(A,left,middle,right,X);			//Changed the combine function to accomodate preprocessed array
			j+=2*val;
		}
		val*=2;
	}
	delete [] X;
}


int compare1(int X[], int sizeOfX, int x, int y)
{
	int n=sizeOfX,posx,posy;
	for(int i=0;i<n;i++)
	{
		if(X[i] == x) posx=i;
		if(X[i] == y) posy=i;
	}
	if(posx<posy) return 1;
	else return 0;

}

void combine1(int A[], int left, int middle, int right, int B[], int sizeOfB)
{
	int n1=middle-left+1, n2=right-middle;
	int *L = new int[n1], *R = new int[n2];
	for(int i=0;i<n1;i++) L[i]=A[i+left];
	for(int i=0;i<n2;i++) R[i]=A[i+1+middle];
	int a=0,b=0,c=left;
	while(a<n1 && b<n2)
	{
		if(compare1(B,sizeOfB,L[a],R[b])) A[c++]=L[a++];
		else A[c++]=R[b++];	
	}
	while(a<n1) A[c++]=L[a++];
	while(b<n2) A[c++]=R[b++];
	delete [] L;
	delete [] R;
}

void superbSorting1(int A[], int sizeOfA, int B[], int sizeOfB)
{
	int n=sizeOfA;
	int x=ceil(log2(n)),val=1;
	for(int i=0;i<x;i++)
	{
		int j=0;
		while(j<n)
		{
			int left=j, middle=min(j+val-1,n-1), right=min(j+2*val-1,n-1);
			combine1(A,left,middle,right,B,sizeOfB);			
			j+=2*val;
		}
		val*=2;
	}
}

void combine(int A[], int left, int middle, int right)
{
	int n1=middle-left+1, n2=right-middle;
	int *L = new int[n1], *R = new int[n2];
	for(int i=0;i<n1;i++) L[i]=A[i+left];
	for(int i=0;i<n2;i++) R[i]=A[i+1+middle];
	int a=0,b=0,c=left;
	while(a<n1 && b<n2)
	{
		if(L[a]<R[b]) A[c++]=L[a++];
		else A[c++]=R[b++];	
	}
	while(a<n1) A[c++]=L[a++];
	while(b<n2) A[c++]=R[b++];
	delete [] L;
	delete [] R;
}

void superbSorting(int A[], int sizeOfA)
{
	int n=sizeOfA;
	int x=ceil(log2(n)),val=1;
	for(int i=0;i<x;i++)
	{
		int j=0;
		while(j<n)
		{
			int left=j, middle=min(j+val-1,n-1), right=min(j+2*val-1,n-1);
			combine(A,left,middle,right);			
			j+=2*val;
		}
		val*=2;
	}
}

int main()
{
	int n, nB;

	printf("\nEnter no. of elements in array A:- ");
	cin>>n;
	int *A= new int[n];
	printf("\nEnter the numbers in array A:- ");
	for(int i=0;i<n;i++) cin>>A[i];
	printf("\n\nArray A in sorted non-decreasing order:- ");
	superbSorting(A,n);		
	for(int i=0;i<n;i++) cout<<A[i]<<" ";	
	cout<<endl;	

	printf("\nEnter the numbers in array A:- ");
	for(int i=0;i<n;i++) cin>>A[i];
	printf("\nEnter no. of elements in array B:- ");
	cin>>nB;
	int *B= new int[nB];
	printf("\nEnter the numbers in array B:- ");
	for(int i=0;i<nB;i++) cin>>B[i];
	printf("\n\nArray A after rearranging:- ");
	superbSorting1(A,n,B,nB);	
	for(int i=0;i<n;i++) cout<<A[i]<<" ";
	delete [] B;
	cout<<endl;
	
	printf("\nEnter the numbers in array A:- ");
	for(int i=0;i<n;i++) cin>>A[i];
	printf("\nEnter no. of elements in array B:- ");
	cin>>nB;
	B= new int[nB];
	printf("\nEnter the numbers in array B:- ");
	for(int i=0;i<nB;i++) cin>>B[i];
	printf("\n\nArray A after rearranging:- ");
	superbSortingSelf(A,n,B,nB);	
	for(int i=0;i<n;i++) cout<<A[i]<<" ";
	cout<<endl;
	
	return 0;
}
