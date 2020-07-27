#ifndef RSOCKET_H
#define RSOCKET_H

#include<stdlib.h>
#include<sys/socket.h>

// Timer defines
#define INTERVAL 2 
#define T 2

// Drop probability
#define P 0.25

// Type of message
#define ACK 0
#define APP 1

// Socket type
#define SOCK_MRP 40

// Max function
#define max(a,b) a<b?b:a

// Functions available to user

int r_socket(int domain, int type, int protocol);

int r_bind(int socket, const struct sockaddr *address, socklen_t address_len);

int r_sendto(int socket, const void *message, size_t length, 
        int flags, const struct sockaddr *dest_addr, socklen_t dest_len);

ssize_t r_recvfrom(int socket,  void * restrict buffer, size_t length, 
        int flags, struct sockaddr * restrict address, socklen_t * restrict address_len);

int r_close(int socket);

int dropMessage(float p);

#endif