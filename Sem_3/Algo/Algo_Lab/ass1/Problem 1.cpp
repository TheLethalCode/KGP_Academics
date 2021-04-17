#include<iostream>
#include<stdlib.h>

using namespace std;

struct node
{
   int data;
   node *xval;
};

void traverse_from_front_to_end(node *head)
{
	cout<<"Traversing from front to end"<<endl;
	node *cur=head, *prev=NULL;
	while(cur->xval != prev)
	{
		cout<<cur->data<<" ";
		node *temp =cur;
		cur=(node *)((unsigned int)prev ^ (unsigned int)(cur->xval));
		prev = temp;
	}
	cout<<cur->data<<endl;
}

void traverse_from_end_to_front(node *tail)
{
	cout<<"Traversing from end to front"<<endl;
	node *cur=tail, *next=NULL;
	while(cur != NULL)
	{
		cout<<cur->data<<" ";
		node *temp =cur;
		cur=(node *)((unsigned int)next ^ (unsigned int)(cur->xval));
		next = temp;
	}
	cout<<endl;
}

void sort(node **head, node **tail)
{	
	cout<<"Sorting"<<endl;
	node *cur_o = *head, *prev_o = NULL;
	node *next_o = (node *)((unsigned int)prev_o ^ (unsigned int)(cur_o->xval));
	while(cur_o->xval != prev_o)
	{
		node *cur_i=next_o;
		node *prev_i=cur_o;
		node *next_i=(node *)((unsigned int)prev_i ^ (unsigned int)(cur_i->xval));
		while(cur_i!=NULL)
		{
			node *next_i=(node *)((unsigned int)prev_i ^ (unsigned int)(cur_i->xval));
			if(cur_o->data > cur_i->data)
			{
				cur_i->xval=(node *)((unsigned int)prev_o ^ (unsigned int)(next_o));
				cur_o->xval=(node *)((unsigned int)prev_i ^ (unsigned int)(next_i));
				if(prev_o==NULL)
				head=&cur_i;
				if(next_o==NULL)
				tail=&cur_i;
				if(prev_i==NULL)
				head=&cur_o;
				if(next_i==NULL)
				head=&cur_o;
				prev_i=cur_o;
				node *temp=cur_i;
				cur_i=(node *)((unsigned int)prev_i ^ (unsigned int)(cur_o->xval));
				cur_o=temp;				
			}
			prev_i=cur_i;
			cur_i=next_i;
		}
		prev_o=cur_o;
		cur_o=next_o;
		
	}
}

void reverse(struct node **head, struct node **tail)
{
	cout<<"Reversing ....... Done"<<endl;
	node *temp = *head;
	*head = *tail;
	*tail = temp;
} 

int main(int argc, char **argv)
{
	int n;
   	cout<<"The number of nodes: ";
   	cin>>n;
	
   	node *head = new node;
	node *tail;
	node *cur = head, *prev = NULL, *next=NULL;
   	for(int i=0;i<n;i++)
   	{
		cur->data = rand()%101;
		if(i!=n-1)
		{
			next = new node;
			cur->xval  = (node *)((unsigned int)prev ^ (unsigned int)next);	
			prev = cur;
			cur = next;
		}
		else
		{
			next = NULL;
			tail = cur;
			cur->xval = (node *)((unsigned int)prev ^ (unsigned int)next);	
		}
	}

	traverse_from_front_to_end(head);
	cout<<endl;
	traverse_from_end_to_front(tail);
	cout<<endl;
	reverse(&head, &tail);
	traverse_from_front_to_end(head);
	sort(&head,&tail);
	traverse_from_front_to_end(head);
	return 0;
}
