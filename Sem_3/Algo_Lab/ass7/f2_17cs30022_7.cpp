#include <bits/stdc++.h>
using namespace std;

#define MAX_SIZE 100 

typedef struct _job 
{ 
    int jobId; 
    int startTime; 
    int jobLength;
    int remLength; 
} job;

typedef struct _heap 
{ 
    job list[MAX_SIZE];
    int jobPos[MAX_SIZE];    
    /* This stores the position of the particular jobId in the heap. It is updated as the position changes frequently from the functions heapify_up and heapify_down and insert. */ 
    int numJobs; 
} newheap;

typedef struct _jobPair 
{ 
	int jobid_from; 
	int jobid_to; 
} jobpair; 

// Compares two jobs. If x is more priorotize, it returns 1, else 0
bool compare(newheap *H,int x, int y)
{
    job job1=H->list[x],job2=H->list[y];
    if(job1.remLength < job2.remLength) return 1;
    else if(job1.remLength == job2.remLength && job1.jobId < job2.jobId) return 1;
    return 0;
}

// Merge Sort for sorting the job pairs according to their jobid_from.
void merge1(jobpair jobList[],int a, int b, int c)
{
	jobpair l[b-a+1],r[c-b];
	for(int i=0;i<b-a+1;i++) l[i]=jobList[a+i];
	for(int i=0;i<c-b;i++) r[i]=jobList[b+1+i];
	int k=a,x=0,y=0;
	while(x<b-a+1 && y<c-b)
	{
		if(l[x].jobid_from < r[y].jobid_from) jobList[k++]=l[x++];
		else jobList[k++]=r[y++];
	}
	while(x<b-a+1) jobList[k++]=l[x++];
	while(y<c-b) jobList[k++]=r[y++];	
}

void sort1(jobpair pairs[],int a,int b)
{
	if(a>=b) return;
	int mid=(a+b)/2;
	sort1(pairs,a,mid);
	sort1(pairs,mid+1,b);
	merge1(pairs,a,mid,b);
}

// Merge sort to sort the joblist accoriding to the start time
void merge(job jobList[],int a, int b, int c)
{
	job l[b-a+1],r[c-b];
	for(int i=0;i<b-a+1;i++) l[i]=jobList[a+i];
	for(int i=0;i<c-b;i++) r[i]=jobList[b+1+i];
	int k=a,x=0,y=0;
	while(x<b-a+1 && y<c-b)
	{
		if(l[x].startTime < r[y].startTime) jobList[k++]=l[x++];
		else jobList[k++]=r[y++];
	}
	while(x<b-a+1) jobList[k++]=l[x++];
	while(y<c-b) jobList[k++]=r[y++];	
}

void sort(job jobList[],int a,int b)
{
	if(a>=b) return;
	int mid=(a+b)/2;
	sort(jobList,a,mid);
	sort(jobList,mid+1,b);
	merge(jobList,a,mid,b);
}

// Checks whether the job has started or not. Returns true if it has not.
bool start(job x)
{
	if(x.jobLength == x.remLength) return true;
	return false;
}

// Binary searches the elements in the job pairs based on jobid_from.
// Returns the first element that matches x, or if no match returns -1.
// Runs in O(logM) = O(logN), as M=O(N)
int bsearch(int x, jobpair pairs[],int m)
{
	int st=0,la=m-1;
	while(la-st>1)
	{
		int mid=(st+la)/2;
		if(pairs[mid].jobid_from>=x)la=mid;
		else st=mid; 
	}
	if(pairs[st].jobid_from==x) return st;
	else if(pairs[la].jobid_from==x) return la;
	return -1;
}

// Makes the heap proper from bottom to top. Runs in O(logN)
void heapify_up(newheap *H, int pos)
{
    while((pos/2)>0)
    {
        job par=H->list[pos/2];
        job cur=H->list[pos];
        if(compare(H,pos/2,pos)) return;
        else
      	{
	    H->jobPos[par.jobId]=pos;
            H->jobPos[cur.jobId]=pos/2;
	    H->list[pos]=par;
            H->list[pos/2]=cur;
        }
        pos/=2;
    }
}

// Makes the heap proper from top to bottom.Runs in O(logN)
void heapify_down(newheap *H, int pos)
{
    int left=2*pos;
    int right = left+1;
    int n=H->numJobs;
    int smallest;
    if(left <= n)
    {
        if(compare(H,left,pos)) smallest=left;
        else smallest=pos;
    }
    else smallest=pos;
    if(right <= n)
    {
        if(compare(H,right,smallest)) smallest=right;
    }
    if(smallest != pos)
    {
        job temp=H->list[smallest];
	job temp1=H->list[pos];
	H->jobPos[temp.jobId]=pos;
	H->jobPos[temp1.jobId]=smallest;
        H->list[smallest]=temp1;
        H->list[pos]=temp;
        heapify_down(H,smallest);
    }
}

