#include<bits/stdc++.h> 
using namespace std; 
  
// An AVL tree node  
class Node  
{  
    public: 
    int key;  
    Node *left;  
    Node *right;  
    int height;  
};  

// height of the tree  
int height(Node *N)  
{  
    if (N == NULL)  
        return 0;  
    return N->height;  
}  
  

int max(int a, int b)  
{  
    return (a > b)? a : b;  
}  
  
//New node memory allocation and initialisation
Node* newNode(int key)  
{  
    Node* node = new Node(); 
    node->key = key;  
    node->left = NULL;  
    node->right = NULL;  
    node->height = 1; 
    return(node);  
}  
  
//Right rotation of subtree rooted with y 
Node *rightRotate(Node *y)  
{  
    Node *x = y->left;  
    Node *T2 = x->right;  
  
    // Perform rotation  
    x->right = y;  
    y->left = T2;  
  
    // Update heights  
    y->height = max(height(y->left), 
                    height(y->right)) + 1;  
    x->height = max(height(x->left), 
                    height(x->right)) + 1;  
  
    // Return new root  
    return x;  
}  
  
//Left rotation of subtree rooted with x 
Node *leftRotate(Node *x)  
{  
    Node *y = x->right;  
    Node *T2 = y->left;  
  
    // Perform rotation  
    y->left = x;  
    x->right = T2;  
  
    // Update heights  
    x->height = max(height(x->left),     
                    height(x->right)) + 1;  
    y->height = max(height(y->left),  
                    height(y->right)) + 1;  
  
    // Return new root  
    return y;  
}  
  
// Get Balance factor of node N  
int getBalance(Node *N)  
{  
    if (N == NULL)  
        return 0;  
    return height(N->left) - height(N->right);  
}  
  
// Recursively insert the new vertex into the Balanced AVL tree
Node* insert(Node* node, int key, vector <vector <int> > &adjmat)  
{  
    if (node == NULL)  
        return(newNode(key));  

    if (adjmat[key][node->key])  
        node->left = insert(node->left, key, adjmat);  
    else  
        node->right = insert(node->right, key, adjmat);  

    //Update Height
    node->height = 1 + max(height(node->left),  
                        height(node->right));  
  
    //balance factor
    int balance = getBalance(node);  

   // Left Left Case  
    if (balance > 1 && adjmat[key][node->left->key])  
        return rightRotate(node);  
  
    // Right Right Case  
    if (balance < -1 && adjmat[node->right->key][key])  
        return leftRotate(node);  
  
    // Left Right Case  
    if (balance > 1 && adjmat[node->left->key][key])  
    {  
        node->left = leftRotate(node->left);  
        return rightRotate(node);  
    }  
  
    // Right Left Case  
    if (balance < -1 && adjmat[key][node->right->key])  
    {  
        node->right = rightRotate(node->right);  
        return leftRotate(node);  
    }

    return node;  
}  
  
//Print current path, which is the inorder traversal of the graph
void inOrder(Node *root)  
{  
    if(root != NULL)  
    {  
        inOrder(root->left); 
        cout << root->key << " ";
        inOrder(root->right);  
    }  
}  

void print(vector <vector <int> > &adjmat)
{
    int n = adjmat.size();
    for(int i=0;i<n;++i)
    {
        for(int j=0;j<n;++j)
        {
            cout<<adjmat[i][j]<<" ";
        }
        cout<<endl;
    }
}

int main()  
{  
    int n;
    cin>>n;
    vector <vector <int> > adjmat(n, vector <int> (n, 0));
    for(int i=0;i<n;++i)
    {
        for(int j=0;j<n;++j)
        {
            //cout<<i<<" "<<j<<":";
            cin>>adjmat[i][j];
        }
    }
    cout<<"This is the Adjacency Matrix"<<endl;
    print(adjmat);
    cout<<endl;

    Node *root = NULL;  

    cout<<"Inserting 3: ";
    root = insert(root, 3, adjmat);
    inOrder(root);
    cout<<endl;

    cout<<"Inserting 0: ";
    root = insert(root, 0, adjmat);
    inOrder(root);
    cout<<endl;

    cout<<"Inserting 4: ";
    root = insert(root, 4, adjmat);  
    inOrder(root);
    cout<<endl;

    cout<<"Inserting 1: ";
    root = insert(root, 1, adjmat);  
    inOrder(root);
    cout<<endl;

    cout<<"Inserting 2: ";
    root = insert(root, 2, adjmat);
    inOrder(root);
    cout<<endl;
    return 0;  
}
//input
/*
0 0 1 1 0
1 0 0 1 1
0 1 0 1 1
0 0 0 0 0
1 0 0 1 0
*/