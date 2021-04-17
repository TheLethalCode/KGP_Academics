#include <bits/stdc++.h>
using namespace std;

typedef struct _wordR 
{ 
  char word[100]; 
  double x, y; 
} wordR; 

typedef struct _node
{ 
  wordR w; 
  struct _node *next; 
} node, *nodePointer; 

typedef nodePointer **hashTable; 

void insertH(hashTable H, int m, wordR w)
{
    nodePointer Q=new node;
    Q->w=w;
    Q->next=NULL;
    
    int i=m*(w.x),j=m*(w.y);
    
    if(H[i][j]==NULL) H[i][j]=Q;
    else 
    {
        Q->next=H[i][j];
        H[i][j]=Q;
    }
}

void printH(hashTable H, int m, FILE *fp)
{
    for(int i=0;i<m;i++)
    {
        for(int j=0;j<m;j++)
        {
            fprintf(fp,"(%d,%d)::( ",i,j);
            
            nodePointer cur=H[i][j];
            while(cur!=NULL) 
            {
                fprintf(fp,"%s ",cur->w.word);
                cur=cur->next;
            }
            fprintf(fp,")\n");
        }
    }
}

bool isvalid(int m,int i,int j)
{
    if(i<0 || j<0) return false;
    if(i>=m || j>=m) return false;
    return true;
}

void findNN(hashTable H, int m, wordR w)
{
    int i=m*(w.x);
    int j=m*(w.y);
    
    double tmin=10;
    wordR tw;
    
	// Checking squares until word is encountered
    int k=0,f=1;
    while(f)
    {
        for(int p=i-k;p<=i+k;p++)
        {
            for(int q=j-k;q<=j+k;q++)
            {
                if(!isvalid(m,p,q))continue;
                if(H[p][q]==NULL)continue;
                f=0;
                nodePointer cur=H[p][q];
                while(cur!=NULL)
                {
                    double x=(cur->w).x-w.x;
					double y=(cur->w).y-w.y;
                    double dist = sqrt(x*x+y*y);
                    if(x==0 && y==0){cur=cur->next;continue;}
                    if(tmin>dist)
                    {
                        tmin=dist;
                        tw = cur->w;
                    }
					cur=cur->next;
                }
                
            }
        }
        k++;
    }
	
	// Checking all squares that fall under the calculated distance as radius 
    int circ_rad = ceil(m*tmin);
    while(k<=circ_rad)
    {
        for(int p=i-k;p<=i+k;p++)
        {
            for(int q=j-k;q<=j+k;q++)
            {
                if(!isvalid(m,p,q))continue;
                if(H[p][q]==NULL)continue;
                nodePointer cur=H[p][q];
                while(cur!=NULL)
                {
                    double x=(cur->w).x-w.x,y=(cur->w).y-w.y;
                    double dist = sqrt(x*x+y*y);
                    if(x==0 && y==0){cur=cur->next;continue;}
                    if(tmin>dist)
                    {
                        tmin=dist;
                        tw = cur->w;
                    }
					cur=cur->next;
                }
                
            }
        }
        k++;
    }
    printf("The correct result is (%s, %lf, %lf)\n",tw.word,tw.x,tw.y);
    // }
}

hashTable start(int n, int m, FILE *inpf)
{
    hashTable H;
    H = (hashTable)malloc(m * sizeof(nodePointer *));
    
    for(int i=0;i<m;i++)
    {
        H[i] = (nodePointer *)malloc(m * sizeof(nodePointer));
        for(int j=0;j<m;j++)H[i][j]=NULL;
    }
    
    for(int i=0;i<n;i++)
    {
        wordR word;
        fscanf(inpf,"%s%lf%lf",word.word,&(word.x),&(word.y));
        insertH(H,m,word);
    }
    return H;
}

int main() {
	
	int n;
	FILE *inpf; 

	inpf = fopen("input.txt","r");
    if(inpf == NULL)
    {
        cout<<"Error opening file input.txt"<<endl;
        exit(0);
    }
    
    fscanf(inpf,"%d",&n);
    int m=ceil(sqrt(n));
    
	cout<<"The number of words to be inserted in the hashtable are "<<n<<endl;
	printf("The size of the hashtable is: %d*%d\n",m,m);

    hashTable H=start(n,m,inpf); 
    cout<<"\nFinished inserting the elements in the hashtable\n"<<endl;
	
	FILE *outf = fopen("output.txt", "w");
	printH(H,m,outf);
    cout<<"Finished printing the elements of the hashtable\n"<<endl;
	
	int k;
	cout<<"Enter the number of words to search for:- ";
	cin>>k;
	
	for(int i=0;i<k;i++)
	{
	    cout<<"\nEnter the word tuple "<<i+1<<" :- ";
	    wordR w;
	    cin>>w.word>>w.x>>w.y;
	    findNN(H,m,w);
	}
	return 0;
}

