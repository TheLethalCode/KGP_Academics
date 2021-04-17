#include<bits/stdc++.h>
using namespace std;

typedef struct _node{
	int vno;
	struct _node *next;
}node;

typedef struct _vertex{
	node *adjlist;
}vertex,*graph;

void DFS(graph G,int v,int visited[],int *cnt)
{
	node *head=G[v].adjlist;
	visited[v]=1;
	(*cnt)++;
	while(head!=NULL)
	{
		if(!visited[head->vno]) DFS(G,head->vno,visited,cnt);
		head=head->next;
	}
}

int DFSComp(graph G, int n, int rem)
{
	int visited[n]={0},cnt=1, c=0;
	visited[rem]=1;
	while(cnt<n)
	{
		int i=0;
		while(visited[i]) i++;
		DFS(G,i,visited,&cnt);
		c++;
	}
	return c;
}

void findCritical(graph G,int n)
{
	cout<<"\nCritical junctions using simple algorithm\n";
	for(int i=0;i<n;i++)
	{
		int a=DFSComp(G,n,i);
		if(a > 1)
		{
			printf("Vertex %d:- %d connected components\n",i,a); 
		}
	}
}

int calLow(graph G,int v,int discovery[],int *cnt,int rec[],int low[])
{
	node *head=G[v].adjlist;
	low[v]=discovery[v];
	rec[v]=1;
	while(head!=NULL)
	{
		int k=head->vno; 
		if(!discovery[k]) 
		{
			(*cnt)++;
			discovery[k]=*cnt;
			low[v]=min(calLow(G,k,discovery,cnt,rec,low),low[v]);
		}
		else if(rec[k])
		{
			low[v]=min(low[v],discovery[k]);
		}
		head=head->next;
	}
	rec[v]=0;
	return low[v];
}

int find(graph G,int v,int discovery[], int low[],int crit[],int visited[],int *rc)
{
	node *head=G[v].adjlist;
	visited[v]=1;
	while(head!=NULL)
	{
		int k=head->vno;
		if(!visited[k])
		{
			if(low[k]>=discovery[v]) crit[v]=1;
			if(!v) (*rc)++;
			find(G,k,discovery,low,crit,visited,rc);
		}
		head=head->next;
	}
	if(*rc>1) crit[0]=1;
	else crit[0]=0;
}

void findCriticalFast(graph G,int n)
{
	cout<<"\nCritical junctions using fast algorithm\n";
	int discovery[n]={0},parent[n],low[n]={1e9},rec[n]={0};
	parent[0]=-1;
	discovery[0]=1;
	int cnt=1;
	calLow(G,0,discovery,&cnt,rec,low);
	
	int rc=0;// rc counts the subtress of roots
	int crit[n]={0},visited[n]={0};
	find(G,0,discovery,low,crit,visited,&rc);
	for(int i=0;i<n;i++)
	{
		if(crit[i])
		{
			printf("Vertex %d is a critical junction\n",i);
		}
	}
	cout<<endl;
}

int main()
{
	cout<<"Enter the number of vertices and edges:- ";
	int n,e;
	cin>>n>>e;
	cout<<"Enter the neighbors for each of the vertex\n";
	graph G;
	G= (graph)malloc(n*sizeof(vertex));

	for(int i=0;i<n;i++)
	{
		printf("Enter degree of vertex %d:- ",i);
		int a;
		cin>>a;
		node *k;
		k=(node *)malloc(sizeof(node));
		G[i].adjlist = k;
		printf("the neighbours of vertex %d:- ",i);
		for(int i=0;i<a-1;i++)
		{
			cin>>k->vno;
			k->next=(node *)malloc(sizeof(node));
			k=k->next;
		}
		cin>>k->vno;
		k->next=NULL;
		cout<<endl;
	}

	cout<<"\nAdjacency List of the graph\n";
	for(int i=0;i<n;i++)
	{
		node *head = G[i].adjlist;
		printf("Vertex %d:- ",i);
		while(head!=NULL)
		{
			cout<<head->vno<<" ";
			head=head->next;
		}
		cout<<endl;
	}
	findCritical(G,n);
	findCriticalFast(G,n);
	return 0;
}
