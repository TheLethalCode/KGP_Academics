#include<bits/stdc++.h>
#include<unistd.h>
#include<stdlib.h>
#include<signal.h>
#include<time.h>

using namespace std;

#define QUANTA 1
#define MAX_NUM 1000

queue< int > sharedBuffer;
int N,M;
pthread_mutex_t mutexLock;
int reportCntr = -1, reportAlive = 1; // For the reporter

// Structure to store the status of all the threads
struct STATUS {
    vector<pthread_t> thread_no;  // Storing the thread number to send signals
    vector<bool> run, alive;  // To check to see which thread is running and which are alive
    string worker; // Whether P or C
}stat;

// Signal handling function
void sigusr_handle(int sig)
{
    // If sending the thread to sleep, wait for SIGUSR2 to wake it up.
    if(sig == SIGUSR1)
    {
        // Create mask with signal SIGUSR1
        sigset_t mask1;
        sigemptyset(&mask1), sigaddset(&mask1, SIGUSR1);

        // Waits for any signal other than SIGUSR1 that is not ignored. Essentially SIGUSR2 in our case.
        sigsuspend(&mask1);  
    }
}

// Function used to access the shared buffer
void bufferMan(int ch, int *inOut)
{
    pthread_mutex_lock(&mutexLock); // Lock the code
    // Queue size
    if(ch == 0)
    {
        *inOut = sharedBuffer.size();
        pthread_mutex_unlock(&mutexLock); // Unlock it and return
        return;
    }

    // Integer insertion
    else if(ch == 1)
    {
        sharedBuffer.push(*inOut);
        pthread_mutex_unlock(&mutexLock); // Unlock it and return
        return;
    }

    // Integer removal
    else if(ch == 2)
    {
        *inOut = sharedBuffer.front();
        sharedBuffer.pop();
        pthread_mutex_unlock(&mutexLock); // Unlock it and return
        return;
    }
}

// Producer routine
void *producerRoutine(void *args)
{
    // The thread number
    int thdno = *((int *)args);

    // Mask for SIGUSR1 signal
    sigset_t mask;
    sigemptyset(&mask);sigaddset(&mask, SIGUSR1);

    usleep(1000); // Initial wait

    // Generate 1000 pseudo random numbers
    for(int i=0; i<MAX_NUM ;i++)
    {
        // Get the queue size
        int size;
        pthread_sigmask(SIG_BLOCK, &mask, NULL);  // BLOCK SIGUSR1
        bufferMan(0, &size);
        pthread_sigmask(SIG_UNBLOCK, &mask, NULL); // UNBLOCK SIGUSR1

        // If the queus is full
        if( size == M )
        {
            i--;
            continue;
        }

        // Insert the random number
        int num = rand();
        pthread_sigmask(SIG_BLOCK, &mask, NULL);  // BLOCK SIGUSR1
        bufferMan(1, &num);
        pthread_sigmask(SIG_UNBLOCK, &mask, NULL); // UNBLOCK SIGUSR1

        // cout<<"THREAD "<<thdno<<": Inserting "<<num<<endl;
    }
    stat.alive[thdno] = false; // Change the thread status
    return NULL;
}

// Consumer routine
void *consumerRoutine(void *args)
{
    // The thread no.
    int thdno = *((int *)args);
    
    // Mask for SIGUSR1 signal
    sigset_t mask;
    sigemptyset(&mask);sigaddset(&mask, SIGUSR1);
    
    usleep(1000); // Initial wait
    while(true)
    {
        // Get the queue size
        int size;
        pthread_sigmask(SIG_BLOCK, &mask, NULL);  // BLOCK SIGUSR1
        bufferMan(0, &size);
        pthread_sigmask(SIG_UNBLOCK, &mask, NULL); // UNBLOCK SIGUSR1

        // If queue is empty, do nothing
        if( size == 0 )
            continue;

        // Remove from queue
        int num;
        pthread_sigmask(SIG_BLOCK, &mask, NULL);  // BLOCK SIGUSR1
        bufferMan(2, &num);
        pthread_sigmask(SIG_UNBLOCK, &mask, NULL); // UNBLOCK SIGUSR1

        // cout<<"THREAD "<<thdno<<": Removing "<<num<<endl;
    }
    stat.alive[thdno] = false; // Change the thread status
    return NULL;
}

