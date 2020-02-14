#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/socket.h>
#include<arpa/inet.h>
#include<netinet/in.h>

#define SERVER_PORT 9001
#define CLIENT_PORT 8990 
#define MAXLINE 1000

int main()
{
    // Create socket
    int sockfd = socket(AF_INET, SOCK_STREAM, 0);
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

    // Connect to server
    if( connect(sockfd, (const struct sockaddr *)&server, sizeof(server)) < 0)
    {
        printf("Cannot establish connection\n");
        exit(EXIT_FAILURE);
    }
    
    // Get the subdirectory for the request
    char send_b[MAXLINE], recv_b[MAXLINE];
    printf("Enter the subdirectory name:- ");
    scanf("%[^\n]",send_b);

    // Send the request to the server
    send(sockfd, send_b, sizeof(send_b), 0);

    int img_cnt = 0;
    while(1)
    {
        // Read the image_size
        int img_size;
        read(sockfd, &img_size, sizeof(int));

        //If not a directory
        if( img_size == -1)
        {
            printf("Not a directory with images\n");
            close(sockfd);
            exit(EXIT_FAILURE);
        }

        // Read the image
        while(img_size)
            img_size -= read(sockfd, recv_b, (img_size<MAXLINE)?img_size:MAXLINE);
            
        // Increase the image count
        img_cnt++;

        // Check for end of images
        char buff[100];
        read(sockfd, buff, 3);
        buff[3] = '\0';

        // If end, print and exit
        if(!strcmp(buff,"END"))
        {
            printf("Image Count: %d\n",img_cnt);
            close(sockfd);
            exit(EXIT_SUCCESS);
        }
    }
}