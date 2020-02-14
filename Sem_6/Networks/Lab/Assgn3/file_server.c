#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<unistd.h>
#include<fcntl.h>
#include<errno.h>
#include<sys/stat.h>
#include<sys/types.h>
#include<sys/socket.h>
#include<arpa/inet.h>
#include<netinet/in.h>

#define SERVER_PORT 8490
#define MAXLEN 100 

// Create socket and return its id
int sockCreate()
{
	int sockd = socket(AF_INET, SOCK_STREAM, 0); // create socket with data stream packets
	if(sockd < 0)
	{
		printf("* Error creating socket\n");
		exit(EXIT_FAILURE);
	}
	return sockd;
}

// Bind socket to the specified address
void sockBind(int sockd)
{
	struct sockaddr_in server;

	// Configure the address of the server
	server.sin_family = AF_INET;
	server.sin_addr.s_addr = INADDR_ANY;
	server.sin_port = htons(SERVER_PORT);

	int temp = bind(sockd, (const struct sockaddr *)&server, sizeof(server)); // Bind
	if( temp < 0)
	{
		printf("* Binding failed\n");
		exit(EXIT_FAILURE);
	}
}

int main()
{
	int sockd = sockCreate(); // create socket
	sockBind(sockd); // bind it

	listen(sockd, 3); // queue upto 3 requesting connections

	// Variables to store the requesting client addresses
	struct sockaddr_in client;
	socklen_t sin_size = sizeof(client);

	char sendB[MAXLEN], recvB[MAXLEN];

	printf("Listening....\n");
	int sendSock = accept(sockd, (struct sockaddr *)&client, (socklen_t *)&sin_size); // Accept incoming connections

	// If there is any error in accepting connections
	if( sendSock < 0)
	{
		printf("* Connection failed\n");
		exit(EXIT_FAILURE);
	}
	
	// Print the ip of the established connection
	printf("* Established connection with %s:%d\n", inet_ntoa(client.sin_addr), ntohs(client.sin_port));

	// Receive the filename
	int n = recv(sendSock, (char *)recvB, sizeof(recvB), 0);
	recvB[n] = '\0';
	printf("* Request for file \"%s\" received.\n", recvB);

	int fd = open(recvB, O_RDONLY); // Try to open the file in read only mode

	// Check for the file presence
	if(fd < 0)
	{
		printf("* File not found.\n* Closing Connection.\n");
		close(sendSock); // Closing the socket
		close(sockd);
		exit(EXIT_FAILURE); // Exit
	} 

	while(1)
	{
		int temp = read(fd, (void *)sendB, 100); // read from the file descriptor

		// EOF reached
		if(temp == 0)
		{
			printf("* File sent. Closing connection.\n");
			close(sendSock); // close the socket
			close(sockd);
			close(fd); // close the file descriptor
			exit(EXIT_SUCCESS); // exit the code
		}

		// send the message in the buffer to the client
		send(sendSock, (char *)sendB, temp, 0);
	}
	close(sendSock);
	close(sockd);

}