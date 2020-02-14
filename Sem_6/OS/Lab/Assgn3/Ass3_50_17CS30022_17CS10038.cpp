#include<bits/stdc++.h>
#include<unistd.h>
#include<sys/wait.h>
#include<sys/shm.h>
#include<sys/ipc.h>
#include<time.h>
#include<signal.h>
#include<pthread.h>

using namespace std;

#define P_SIZE 8
#define JSIZE 15

// Structure for storing jobs
struct job{

	pid_t prod_id; // The process id of the producer
	int prod_no; // Producer number
	int priority; // Priority of the job
	int time;  // Computing time
	int job_id; // Job ID

	// Dummy constructor
	job(){}

	// Constructor for the job
	job(pid_t a, int b, int c, int d, int e)
	{
		prod_id = a, prod_no = b, priority =c, time = d, job_id = e;
	}
};

// Create a structure of different variables to be used in the shared memory
struct ShMwrapper{
	job jobs_queue[P_SIZE+1];
	int job_created, job_completed;
	int numJobs;
	pthread_mutex_t mutex;
};

// Compares two jobs. If x is more priorotized, it returns 1, else 0
bool compare(ShMwrapper *H,int x, int y)
{
    job job1=H[0].jobs_queue[x],job2=H[0].jobs_queue[y];
    if(job1.priority > job2.priority)  // Prioritize jobs with higher priority
		return 1;
    return 0;
}

// Makes the heap proper from bottom to top. Runs in O(logN)
void heapify_up(ShMwrapper *H, int pos)
{
	// Till it reaches the root
    while((pos/2)>0)
    {
        job par=H[0].jobs_queue[pos/2];
        job cur=H[0].jobs_queue[pos];
        if(compare(H,pos/2,pos)) 
			return;
        else
			H[0].jobs_queue[pos]=par, H[0].jobs_queue[pos/2]=cur;
        pos/=2;
    }
}

// Makes the heap proper from top to bottom. Runs in O(logN)
void heapify_down(ShMwrapper *H, int pos)
{
    int left = 2*pos, right = 2*pos+1, n = H[0].numJobs, smallest;
    if(left <= n)
        if(compare(H,left,pos)) 
			smallest=left;
        else 
			smallest=pos;
    else 
		smallest=pos;

    if(right <= n && compare(H,right,smallest))
		smallest=right;
    
    if(smallest != pos)
    {
        job temp=H[0].jobs_queue[smallest], temp1=H[0].jobs_queue[pos];
	    H[0].jobs_queue[smallest]=temp1, H[0].jobs_queue[pos]=temp;
        heapify_down(H, smallest);
    }
}

// Extracts the job and updates the position of all the jobs in the array.Runs in O(logN).
int retrieve(ShMwrapper *H,job *j)
{
	// When queue is empty
    if(H[0].numJobs == 0) 
		return -1;

    *j = H[0].jobs_queue[1];	// Remove the top job

	// Order the priority queue
    H[0].jobs_queue[1] = H[0].jobs_queue[H[0].numJobs], H[0].numJobs--;
    heapify_down(H,1);

    return 0;
}

// Insert a new job according to the priority in the priority queue
int insertJob(ShMwrapper *H, job j)
{
	// When queue is full
	if(H[0].numJobs == P_SIZE) 
		return -1;

    H[0].numJobs += 1;	// Increase the job count
    H[0].jobs_queue[H[0].numJobs] = j; // Insert the job
    heapify_up(H, H[0].numJobs);  // Order the queue

	return 0;
}

// Function to access the shared memory
int accessMemory(ShMwrapper *H, int ch, job *jp = NULL)
{
	pthread_mutex_lock(&(H[0].mutex));  // Lock the code
	
	// For insertion, return value -1 when queue is full
	if(ch == 0)
	{
		pthread_mutex_unlock(&(H[0].mutex));
		return insertJob(H, *jp);
	}

	// For retrieving, return value -1 when queue is empty
	else if(ch == 1)
	{
		pthread_mutex_unlock(&(H[0].mutex));
		return retrieve(H, jp);
	}

	// Update jobs created
	else if(ch == 2)
	{
		pthread_mutex_unlock(&(H[0].mutex));
		return H[0].job_created += 1;
	}

	// Update jobs completed
	else if(ch == 3)
	{
		pthread_mutex_unlock(&(H[0].mutex));
		return H[0].job_completed += 1; 
	}

	// Retrieve jobs completed
	else if(ch == 4)
	{
		pthread_mutex_unlock(&(H[0].mutex));
		return H[0].job_completed;  
	}

	pthread_mutex_unlock(&(H[0].mutex));
	return -1;
}

