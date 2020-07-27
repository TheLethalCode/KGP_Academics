#include<unistd.h>
#include<string.h>
#include<stdio.h>

#include<signal.h>
#include<errno.h>
#include<time.h>
#include<sys/time.h>
#include<arpa/inet.h>

#include "rsocket.h"

// Maximum message buffer
#define MAXLINE 1024

const int _size = 100;  // The size of the tables
int _count = 0;     // Variable to evaluate the number of tries to send the complete message

// Structure for storing message
struct data{
    int msg_len;
    void *msg;
};

// Structure for storing sending packet
struct sendPacket{
    struct sockaddr_in to;
    int type;
    int seq_id;
    struct data d;
};

// Structure for storing received packets
struct recvPacket{
    struct sockaddr_in from;
    struct data d;
};

// Element of unACK Table
struct unAckPacket{
    time_t t;
    struct sendPacket p;
};

// Sending Buffer
struct sendBuffer{
    int front;
    int end;
    int size;
    struct sendPacket **p;
};

// Receiving buffer
struct recvBuffer{
    int front;
    int end;
    int size;
    struct recvPacket **p;
};

// unACKTable
struct unAckTable{
    int size;
    struct unAckPacket **p;
};

// Received IDs structure
struct recvIDs{
    int size;
    int *IDs;
};

struct sendBuffer *_sB;   // Buffer of data packets to be sent
struct recvBuffer *_rB;   // Buffer of unique packets received
struct unAckTable *_aT;   // A table of unACKed packets
struct recvIDs *_recv;   // A table of packets whose packets have been received

int _socket = -1;   // The socket fd

// A function to generate the drop probability by generating a random number
int dropMessage(float p)
{
    float val = (float)rand()/RAND_MAX ;
    if (val < p)
        return 1;
    return 0;
}

// Initialise data.
void initData(struct data *obj, const void *msg, int msg_len)
{
    obj->msg_len = msg_len;
    obj->msg = malloc(msg_len);
    memcpy(obj->msg, msg, msg_len);
}

// Initialise the sending packet
void initSendPacket(struct sendPacket *obj, struct sockaddr_in to, 
                            int type, int seq_id, struct data msg)
{
    obj->to = to;
    obj->type = type;
    obj->seq_id = seq_id;
    obj->d = msg;
}

// Initialise the sending Buffer
void initSendBuffer(struct sendBuffer *obj)
{
    obj->size = 0;
    obj->p = (struct sendPacket **)malloc(_size * sizeof(struct sendPacket *));
    for(int i=0 ;i < _size; i++)
        obj->p[i] = NULL;
    obj->front = obj->end = -1;
}

// Add a packet to the sending buffer
void addToSendBuff(struct sendPacket *packet)
{
    // Case of empty buffer
    if(_sB->front == -1)
        _sB->front = _sB->end = 0;

    // All other case
    else
        _sB->end = (_sB->end + 1) % _size;

    _sB->p[_sB->end] = packet;
    _sB->size++;
}

// Extract a packet from send buffer
void removeFromSendBuff(struct sendPacket **packet)
{
    *packet = _sB->p[_sB->front];
    // Only one element is remaining
    if(_sB->front == _sB->end)
        _sB->front = _sB->end = -1;

    // Other cases
    else
        _sB->front = (_sB->front + 1) % _size;
    _sB->size--;
}

// Free the memory from send buffer
void freeSendBuff(struct sendBuffer *obj)
{
    free(obj->p);
    free(obj);
}

// Initialise the receiving packet
void initRecvPacket(struct recvPacket *obj, struct sockaddr_in from, struct data msg)
{
    obj->from = from;
    obj->d = msg;
}

// Initialise the receiving buffer
void initRecvBuffer(struct recvBuffer *obj)
{
    obj->size = 0;
    obj->p = (struct recvPacket **)malloc(_size * sizeof(struct recvPacket *));
    for(int i=0;i<_size;i++)
        obj->p[i] = NULL;
    _rB->front = _rB->end = -1;
}

