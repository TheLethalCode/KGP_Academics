#include <iostream>
using namespace std;

typedef struct node
{
    int value;
    struct node *left;
    struct node *right;
    struct node *parent;
}NODE, *NODEPTR;

NODEPTR reach_left(NODEPTR root)
{
	NODEPTR cur=root;
	while(cur->left != NULL)cur=cur->left;
	return cur;
}

NODEPTR search(NODEPTR root,int val)
{
    if(root == NULL || root->value == val ) return root;
    if(root->value < val) return search(root->right,val);
    else return search(root->left,val);
}

NODEPTR makeRoot(NODEPTR root, NODEPTR N)
{
    if(N->parent->right == N)
    {
        NODEPTR x = N->parent;
        NODEPTR y = x->right;
    	x->right=y->left;
    	if(y->left != NULL) y->left->parent = x;
    	y->parent = NULL;
    	root = y;
    	y->left=x;
    	x->parent=y;
    }
    else
    {
        NODEPTR y = N->parent;
        NODEPTR x = y->left;
    	y->left=x->right;
    	if(y->left != NULL) y->left->parent = y;
    	x->parent = NULL;
    	root = x;
    	x->right=y;
    	y->parent=x; 
    }
    return root;
}

NODEPTR sameOrientation(NODEPTR root, NODEPTR N)
{
    if(N->parent->left == N)
    {
        NODEPTR P= N->parent;
        NODEPTR G= P->parent;
        P->left = N->right;
        if(N->right != NULL) P->left->parent = P;
        N->right = P;
        P->parent = N;
        N->parent = G->parent;
        if(G->parent == NULL) root = N;
        else if(G->parent->left == G) G->parent->left = N;
        else G->parent->right = N;
        NODEPTR T2=P->right;
        P->right = G;
        G->parent = P;
        G->left=T2;
        if(T2!=NULL)T2->parent=G;
    }
    else
    {
        NODEPTR P= N->parent;
        NODEPTR G= P->parent;
        P->right = N->left;
        if(N->left != NULL) P->right->parent = P;
        N->left = P;
        P->parent = N;
        N->parent = G->parent;
        if(G->parent == NULL) root = N;
        else if(G->parent->left == G) G->parent->left = N;
        else G->parent->right = N;
        NODEPTR T2=P->left;
        P->left = G;
        G->parent = P;
        G->right=T2;
        if(T2!=NULL)T2->parent=G;
    }
    return root;
}

NODEPTR oppositeOrientation(NODEPTR root, NODEPTR N)
{
    if(N->parent->right == N)
    {
        NODEPTR P= N->parent;
        NODEPTR G= P->parent;
        NODEPTR T2 = N->right;
        NODEPTR T3 = N->left;
        N->parent = G->parent;
        if(G->parent == NULL) root = N;
        else if(G->parent->left == G) G->parent->left = N;
        else G->parent->right = N;
        N->left = P;
        P->parent = N;
        N->right = G;
        G->parent = N;
        G->left=T2;
        if(T2!=NULL)T2->parent=G;
        P->right=T3;
        if(T3!=NULL)T3->parent=P;
    }
    else
    {
        NODEPTR P= N->parent;
        NODEPTR G= P->parent;
        NODEPTR T2 = N->left;
        NODEPTR T3 = N->right;
        N->parent = G->parent;
        if(G->parent == NULL) root = N;
        else if(G->parent->left == G) G->parent->left = N;
        else G->parent->right = N;
        N->left = G;
        G->parent = N;
        N->right = P;
        P->parent = N;
        G->right=T2;
        if(T2!=NULL)T2->parent=G;
        P->left=T3;
        if(T3!=NULL)T3->parent=P;
    }
    return root;
}

NODEPTR lift(NODEPTR root, NODEPTR z)
{
    if(root == NULL) return root;
    if(z == NULL) return root;
    while(z!=root)
    {
        if(z->parent == root)
        {
            root = makeRoot(root,z);
            continue;
        }
        else
        {
            if(z->parent->left == z && z->parent->parent->left == z->parent)
            {
                root = sameOrientation(root,z);
                continue;
            }
            else if(z->parent->right == z && z->parent->parent->right == z->parent)
            {
                root = sameOrientation(root,z);
                continue;
            }
	    else 
 	    {	
                root = oppositeOrientation(root,z);
	    }        
	}
    }
    return root;
}

NODEPTR insert(NODEPTR root, int key)
{
    NODEPTR z= new node;
    if(search(root,key) != NULL) return root;
    z->value=key;
    NODEPTR y = NULL;
	NODEPTR cur = root;
	while(cur!=NULL)
	{
		y=cur;
		if(z->value > cur->value)cur=cur->right;
		else cur=cur->left;
	}
	z->parent=y;
	if(y == NULL) root = z;
	else if(z->value < y->value) y->left=z;
	else y->right = z;
	z->left = NULL;
	z->right = NULL;
	root = lift(root,z);
	return root;
}

NODEPTR delete_sbst(NODEPTR root, int key)
{
    NODEPTR z=search(root,key);
    if( z == NULL) return root;
	
	NODEPTR tmp = z->parent;
	
	if(z->left == NULL && z->right == NULL)
	{
	    if(tmp == NULL) root = NULL;
	    else
	    {
	        if(tmp->left == z)tmp->left = NULL;
	        else tmp->right = NULL;
	    }
	    delete(z);
	}
	else if(z->left == NULL)
	{
	    if(tmp == NULL) root = z->right;
	    else
	    {
	        if(tmp->left == z)tmp->left = z->right;
	        else tmp->right = z->right;
	        z->right->parent=tmp;
	    }
	    delete(z);
	}
	else if(z->right == NULL)
	{
	    if(tmp == NULL) root = z->left;
	    else
	    {
	        if(tmp->left == z)tmp->left = z->left;
	        else tmp->right = z->left;
	        z->left->parent=tmp;
	    }
	    delete(z);
	}
	else
	{
	    NODEPTR a=reach_left(z->right);
	    z->value = a->value;
	    if(a->right == NULL)
	    {
                if(a->parent->left == a)a->parent->left = NULL;
	        else a->parent->right = NULL;
            }
	    else
            {
		if(a->parent->left == a)a->parent->left = a->right;
	        else a->parent->right = a->right;
		a->right->parent=a->parent;
            }
	    delete(a);
	}
	root=lift(root,tmp);
	return root; 
}

void preOrder(NODEPTR root)
{
    if(root==NULL)return;
    cout<<root->value<<" ";
    preOrder(root->left);
    preOrder(root->right);
}

void inOrder(NODEPTR root)
{
    if(root==NULL)return;
    inOrder(root->left);
    cout<<root->value<<" ";
    inOrder(root->right);
}

int main() 
{
    int n;
    NODEPTR root=NULL;
    cout<<"Enter the number of entries: ";
    cin>>n;
    cout<<"Enter the numbers:\n ";
    for(int i=0;i<n;i++)
    {
        int a;
        cin>>a;
        root=insert(root,a);
    }
    cout<<"Preorder traversal: ";
    preOrder(root);
    cout<<endl<<"Inorder traversal: ";
    inOrder(root);
    cout<<endl;
    cout<<"Enter number of deletes: "<<endl;
    cin>>n;
    cout<<endl;
    for(int i=0;i<n;i++)
    {
        int a;
	cout<<"Enter the number to be deleted: ";
        cin>>a;
        root=delete_sbst(root,a);
	cout<<"Preorder traversal: ";
        preOrder(root);
        cout<<endl<<"Inorder traversal: ";
        inOrder(root);
        cout<<endl<<endl;
    }
    return 0;
}

