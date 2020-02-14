#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/socket.h>
#include<arpa/inet.h>
#include<netinet/in.h>

#define SERVER_PORT 9001
#define CLIENT_PORT 8991
#define MAXLINE 1000

int main()
{
    // Create socket
    int sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if(sockfd < 0)
    {
        printf("Error creating socket\n");
        exit(EXIT_FAILURE);
    }

    // Configure the server and current address
    struct sockaddr_in server, client;

    server.sin_family = AF_INET;
    server.sin_addr.s_addr = INADDR_ANY;
    server.sin_port = htons(SERVER_PORT);

    client.sin_family = AF_INET;
    client.sin_addr.s_addr = INADDR_ANY;
    client.sin_port = htons(CLIENT_PORT);

    // Bind the socket to the address
    if( bind(sockfd, (const struct sockaddr *)&client, sizeof(client)) < 0)
    {
        printf("Bind failure\n");
        exit(EXIT_FAILURE);
    }

    // Get the domain name for query
    char send_b[MAXLINE], recv_b[MAXLINE];
    printf("Enter the domain name:- ");
    scanf("%[^\n]",send_b); 

    // Send the request to the server
    sendto(sockfd, send_b, sizeof(send_b), 0, 
        (const struct sockaddr *)&server, (socklen_t)sizeof(server));

    // Receive the ip address of the requested domain
    int si = recvfrom(sockfd, recv_b, sizeof(recv_b), 0,
                NULL, NULL);
    recv_b[si] = '\0';
    
    printf("IP: %s\n", recv_b);
    close(sockfd);
}