// Add a packet to the receiving buffer
void addToRecvBuff(struct recvPacket *packet)
{
    // Case of empty buffer
    if(_rB->front == -1)
        _rB->front = _rB->end = 0;

    // All other case
    else
        _rB->end = (_rB->end + 1) % _size;

    _rB->p[_rB->end] = packet;
    _rB->size++;
}

// Extract a packet from receiving buffer
void removeFromRecvBuff(struct recvPacket **packet)
{
    *packet = _rB->p[_rB->front];
    // Only one element is remaining
    if(_rB->front == _rB->end)
        _rB->front = _rB->end = -1;

    // Other cases
    else
        _rB->front = (_rB->front + 1) % _size;

    _rB->size--;
}

// Free the receiving buffer
void freeRecvBuff(struct recvBuffer *obj)
{
    free(obj->p);
    free(obj);
}

// Initialise element of unACK Table
void initUnAckPacket(struct unAckPacket *unPacket, struct sendPacket packet)
{
    unPacket->t = time(NULL);
    unPacket->p = packet;
}

// Initialise the unACK Table
void initUnAckTable(struct unAckTable *obj)
{
    obj->size = 0;
    obj->p = (struct unAckPacket **)malloc(_size * sizeof(struct unAckTable *));
    for(int i=0;i<_size;i++)
        obj->p[i] = NULL;
}

// Add element to unACK Table
void addToUnAckTable(struct unAckPacket *packet)
{
    for(int i=0;i<_size;i++)
    {
        if(_aT->p[i] == NULL)
        {
            _aT->p[i] = packet;
            break;
        }
    }
    _aT->size++;
}

// Search and Remove packet corresponding to seq_id
int removeFromUnAckTable(int seq_id)
{
    if(!(_aT->size))
        return -1;
    for(int i=0;i < _size;i++)
    {
        if( _aT->p[i] == NULL)
            continue;
        if(_aT->p[i]->p.seq_id == seq_id)
        {
            free(_aT->p[i]);
            _aT->p[i] = NULL;
            _aT->size--;
            return 0;
        }
    }
    return -1;
}

// Free UnAck Table
void freeUnAckTable(struct unAckTable *obj)
{
    free(obj->p);
    free(obj);
}

// Initialise the receive ID table
void initRecvIDs(struct recvIDs *obj)
{
    obj->size = 0;
    obj->IDs = (int *)malloc(5 * _size * sizeof(int));
    for(int i=0;i<_size;i++)
        obj->IDs[i] = -1;
}

// Search and Add receive ID if not there
int addIDtoRecvIDs(int seq_id)
{
    for(int i=0;i<_recv->size;i++)
        if(_recv->IDs[i] == seq_id)
            return -1;
    
    _recv->IDs[_recv->size++] = seq_id;
    return 0;
}

// Free receive ID Table
void freeRecvIDs(struct recvIDs *obj)
{
    free(obj->IDs);
    free(obj);
}

// Encode the sendPacket structure into a character array
void encodeMessage(struct sendPacket *p, void *msg, int *rec)
{
    int cur = 0;
    memcpy(msg+cur, &(p->to), sizeof(p->to)), cur += sizeof(p->to);
    memcpy(msg+cur, &(p->type), sizeof(p->type)), cur += sizeof(p->type);
    memcpy(msg+cur, &(p->seq_id), sizeof(p->seq_id)), cur += sizeof(p->seq_id);
    memcpy(msg+cur, &(p->d.msg_len), sizeof(p->d.msg_len)), cur += sizeof(p->d.msg_len);
    if(p->d.msg_len)
        memcpy(msg+cur, p->d.msg, p->d.msg_len), cur += p->d.msg_len;
    *rec = cur;
}

// Decode the character array back to a sendPacket structure
int decodeMessage(struct sendPacket *p, void *msg, int rec)
{
    int cur = 0;
    memcpy(&(p->to), msg+cur, sizeof(struct sockaddr_in)), cur += sizeof(struct sockaddr_in);
    memcpy(&(p->type), msg+cur, sizeof(int)), cur += sizeof(int);
    memcpy(&(p->seq_id), msg+cur, sizeof(int)), cur += sizeof(int);
    memcpy(&(p->d.msg_len), msg+cur, sizeof(int)), cur += sizeof(int);

    // only if there is data
    if(p->d.msg_len)
    {
        p->d.msg = malloc(p->d.msg_len);
        memcpy(p->d.msg, msg+cur, p->d.msg_len), cur += p->d.msg_len;
    }
    if(rec != cur)
        return -1;
    return 0;
}