void print(job j)
{
	cout<<"Producer: "<<j.prod_no<<", Producer PID: "<<j.prod_id<<", ";
	cout<<"Priority: "<<j.priority<<", Compute Time: "<<j.time<<", ";
	cout<<"Job ID: "<<j.job_id<<endl;
}

int main()
{
	// Take NP and NC inputs
	int NP, NC;
	cout<<"Number of producers (NP):- ";
	cin>>NP;
	cout<<"Number of consumers (NC):- ";
	cin>>NC;

	// Create a shared memory to store the structure with our variables
	int shmid = shmget(IPC_PRIVATE, sizeof(ShMwrapper), 0700|IPC_CREAT);
	if(shmid < 0)
	{
		cout<<"Shared Memory creation error"<<endl;
		exit(EXIT_FAILURE);
	}

	// Attaching it to a physical address, get the structure pointer as a way to identify the data
	ShMwrapper *ShMem = (ShMwrapper *)shmat(shmid, NULL, 0);

	// Initialise the data and mutexes
	ShMem[0].numJobs = ShMem[0].job_created = ShMem[0].job_completed = 0; 
	pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    pthread_mutexattr_setpshared(&attr, PTHREAD_PROCESS_SHARED);
    pthread_mutex_init(&(ShMem[0].mutex), &attr);

	// Create the consumer processes
	for(int i=1; i <= NC; i++)
	{
		pid_t Cid = fork();
		if( Cid == 0 )
		{
			srand(time(NULL) ^ (getpid()<<16));  // Seed the random generator
			pid_t id = getpid();  // Gets the process id
			while(true)
			{
				sleep(rand() % 4);  // Sleeps for random time between 0 and 4
				
				// Perform the retrieve every untill a job is retrieved, every 10ms
				job hp;
				while(accessMemory(ShMem, 1, &hp) == -1)
					usleep(10000);

				// Print the details of the job
				cout<<"Consumer: "<<i<<", Consumer PID: "<<id<<", ";
				print(hp);

				accessMemory(ShMem, 3); // Increase the count of completed jobs
				sleep(hp.time); // Compute the job, sleep for that amount
			}
			exit(EXIT_SUCCESS);
		}
	}

	// Create the producer processes
	for(int i=1; i <= NP; i++)
	{
		pid_t Pid = fork(); // Create a child process for the producer i
		if( Pid == 0 )
		{
			srand(time(NULL) ^ (getpid()<<16));  // Seed the random generator
			pid_t id = getpid();  // Gets the process id
			while(true)
			{
				job gen(id, i, (rand() % 10) + 1, (rand() % 4) + 1, (rand() % 100000) + 1);  // Create a job
				sleep(rand() % 4);  // Sleep for random time between 0 and 4

				// Try inserting the job into queue every 10ms untill the queue is not full
				while(accessMemory(ShMem, 0, &gen) == -1)
					usleep(10000);

				accessMemory(ShMem, 2); // Increase the job created count
				print(gen);
			}
			exit(EXIT_SUCCESS);
		}
	}

	clock_t st = clock(), en;
	double time = 0;

	// Run till required jobs has reached
	while(true)
	{
		usleep(10000); // sleep for 1 second
		time += 0.01;

		// If required jobs are reached ( checks every second )
		if(accessMemory(ShMem,4) >= JSIZE)
		{
			en = clock(); 
			time += ((double)(en - st)) / CLOCKS_PER_SEC ; // calculate time taken
			cout<<setprecision(3)<<fixed<<"TIME TAKEN:- "<<time<<" s"<<endl; // output time taken 
			kill(-getpid(), SIGQUIT); // quit all processes (parent and children)
		}
	}
}