// Function for the scheduler
void *schedulerRoutine(void *args)
{
    usleep(1000);  // Initializing time
    int i = 0, cnt = 0; // Start with the first thread

    // Run while at least one thread is not dead
    while(cnt < N)
    {
        // Goto a thread that isnt dead
        while(!stat.alive[i])  
            i = (i + 1) % N;

        // Reporter thread inform of context switch and add context switch overhead
        reportCntr = i;
        usleep(1000);

        // Wake up that thread
        pthread_kill(stat.thread_no[i], SIGUSR2);

        // Run untill the thread dies or the time quanta expires
        clock_t now = clock();
        while(stat.alive[i] & ((double)(clock() - now))/CLOCKS_PER_SEC < QUANTA);

        // If the thread is dead, increase the dead count
        if(!stat.alive[i]) 
            cnt++, reportAlive = 0;

        // Otherwise, send a signal to the thread to put the thread to sleep
        else 
            pthread_kill(stat.thread_no[i], SIGUSR1);
        i = (i + 1) % N;
    }

    return NULL;
}

// Function for the reporter thread
void *reporterRoutine(void *args)
{
    int val;
    while(true)
    {
        while(reportCntr==-1); // Wait till a thread is woken up

        if(!reportAlive) // If the previous thread is terminated
            cout<<"REPORTER: Thread "<<val<<"("<<stat.worker[val]<<") terminated."<<endl;

        // Reinitialise the values
        val = reportCntr;
        reportCntr = -1;
        reportAlive = 1;

        // Print the context switch
        cout<<"REPORTER: Thread "<<val<<"("<<stat.worker[val]<<") switched in."<<endl;
        cout<<"REPORTER: Buffer size = "<<sharedBuffer.size()<<endl;   
    }
}

int main(int argc, char *argv[])
{

    // Set signal handlers for the user defined signals
    signal(SIGUSR1, sigusr_handle);
    signal(SIGUSR2, sigusr_handle);

    // Block SIGUSR2 when thread is alive
    sigset_t mask;
    sigemptyset(&mask), sigaddset(&mask, SIGUSR2);
    sigprocmask(SIG_BLOCK, &mask, NULL);


    // Get the inputs and check their validity.
    cout<<"Enter N (no. of threads):- ";
    cin>>N;
    if(N < 2)
    {
        cout<<"N has to be at least 2"<<endl;
        exit(EXIT_FAILURE);
    }

    cout<<"Enter M (buffer capacity):- ";
    cin>>M;
    if(M < 1)
    {
        cout<<"M has to be at least 1"<<endl;
        exit(EXIT_FAILURE);
    }

    // Initialise random variable generator and mutex lock
    srand((unsigned)time(0));
    pthread_mutex_init(&mutexLock, NULL);

    // Initialise STATUS with all threads as sleeping, non-terminated.
    stat.thread_no.resize(N, 0);
    stat.run.resize(N,false), stat.alive.resize(N, true);
    stat.worker = "";

    // Create N worker threads and put them to sleep initially. Assign their type in STATUS
    int x[N];
    for(int i=0;i<N;i++) x[i] = i;
    pthread_create(&stat.thread_no[0], NULL, &producerRoutine, x), pthread_kill(stat.thread_no[0], SIGUSR1), stat.worker += 'P';
    pthread_create(&stat.thread_no[1], NULL, &consumerRoutine, x+1), pthread_kill(stat.thread_no[1], SIGUSR1), stat.worker += 'C';
    for(int i=2; i<N;i++)
    {
        // Create both producer and consumer threads
        if(rand() % 2)
        {
            pthread_create(&stat.thread_no[i], NULL, &producerRoutine, x+i);
            pthread_kill(stat.thread_no[i], SIGUSR1);
            stat.worker += 'P';
        }
        else
        {
            pthread_create(&stat.thread_no[i], NULL, &consumerRoutine, x+i);
            pthread_kill(stat.thread_no[i], SIGUSR1);
            stat.worker += 'C';
        }
    }

    // Create the Scheduler thread
    pthread_t scheduler;
    pthread_create(&scheduler, NULL, &schedulerRoutine, NULL);

    // Create the Reporter thread
    pthread_t reporter;
    pthread_create(&reporter, NULL, &reporterRoutine, NULL);

    // Wait for all the threads completion
    pthread_join(scheduler, NULL);
    pthread_join(reporter, NULL);
    
    cout<<"MAIN: NO MORE PRODUCERS!!DONE!"<<endl;
    return 0;
}