// Function to handle application message
void handleAppMsgRecv(struct sendPacket *packet, struct sockaddr_in *orig)
{
    // Drop the message if the receive buffer is full
    if(_rB->size == _size)
        return;

    // First time receiving the message, add it to receive buffer
    if( !addIDtoRecvIDs(packet->seq_id) )
    {
        struct recvPacket *p = (struct recvPacket *)malloc(sizeof(struct recvPacket));
        initRecvPacket(p, *orig, packet->d);
        addToRecvBuff(p);
    }

    // Send ACK
    // Initialise the ACK packet
    struct sendPacket *p = (struct sendPacket *)malloc(sizeof(struct sendPacket));
    p->to = *orig;
    p->seq_id = packet->seq_id;
    p->type = ACK;
    p->d.msg_len = 0;

    // Encode the message to char array
    void *msg = malloc(MAXLINE);
    int size;
    encodeMessage(p, msg, &size);

    // Send it to the origin untill properly sent
    while( sendto(_socket, msg, size, MSG_DONTWAIT,
                 (struct sockaddr *)orig, sizeof(*orig)) < 0)
                {
                    if(errno == EAGAIN || errno == EWOULDBLOCK)
                        break;
                }
    free(p);
}

// Function to handle ACK message
void handleACKMsgRecv(struct sendPacket *packet)
{
    removeFromUnAckTable(packet->seq_id);
}

// Handle received message, depending on whether they are ACK or not
void handleReceive()
{   
    char buff[MAXLINE];
    struct sockaddr_in orig;
    socklen_t size = sizeof(struct sockaddr_in);
    int rec;

    while( (rec = recvfrom(_socket, buff, MAXLINE, MSG_DONTWAIT, (struct sockaddr *)&orig, &size)) > 0)
    {   
        // Drop Probability
        if( dropMessage(P) )
            continue;

        struct sendPacket *new = (struct sendPacket *)malloc(sizeof(struct sendPacket));
        if( decodeMessage(new, buff, rec) < 0)
            return;

        if(new->type == APP)
            handleAppMsgRecv(new, &orig);
        else
            handleACKMsgRecv(new);
        free(new);
    }
}

// See if any message is timed out and resend it
void handleRetransmit()
{
    if( !_aT->size )
        return;
    for(int i=0, cnt = 0; i<_size & cnt<_aT->size; i++)
    {
        time_t t = time(NULL);
        if(_aT->p[i] != NULL)
        {
            if( (t - _aT->p[i]->t) >= T )   // Timeout condition
            {
                void *msg = malloc(MAXLINE);
                int size;
                encodeMessage(&(_aT->p[i]->p), msg, &size);

                // Handle sendto errors
                if( sendto(_socket, msg, size, MSG_DONTWAIT,
                        (const struct sockaddr *)&(_aT->p[i]->p.to), 
                                            sizeof(_aT->p[i]->p.to)) < 0 )
                        {
                            if(errno != EAGAIN && errno != EWOULDBLOCK)
                            {
                                cnt++;
                                continue;
                            }
                        }
                _count++;
                // printf("Send Count: %d\n", _count);
                _aT->p[i]->t = time(NULL);    // Reset time
            }
            cnt++;
        }
    }
}

// Send messages from send buffer if possible
void handleTransmit()
{
    // As long as possible
    while(_aT->size < _size && _sB->size >0)
    {
        struct sendPacket *packet;
        removeFromSendBuff(&packet);
        
        void *msg = malloc(MAXLINE);
        int size;
        encodeMessage(packet, msg, &size);
        
        // Handle incorrect arguments and interrupts
        if( sendto(_socket, msg, size, 0, 
                (const struct sockaddr *)&(packet->to), sizeof(packet->to)) < 0)
                {
                    if(errno != EAGAIN && errno != EWOULDBLOCK)
                        continue;
                }

        _count++;
        // printf("Send Count: %d\n", _count);

        // After sending add to unacknowledged packets
        struct unAckPacket *unPacket = (struct unAckPacket *)malloc(sizeof(struct unAckPacket));
        initUnAckPacket(unPacket, *packet);

        addToUnAckTable(unPacket);
    }
}

