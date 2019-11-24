#include<iostream>
#include<string.h>

using namespace std;

typedef struct treenode
{
char word[100];
struct treenode *leftchild;
struct treenode *rightchild;
struct treenode *parent;
}NODE, *NODEPTR;

NODEPTR insert(NODEPTR root){
	NODEPTR node = new NODE;
	NODEPTR cur=root;
	cout<<"Reading words.....\n";
	cin>>node->word;
	if(root==NULL){
		node->parent = NULL;
		node->leftchild = NULL;
		node->rightchild = NULL;
		root=node;
		return root;
	}
	while(1){
		if(strcmp(node->word,cur->word)<0){
			if(cur->leftchild == NULL){
				cur->leftchild = node; 
				cur->leftchild->parent = cur;
				return root;
			}
			cur=cur->leftchild;
		}
		if(strcmp(node->word,cur->word)>0){
			if(cur->rightchild == NULL){
				cur->rightchild = node; 
				cur->rightchild->parent = cur;
				return root;
			}
			cur=cur->rightchild;
		}
	}
}

void inorder(NODEPTR node){
	if(node == NULL) return;
	inorder(node->leftchild);
	cout<<node->word<<endl;
	inorder(node->rightchild);
}

int prefix(char *str1, char *str2){
	int i=0;
	
	while(i<strlen(str1) && i<strlen(str2)){
		if(str1[i]<str2[i])return -1;
		if(str1[i]>str2[i])return 1;
		i++;
	}
	if(i==strlen(str1))return 0;
	else return 1;
}

void reach_leaf(NODE **rand, NODEPTR root, char pattern[100]){
	NODEPTR cur= new NODE;
	cur=root;
	while(1){
		if(prefix(pattern,cur->word)==-1){
			if(cur->leftchild == NULL) break;
			cur=cur->leftchild;
		}
		if(prefix(pattern,cur->word)==1){
			if(cur->rightchild == NULL) break;
			cur=cur->rightchild;
		}
		if(prefix(pattern,cur->word)==0){
			if(cur->leftchild == NULL) break;
			cur=cur->leftchild;
		}
	}
	*rand = cur;
}

void find_extensions(NODEPTR root, char pattern[100]){
	NODEPTR cur=root;
	while(1){
		reach_leaf(&cur,cur,pattern);
		if(prefix(pattern,cur->word))break;
		while(cur->rightchild!=NULL) {
			reach_leaf(&cur,cur->rightchild,pattern);
			if(prefix(pattern,cur->word)break;
			cout<<cur->word<<endl;

		while(1){
			if(cur->parent==NULL)break;
			if(cur->parent->leftchild == cur){
				cur=cur->parent;
				cout<<cur->word<<endl;
				cur=cur->rightchild;
				break;
			}
			while(cur->parent->rightchild == cur){
				if(prefix(pattern,cur->word))break;
				cur=cur->parent;
				if(cur->parent==NULL)break;
				if(cur->parent->leftchild == cur)break;
			}
			if(prefix(pattern,cur->word))break;
		}
		if(cur->parent==NULL){
			if(!prefix(pattern,cur->word))cout<<cur->word<<endl;
			break;
		}
		if(prefix(pattern,cur->word))break;
	}
	cout<<endl;	
}

NODEPTR delete_prefix(NODEPTR root, char *pattern){
	NODEPTR cur=root;
	//reach_leaf(&cur,root,pattern);
	return root;
}

int main(){
	cout<<"Reading the number of words....\n ";
	int n;
	cin>>n;
	NODEPTR root=NULL;
	for(int i=0;i<n;i++)root=insert(root); 
	cout<<endl<<endl<<"Inorder traversal"<<endl;
	inorder(root);
	cout<<endl<<"Reading the pattern.....\n";
	char str[100];
	cin>>str;
	cout<<"\nAll extensions of "<<str<<" in lexicographic order:-\n";
	find_extensions(root,str);
	root = delete_prefix(root,str);
	cout<<"\nAfter Deleting\n";
	inorder(root);
	return 0;
}
