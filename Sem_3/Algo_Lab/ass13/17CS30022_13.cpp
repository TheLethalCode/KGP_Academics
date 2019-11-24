#include<bits/stdc++.h>
using namespace std;

typedef int **graph;

struct Queue
{
	int *Q,front,rear;
	Queue(int n)
	{
		Q = new int[2*n];
		front=rear=-1;
	}
	void enque(int x)
	{
		if(rear==-1)
			front=rear=0,Q[0]=x;
		else
			Q[++rear]=x;
	}
	int deque()
	{
		int a=Q[front];
		front++;
		return a;
	}
	bool empty()
	{
		if(front>rear)
			return true;
		return false;
	}
	~Queue()
	{
		delete[] Q;
	}
};

struct edge
{
	int u,v,w;
};

void merge(edge *T,int a, int b, int c)
{
	edge l[b-a+1],r[c-b];
	for(int i=0;i<b-a+1;i++) l[i]=T[a+i];
	for(int i=0;i<c-b;i++) r[i]=T[b+1+i];
	int k=a,x=0,y=0;
	while(x<b-a+1 && y<c-b)
	{
		if(l[x].w >= r[y].w) T[k++]=l[x++];
		else T[k++]=r[y++];
	}
	while(x<b-a+1) T[k++]=l[x++];
	while(y<c-b) T[k++]=r[y++];	
}

void sort(edge *T,int a,int b)
{
	if(a>=b) return;
	int mid=(a+b)/2;
	sort(T,a,mid);
	sort(T,mid+1,b);
	merge(T,a,mid,b);
}

int isConnectedUsingBfs(graph G, int numberOfNodes)
{
	int n=numberOfNodes;
	int cnt=0,visit[n]={0};
	Queue Q(n);
	Q.enque(0),visit[0]=1,cnt=1;
	while(!Q.empty())
	{
		int u=Q.deque();
		for(int i=0;i<n;i++)
		{
			if(G[u][i] && !visit[i])
			{
				visit[i]=1;
				cnt++;
				Q.enque(i);
			}
		}
	}
	if(cnt<n)
		return 0;
	return 1;
}

void findMST(graph G, int numberOfNodes)
{
	int n=numberOfNodes,m=0;
	edge E[n*n];
	for(int i=0;i<n;i++)
	{
		for(int j=i+1;j<n;j++)
		{
			if(G[i][j])
			{
				E[m].u=i,E[m].v=j,E[m].w=G[i][j];
				m++;
			}
		}
	}
	sort(E,0,m-1);
	for(int i=0;i<m;i++)
	{
		int u=E[i].u,v=E[i].v,w=E[i].w;
		G[u][v]=0,G[v][u]=0;
		if(!isConnectedUsingBfs(G,n))
			G[u][v]=G[v][u]=w;
	}
	
	cout<<"The neighbors of each node of the MST computed and corresponding weights are\n";
	for(int i=0;i<n;i++)
	{
		cout<<"Vertex "<<i<<": ";
		for(int j=0;j<n;j++)
			if(G[i][j])
				cout<<j<<" "<<G[i][j]<<" ";
		cout<<endl;
	}
	cout<<endl;
}

void printGraph(graph G,int n)
{
	cout<<"The neighbors of each node in the input graph and corresponding weights are\n";
	for(int i=0;i<n;i++)
	{
		cout<<"Vertex "<<i<<": ";
		for(int j=0;j<n;j++)
			if(G[i][j])
				cout<<j<<" "<<G[i][j]<<" ";
		cout<<endl;
	}
	cout<<endl;
}

int main()
{
	int n,m;
	cout<<"Enter the number of Nodes and Edges: ";
	cin>>n>>m;
	graph G = new int*[n];
	for(int i=0;i<n;i++)
		G[i]=new int[n];
	
	cout<<"\nEnter the neighbours of each node and their corresponding weights\n\n";
	for(int i=0;i<n;i++)
	{
		cout<<"Degree of Vertex "<<i<<": ";
		int k;
		cin>>k;
		cout<<"Neighbours of "<<i<<": ";
		for(int j=0;j<k;j++)
		{
			int r;
			cin>>r;
			cin>>G[i][r];
		}
		cout<<endl;
	}
	printGraph(G,n);
	findMST(G,n);
	delete[] G;
	return 0;
}