// Signal handler for handling  SIGALARM
void signalHandler(int signal)
{
    handleReceive();
    handleRetransmit();
    handleTransmit();
}

// Initialise everything
int init()
{
    // Seed the random engine
    srand((unsigned int)time(0));

    // Initialise the data tables and buffers
    _sB = (struct sendBuffer *)malloc(sizeof(struct sendBuffer));
    initSendBuffer(_sB);

    _rB = (struct recvBuffer *)malloc(sizeof(struct recvBuffer));
    initRecvBuffer(_rB);
    
    _aT = (struct unAckTable *)malloc(sizeof(struct unAckTable));
    initUnAckTable(_aT);

    _recv = (struct recvIDs *)malloc(sizeof(struct recvIDs));
    initRecvIDs(_recv);

    // Set up the signal handler
    if( signal(SIGALRM, signalHandler) < 0)
        return -1;

    // Set up timer
    struct itimerval *timer = (struct itimerval *)malloc(sizeof(struct itimerval));
    timer->it_value.tv_sec = INTERVAL;
    timer->it_value.tv_usec = 0;
    timer->it_interval.tv_sec = INTERVAL;
    timer->it_interval.tv_usec = 0;
    if( setitimer(ITIMER_REAL, timer, NULL) < 0)
        return -1;
    
    return 0;
}

// Initialise the socket
int r_socket(int domain, int type, int protocol)
{
    if(type != SOCK_MRP)
    {
        errno = EPROTOTYPE;
        return -1;
    }
    
    // Return -1 if init fails
    _socket = socket(domain, SOCK_DGRAM, protocol);
    if(_socket >= 0 && init() < 0)
    {
        close(_socket);
        return (_socket = -1);
    }
    return _socket;
}

// Bind the socket
int r_bind(int socket, const struct sockaddr *address, socklen_t address_len)
{
    return bind(socket, address, address_len);
}

// Send function, put the message into send buffer as long as there is space
int r_sendto(int socket, const void *message, size_t length, 
        int flags, const struct sockaddr *dest_addr, socklen_t dest_len)
{
    
    // For handling erroneous inputs
    if(socket != _socket)
        return -1;
    if(message == NULL || length == 0)
        return -1;
    if(dest_addr == NULL)
        return -1;
    
    // For the sequence number
    static int count = 0;
    
    struct data *msg = (struct data *)malloc(sizeof(struct data));
    initData(msg, message, length);
    
    struct sendPacket *packet = (struct sendPacket *)malloc(sizeof(struct sendPacket));
    initSendPacket(packet, *((const struct sockaddr_in *)dest_addr), APP, count, *msg);
    count++;

    // While the buffer is full
    while( _sB->size == _size)
        usleep(10);
    
    addToSendBuff(packet);
    return 0;
}

// Receive function, take the content from receive buffer or wait till content comes there
ssize_t r_recvfrom(int socket,  void * restrict buffer, size_t length, 
        int flags, struct sockaddr * restrict address, socklen_t * restrict address_len)
{
    // For handling erroneos inputs
    if(socket != _socket)
        return -1;
    if(buffer == NULL || length == 0)
        return -1;

    // While the receive buffer is empty
    while(!(_rB->size))
        usleep(100);
    
    struct recvPacket *packet = (struct recvPacket *)malloc(sizeof(struct recvPacket));
    removeFromRecvBuff(&packet);

    // Check for message overflow
    memcpy(buffer, packet->d.msg, max(packet->d.msg_len, length));
    
    if(address != NULL)
        memcpy(address, &(packet->from), sizeof(packet->from));

    if(address_len != NULL)
        *address_len = sizeof(packet->from);

    return max(packet->d.msg_len, length);
}

// Close the socket and free the memory
int r_close(int socket)
{
    if(close(socket) < 0)
        return -1;

    freeSendBuff(_sB);
    freeRecvBuff(_rB);
    freeUnAckTable(_aT);
    freeRecvIDs(_recv);
    return 0;
} 