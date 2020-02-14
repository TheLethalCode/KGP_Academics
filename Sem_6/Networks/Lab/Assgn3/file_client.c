#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<unistd.h>
#include<fcntl.h>
#include<errno.h>
#include<sys/socket.h>
#include<sys/types.h>
#include<arpa/inet.h>
#include<netinet/in.h>

#define SERVER_PORT 8490
#define MAXLEN 100

char *new_file = "RECEIVED_FILE.txt";

int delimCheck(char ch)
{
	if(ch == ' ' || ch == '\t' || ch == ':' || ch == ';' || ch == ',' || ch == '.')
		return 1;
	return 0;
}

int wordCheck(char* buff, int temp, int *prev)
{
	int i = 0, words = 0;

	// Mark the start as non-delimiter
	if ( !delimCheck(buff[0]) ) 
		*prev = 0;
	
	while(i < temp)
	{
		// Go to the first delimiting character
		while( i < temp && !delimCheck(buff[i]) ) i++;
	
		if( i < temp && *prev == 0) words += 1; // Increase the word count by 1
		
		// Reinitialise prev
		*prev = 0; 

		// Go to the first non-delemiting char
		while( i < temp && delimCheck(buff[i]) ) i++;
	}

	// Mark the end as delimiter
	if ( delimCheck(buff[i-1]) ) 
		*prev = 1;

	return words; // Return words
}

// Create socket
int sockCreate()
{
	int rsocket = socket(AF_INET, SOCK_STREAM, 0); // Create a socket for requesting connection
	if(rsocket < 0 )
	{
		printf("* Socket creation failed");
		exit(EXIT_FAILURE);
	}
	return rsocket;
}

// try to connect to the remote server
void sockConnect(int sockd)
{
	struct sockaddr_in remote;

	// setup the remote address
	remote.sin_family = AF_INET;
	remote.sin_port = htons(SERVER_PORT);
	remote.sin_addr.s_addr = INADDR_ANY;

	int val =  connect(sockd, (const struct sockaddr *)&remote, sizeof(remote)); // COnnect to the remote host of the specified id

	// if socket creation failed
	if(val == -1) 
	{
		printf("* Connection failed\n");
		exit(EXIT_FAILURE);	
	}
	printf("* Connection established\n");
}

int main(int argc, char* argv[])
{
	int sockd = sockCreate(); // create socket
	sockConnect(sockd); // establish connection

	char sendB[MAXLEN], recvB[MAXLEN]; // define buffers
	int st_fl = 0, fd;
	int wrd_cnt = 0, byte_cnt = 0, prev = 1;
	
	printf("FILE NAME:- ");  // Request for file name
	scanf("%[^\n]",sendB);  // Read the file name from the user
	send(sockd, (char *)sendB, strlen(sendB), 0); // send the file name to the server

	while(1)
	{
		// Try to receive the data from server
		int temp = recv(sockd, (char *)recvB, sizeof(recvB), 0);

		// Check for force close or orderly shut down by the server when file is not present
		if( (temp < 0 && errno == ECONNRESET && st_fl == 0) || (temp == 0 && st_fl == 0) )
		{
			printf("* Connection closed by server.\n");
			printf("* File Not Found.\n");
			close(sockd); // close the socker after done
			exit(EXIT_FAILURE); // exit with failure
		}

		if( st_fl == 0)
			fd = open(new_file, O_WRONLY | O_TRUNC | O_CREAT, S_IRWXU); // open the new file to write the data
		
		// Check when the file is done being transferred
		if( (temp < 0 && errno == ECONNRESET && st_fl == 1) || (temp == 0 && st_fl == 1) )
		{
			if(prev == 0)
				wrd_cnt += 1;
			printf("* Connection closed by server.\n");
			printf("* File Successfully received.\n");
			printf("* Size of file = %d bytes, no. of words = %d.\n", byte_cnt, wrd_cnt);
			close(sockd);
			close(fd);
			exit(EXIT_SUCCESS);	
		}

		// Write the buffer received to the file
		write(fd, (const void *)recvB, (size_t)temp);
		byte_cnt += temp; // increase the number of bytes
		wrd_cnt += wordCheck(recvB, temp, &prev); // increase the number of words
		st_fl = 1; // Mark the condition for checking whether file is preseent.
	}

	// Close the socket
	close(sockd);
}