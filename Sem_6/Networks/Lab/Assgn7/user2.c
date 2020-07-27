#include<stdio.h>
#include<unistd.h>
#include<stdlib.h>
#include<string.h>
#include<arpa/inet.h>
#include<netinet/in.h>

#include "rsocket.h"

#define MY_PORT 30022

int main(int argc, char *argv[])
{
    char input[100];

    struct sockaddr_in mine, other;
    mine.sin_family = AF_INET;
    mine.sin_addr.s_addr = INADDR_ANY;
    mine.sin_port = htons(MY_PORT);

    int sockfd = r_socket(AF_INET, SOCK_MRP, 0);
    if(sockfd < 0)
    {
        printf("Socket creation failed\n");
        exit(EXIT_FAILURE);
    }

    if(r_bind(sockfd, (struct sockaddr *)&mine, sizeof(mine)) < 0)
    {
        printf("Bind failed\n");
        exit(EXIT_FAILURE);
    }

    int cnt=0;
    while(1)
    {
        cnt++;
        socklen_t size;
        int te = r_recvfrom(sockfd, input, 100, 0, (struct sockaddr *)&other, &size);
        input[te] = '\0';
        printf("letter %d:- %s : From %s:%d\n", cnt, input, inet_ntoa(other.sin_addr), ntohs(other.sin_port));
    }
}