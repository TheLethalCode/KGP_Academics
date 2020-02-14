#include<stdio.h>
#include<unistd.h>
#include<netdb.h>
#include<string.h>
#include<stdlib.h>
#include<dirent.h>
#include<fcntl.h>
#include<sys/socket.h>
#include<sys/select.h>
#include<sys/types.h>
#include<arpa/inet.h>
#include<netinet/in.h>

#define SERVER_PORT 9001
#define MAXLINE 1000

int main()
{
    // Create sockets for both protocols and check for failure
    int sockfd_udp = socket(AF_INET, SOCK_DGRAM, 0),
            sockfd_tcp = socket(AF_INET, SOCK_STREAM, 0);
    if(sockfd_udp < 0 | sockfd_tcp < 0)
    {
        printf("Error creating socket\n");
        exit(EXIT_FAILURE);
    }

    // Configure the server address
    struct sockaddr_in server, client;
    socklen_t size=sizeof(client);
    server.sin_family = AF_INET;
    server.sin_addr.s_addr = INADDR_ANY;
    server.sin_port = htons(SERVER_PORT);

    // Bind the sockets to the address
    if( bind(sockfd_udp, (const struct sockaddr *)&server, sizeof(server)) < 0 
                || bind(sockfd_tcp, (const struct sockaddr *)&server, sizeof(server)) < 0 )
    {
        printf("Bind failure\n");
        exit(EXIT_FAILURE);
    }

    // Listen for TCP connections
    listen(sockfd_tcp, 10);

    // Maximum file descriptor
    int maxfd = sockfd_tcp < sockfd_udp ? sockfd_udp : sockfd_tcp;

    // Initialise fd_set
    fd_set fdSet;
    FD_ZERO(&fdSet);

    while(1)
    {
        // Include the sockets for tcp and udp in select
        FD_SET(sockfd_tcp, &fdSet), FD_SET(sockfd_udp, &fdSet);
        
        // Wait for socket ready to be read
        select(maxfd+1, &fdSet, NULL, NULL, NULL);

        // Handle new tcp connection
        if(FD_ISSET(sockfd_tcp, &fdSet))
        {

            struct sockaddr_in client;
            socklen_t size=sizeof(client);
            char send_b[MAXLINE], recv_b[MAXLINE];
            
            // Handle the new connectionn
            if(fork() == 0)
            {
                // Accept the new connection
                int new_sockfd = accept(sockfd_tcp, (struct sockaddr *)&client, &size);

                printf("Established connection with client %s:%d\n",
                            inet_ntoa(client.sin_addr), ntohs(client.sin_port));

                // Wait for the request                
                int si = recv(new_sockfd, recv_b, MAXLINE, 0);
                recv_b[si] = '\0';
                printf("Requested for directory %s\n", recv_b);

                // Open the directory
                DIR *dr = opendir(recv_b);

                // If invalid dir name
                if(dr == NULL)
                {
                    int size = -1;
                    write(new_sockfd, &size, sizeof(int));
                    printf("Not a directory with images\n");
                    exit(EXIT_FAILURE);
                }
                else
                {
                    struct dirent *dir;
                    char dir_name[MAXLINE];
                    strcpy(dir_name, recv_b);
                    strcat(dir_name, "/");

                    int fl = 0;

                    // Go through the directory
                    while( (dir = readdir(dr)) != NULL )
                    {
                        if(!strcmp(dir->d_name,".") || !strcmp(dir->d_name,".."))
                            continue;

                        // Generate the file name
                        char file_name[MAXLINE];    
                        strcpy(file_name, dir_name);
                        strcat(file_name, dir->d_name);
                        
                        // Check whether it is a file or not
                        if( opendir(file_name) != NULL)
                            continue;

                        // Send indicator indicating end of 1 image
                        if(fl)
                        {
                            bzero(send_b, MAXLINE);
                            strcpy(send_b, "&&&"); 
                            write(new_sockfd, send_b, 3); 
                        }
                        fl = 1;

                        printf("Sending %s\n", file_name);

                        // Open the file
                        int fd = open(file_name, O_RDONLY);

                        // Find the size of the image 
                        int size = lseek(fd,0,SEEK_END);
                        lseek(fd,0,SEEK_SET);

                        // Send the file size
                        write(new_sockfd, &size, sizeof(int));
                        
                        // Send the contents of file till EOF
                        int k;
                        while( k = read(fd, send_b, MAXLINE-1) )
                            write(new_sockfd, send_b, k);

                        // Close the file
                        close(fd); 
                    }

                    // Send END after sending all images in directory
                    if(fl)
                    {
                        bzero(send_b, MAXLINE);
                        strcpy(send_b, "END");
                        write(new_sockfd, send_b, 3);
                    }
                    // If the request is not a directory
                    else
                    {   
                        int size = -1;
                        write(new_sockfd, &size, sizeof(int));   
                        printf("Not a directory with images\n");
                    }

                    // Close socket
                    close(new_sockfd); 
                }
            }
        }

        // Handle new UDP connection
        else
        {
            struct sockaddr_in client;
            socklen_t size=sizeof(client);
            char send_b[MAXLINE], recv_b[MAXLINE];

            // Receive request from dnsclient
            int si = recvfrom(sockfd_udp, recv_b, sizeof(recv_b), 0,
                                    (struct sockaddr *)&client, &size);
            recv_b[si] = '\0';
            printf("Requested IP for domain %s\n", recv_b);

            // Retrieve the IP for the domain
            struct hostent *ipNetworkByte = gethostbyname(recv_b);

            // Convert the ip to the required format
            if(ipNetworkByte == NULL)
                strcpy(send_b, "Invalid Domain");

            else
                strcpy(send_b, 
                    inet_ntoa(*(struct in_addr *)(ipNetworkByte->h_addr_list[0])));

            // Send it back to the client
            sendto(sockfd_udp, send_b, sizeof(send_b), 0,
                    (const struct sockaddr *)&client, size);
        }
    }
    close(sockfd_udp);
    close(sockfd_tcp);
}