// Runs in O(n).
void init(newheap *H) 
{
    H->numJobs=0;
    for(int i=0;i<MAX_SIZE;i++) H->jobPos[i]=-1;
}

// Inserts the job and updates the position of the job in the array. Runs in O(logN).
void insertJob(newheap *H, job j)
{
    H->numJobs+=1;
    H->list[H->numJobs]=j;
    H->jobPos[j.jobId]=H->numJobs;
    heapify_up(H,H->numJobs);
}

// Extracts the job and updates the position of all the jobs in the array.Runs in O(logN).
int extractMinJob(newheap *H,job *j)
{
    if(H->numJobs == 0) return -1;
    H->jobPos[j->jobId]=-1;
    H->jobPos[(H->list[H->numJobs]).jobId]=1;
    *j=H->list[1];
    H->list[1]=H->list[H->numJobs];
    H->numJobs=H->numJobs-1;
    heapify_down(H,1);
    return 0;
}

// Uses the position of each job stored, and decreases the joblength by 50%. Runs in O(logN)
void decreaseKey(newheap *H,int jid)
{
    int pos=H->jobPos[jid];
    if(pos==-1) return;
    if(start(H->list[pos])) 
    {
	 H->list[pos].jobLength/=2;
	 H->list[pos].remLength/=2;
	 heapify_up(H,pos);
    }
}

void newScheduler(job jobList[],int n, jobpair pairList[], int m)
{
	newheap *H;
	H = new newheap;
    	init(H);
	sort(jobList,1,n); // Complexity = O(NlogN)
	sort1(pairList,0,m-1); // Complexity = O(MlogM) = O(NlogN)
	int Depends[n+1]={0};
	job current;
	int run=0;
	int time=0;
	int pos=1;
	int turnaround=0;
	cout<<"The jobs scheduled at each time step are\n";
	while(pos<=n || H->numJobs>0 || run)     // Runs in O(T)
	{
		int change=0;
		if(pos<=n)
		{
			// Insertion into the heap as soon as the start time is reached. Happens N times. Complexity = O(NlogN)
			while(jobList[pos].startTime==time)
			{
				change=1;
				insertJob(H,jobList[pos]);
				pos++;
				if(pos>n) break;
			}
		}
		if(!run)
		{
			// Runs whenever there is no job running. Complexity = O(NlogN)
			job *temp=new job;
			if(extractMinJob(H,temp)) ;
			else {current=*temp; run=1;}
			delete temp;
		}
		else
		{
			job *temp=new job;
			if(change) 
			{
				// Whenever a new element is added to the heap, it checks with the current running job. 
				// Complexity = O(NlogN) as it runs at max N times.
				if(!extractMinJob(H,temp))
				{
					if((temp->remLength < current.remLength)||(temp->remLength==current.remLength && temp->jobId<current.jobId)) 
    					{
						insertJob(H,current);
						current=*temp;
					}
					else insertJob(H,*temp);
				}
			}
			delete temp;			
		}
		if(run) if(start(current)) turnaround+=time-current.startTime;
		if(run) current.remLength-=1;
		if(run) cout<<current.jobId<<" ";
		else cout<<"-1 ";
		if(run) 
		{
			if(current.remLength<=0) 
			{
				run=0;
				int temp = bsearch(current.jobId,pairList,m);  
				//Runs everytime a job ends. Complexity = O(NlogM) = O(NlogN)
				if(temp!=-1)
				{
					// The loop runs at max M times overall. It checks multiple jobid_to's. Complexity = O(M). 
					while(pairList[temp].jobid_from==current.jobId)
					{
						if(start(H->list[pairList[temp].jobid_to])) {decreaseKey(H,pairList[temp].jobid_to);}
						temp++;
						if(temp>=m) break;
					}
				}
			}
		}
		time+=1;
	}
	cout<<"\nThe average turaround time is "<<(turnaround*1.0)/n<<"\n";
	// => Total Complexity = O(Nlog(N)) 
}

int main() 
{
	cout<<"Enter the number of inputs:- "; 
	int n;
	cin>>n;
	job *list = new job[n+1];
	cout<<"Enter the jobs \n";
	for(int i=1;i<=n;i++)
	{
		job temp;
		cin>>temp.jobId>>temp.startTime>>temp.jobLength;
		temp.remLength=temp.jobLength;
		list[i]=temp;
	}
	cout<<"Enter the number of dependency pairs:- ";
	int m;
	cin>>m;
	jobpair *pairs=new jobpair[m];
	cout<<"Enter the dependency pairs \n";
	for(int i=0;i<m;i++)
	{
		jobpair temp;
		cin>>temp.jobid_from>>temp.jobid_to;
		pairs[i]=temp;
	}
	newScheduler(list,n,pairs,m);
	return 0;
}
