#include<iostream>
#include<stdio.h>
using namespace std;

struct room{
	int hInd, vInd;
};

struct node{
	room data;
	node *next;
};

typedef struct {
	struct node *front, *rear ;
	} QUEUE ;

void init(QUEUE *qP)
{
	qP->front=NULL;
	qP->rear=NULL;
}

int isempty(QUEUE qP)
{
		if(qP.front==NULL)return 1;
		else return 0;
}

void enqueue(QUEUE *qP, room data)
{
	if(qP->front==NULL)
	{
		qP->front = new node;
		(qP->front)->data=data;
		(qP->front)->next=NULL;
		qP->rear=qP->front;
	}
	else
	{
		(qP->rear)->next=new node;
		(qP->rear)=(qP->rear)->next;
		(qP->rear)->data=data;
		(qP->rear)->next=NULL;
	}
}

void dequeue(QUEUE *qP)
{
	if(qP->front==qP->rear)
	{
		qP->front=NULL;
		qP->rear=NULL;
	}
	else
	{
		qP->front=(qP->front)->next;
	}
}


typedef struct node node, *list;

bool isValid(int i, int j, int n)
{
	if(i<0 || i>=n)
		return false;
	if(j<0 ||  j>=n)
		return false;
	return true;
}

int strategy2(list maze[][20], int n, room start, room end)
{	
	cout<<endl<<endl<<"Using Strategy 2 ..... "<<endl<<endl;
	bool visited[20][20];
        for(int i=0;i<n;i++) for(int j=0;j<n;j++) visited[i][j]=false;
	
		
	QUEUE qP;
	init(&qP);
	enqueue(&qP, start);
        visited[start.hInd][start.vInd]=true;

	while(!isempty(qP))
	{
		room pr = (qP.front)->data;
	       	dequeue(&qP);
//              cout<<pr.hInd<<" "<<pr.vInd<<endl;
	        if(pr.hInd == end.hInd && pr.vInd == end.vInd) return 1;
		node *cur=maze[pr.hInd][pr.vInd]->next;
		while(cur!=NULL)
		{
			if(!visited[cur->data.hInd][cur->data.vInd])
                        {
                                enqueue(&qP, cur->data);
//				cout<<"Adding "<<cur->data.hInd<<" "<<cur->data.vInd<<endl;
				visited[cur->data.hInd][cur->data.vInd]=true;
			}
			cur=cur->next;
		}
//		cout<<"loop done"<<endl;
	}
	return 0;
}

int strategy1(list maze[][20], int n, room start, room end)
{
	cout<<"Using Strategy 1 ..... "<<endl<<endl;
	bool visited[20][20];
	for(int i=0;i<n;i++) for(int j=0;j<n;j++) visited[i][j]=false;
	struct stack{
		int top;
		room cur[400];
		void push(room pr) { cur[++top]=pr;}
		room pop() { top--;return cur[top+1];}
		room back() { return cur[top];}
		bool empty() { if(top == -1) return true; else return false;}
	}st;
	st.top=-1;
	st.push(start);
	visited[start.hInd][start.vInd]=true;
	while(!st.empty())
	{
		room pr = st.back();
		if(pr.hInd == end.hInd && pr.vInd == end.vInd) return 1;
		node *cur=maze[pr.hInd][pr.vInd]->next;
		while(1)
		{
			if(!visited[cur->data.hInd][cur->data.vInd])
			{
				st.push(cur->data);
				visited[cur->data.hInd][cur->data.vInd]=true;
				break;
			}
			cur=cur->next;
			if(cur==NULL)
			{
				st.pop();
				break;
			}
		}
	}
	return 0;
}

void printmaze(bool H[][20], bool V[][20], int n)
{
	cout<<"The maze looks like this ..."<<endl<<endl;
	for(int i=0;i<n+1;i++)
	{
		cout<<"+";
		for(int j=0;j<n;j++)
		{	
			if(!H[i][j]) cout<<"---+";
			else cout<<"   +";
		}
		cout<<endl;
		if(i==n) continue;
		for(int j=0;j<n+1;j++)
		{
			if(!V[i][j]) cout<<"|   ";
			else cout<<"    ";
		}
		cout<<endl;
	}	
	cout<<endl<<endl;
}

void createmaze(list maze[][20], int n, bool H[][20], bool V[][20])
{
	for(int i=0;i<n;i++)
	{
		for(int j=0;j<n;j++)
		{
			
			room pr;
			pr.hInd=i;pr.vInd=j;
			node *head, *cur;
			head = new node;
			head->data=pr;	
			head->next=NULL;
			cur=head;
			maze[i][j]=head; 
			if(isValid(i-1,j,n))
			{
				if(H[i][j]){
					cur->next= new node;
					cur=cur->next;
					cur->data.hInd=i-1;
					cur->data.vInd=j;
					cur->next=NULL;
				}		
			}
			if(isValid(i+1,j,n))
			{
				if(H[i+1][j]){
					cur->next= new node;
					cur=cur->next;
					cur->data.hInd=i+1;
					cur->data.vInd=j;
					cur->next=NULL;
				}	
			}
			if(isValid(i,j-1,n))
			{
				if(V[i][j]){
					cur->next= new node;
					cur=cur->next;
					cur->data.hInd=i;
					cur->data.vInd=j-1;
					cur->next=NULL;
				}	
			}	
			if(isValid(i,j+1,n))
			{
				if(V[i][j+1]){
					cur->next= new node;
					cur=cur->next;
					cur->data.hInd=i;
					cur->data.vInd=j+1;
					cur->next=NULL;
				}	
			}
		}
	}
	
	cout<<"The linked list representation looks like :- \n\n";

	for(int i=0;i<n;i++)
	{
		for(int j=0;j<n;j++)
		{
			printf("(%d,%d)::",i,j);
			node *cur = maze[i][j]->next;
			while(cur!=NULL)
			{
				printf("-->(%d,%d)",cur->data.hInd,cur->data.vInd);
				cur=cur->next;
			}
			cout<<endl;	
		}
	}
	cout<<endl<<endl;
}

int main(int argc, char **argv)
{
	int n;
	cout<<"Reading n ..... "<<endl<<endl;
	cin>>n;
	bool H[20][20], V[20][20];

	cout<<"Reading H ..... "<<endl<<endl;
	for(int i=0;i<n+1;i++)
	  for(int j=0;j<n;j++)
	    cin>>H[i][j];
	
	cout<<"Reading V ..... "<<endl<<endl;
	for(int i=0;i<n;i++)
	  for(int j=0;j<n+1;j++)
	    cin>>V[i][j];	

	room st, en;
	cout<<"Reading the starting indices ......"<<endl<<endl;
	cin>>st.hInd>>st.vInd;

	cout<<"Reading the ending indices ......"<<endl<<endl;
        cin>>en.hInd>>en.vInd;
	
	list maze[20][20];
	 
	printmaze(H, V, n);
	
	createmaze(maze, n, H, V);

	if(strategy1(maze,n,st,en))printf("A path is found using strategy 1 from (%d,%d) to (%d,%d)",st.hInd,st.vInd,en.hInd,en.vInd);
	else printf("There is no path from (%d,%d) to (%d,%d)",st.hInd,st.vInd,en.hInd,en.vInd);

	if(strategy2(maze,n,st,en))printf("A path is found using strategy 2 from (%d,%d) to (%d,%d)",st.hInd,st.vInd,en.hInd,en.vInd);
        else printf("There is no path from (%d,%d) to (%d,%d)",st.hInd,st.vInd,en.hInd,en.vInd);

	return 0;
}
