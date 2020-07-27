#include<stdio.h>
#include<unistd.h>
#include<stdlib.h>
#include<string.h>
#include<arpa/inet.h>
#include<netinet/in.h>

#include "rsocket.h"

#define OTHER_PORT 30022
#define MY_PORT 30023

int main(int argc, char *argv[])
{
    char input[100];
    scanf("%s", input);
    int n = strlen(input);
    printf("%d letter word\n", n);

    struct sockaddr_in mine, other;
    mine.sin_family = AF_INET;
    mine.sin_addr.s_addr = INADDR_ANY;
    mine.sin_port = htons(MY_PORT);

    other.sin_family = AF_INET;
    other.sin_addr.s_addr = INADDR_ANY;
    other.sin_port = htons(OTHER_PORT);

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

    for(int i=0;i<n;i++)
    {
        r_sendto(sockfd, input + i, 1, 0, (struct sockaddr *)&other, sizeof(other));
    }
    for(;;);
}