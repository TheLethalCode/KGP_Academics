#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<stdbool.h>
#include<string.h>

#include<sys/socket.h>
#include<sys/select.h>
#include<arpa/inet.h>
#include<netinet/in.h>

#include<fcntl.h>
#include<errno.h>
#include<signal.h>
#include<netdb.h>

#define MAXLINE 40960
#define CHUNK 10230

#define BROWSER 0
#define HOST 1

#define true 1
#define false 0

struct sockConn{

	int status; // Whether the connection is alive or not
	int type;   // Browser or host connection
	int sockfd; // Socket descriptor of the connection
	int otherfd; // Socket descriptor of the mapping end
	
	// Reading Buffer
	char readBuff[MAXLINE]; 
	int rS;

	int parsed; // Check if header already parsed,
	
	// Writing Buffer
	char writeBuff[MAXLINE];
	int wS, wDone;

	int toClose; // Indicated whether to close connection because the other side is not there.
};

void usageInstructions()
{
	printf("USAGE INSTRUCTIONS\n");
	printf("==================\n");
	printf("./SimHTTPProxy <listen_port>\n");
}

// Parse the headers and retrieve host and port for connection.
// Replace the GET command with the correct one for the host to function.
void parseHeader(char *header, int *port, char *host, char *toMod, int *size)
{
	char temp[MAXLINE];  // temporary place to store the unmodified header
	char replace[MAXLINE]; // the string to be replaced with path
	char *loc; // Pointer to the start of replace string
	strncpy(temp, header, *size);
	temp[*size] = '\0';

	// The main command
	char *command = strtok(header,"\r\n");
	printf("%s, ",command);

	// The host and port
	char *hostPort = strtok(NULL, "\r\n");
	char *colon = strstr(hostPort, ":") + 1;

	// When there is no port, assume 80
	if(strstr(colon, ":") == NULL)
	{
		printf("Host: %s, ",colon+1);
		printf("Port: %d, ", 80);
		strcpy(host, colon+1);
		*port = 80;
	}

	// When there is port, read it.
	else
	{
		char *Ncolon = strstr(colon, ":");
		printf("Host: %.*s, ", Ncolon - colon-1, colon+1); 
		printf("Port: %d, ", atoi(Ncolon + 1));
		strncpy(host, colon+1, Ncolon - colon-1);
		host[Ncolon - colon-1] = '\0';
		*port = atoi(Ncolon + 1);
	}

	// The path of the requested content.
	char *path = strtok(command, " ");
	path = strtok(NULL, " ");
	strcpy(replace, path);	// The stuff to replace with path
	path = strstr(path, host);

	if(path != NULL)
		path = strstr(path, "/");
	else
		path = "/";
	printf("Path: %s\n", path);
	
	// Flush the output
	fflush(stdout);

	// Modify the header.
	loc = strstr(temp, replace);
	int i = 0;
	for(int j=0; j < *size;)
	{
		if(loc - (temp + j) != 0)
			toMod[i++] = temp[j++];
		else
		{
			strcpy(toMod + i, path);
			i += strlen(path);
			j += strlen(replace);
		}
	}
	*size = i;
}


int createConnection(int port, char *host, int *sockfd)
{
	struct hostent *hostIp = gethostbyname(host);
	
	// Not a valid request.
	if(hostIp == NULL)
		return -1;

	// Create IP address
	struct sockaddr_in server;
	server.sin_family = AF_INET;
	server.sin_addr = *(struct in_addr *)hostIp->h_addr;
	server.sin_port = htons(port);

	// Create socket for connection
	*sockfd = socket(AF_INET, SOCK_STREAM, 0);
	if(*sockfd < 0)
	{
		printf("Cannot create socket for connection. Dropping connection.\n");
		return -1;
	}
	fcntl(*sockfd, F_SETFL, O_NONBLOCK);  // Set it as non blocking
	
	// Connect to the host
	if( connect(*sockfd, (const struct sockaddr *)&server, sizeof(server)) < 0 )
	{
		if(errno != EINPROGRESS)
			printf("Connection cannot be established to %s. Dropping connection.\n", host);
		return -1;
	}
	
	return 0;
}

// Reset connection
void resetConn(struct sockConn *mod)
{
	mod->status = false, mod->otherfd = -1;
	mod->rS = mod->wS = mod->wDone = 0;
	mod->toClose = false;
	mod->parsed = false;
}

int main(int argc, char* argv[])
{
	// Checking the command line arguments
	if(argc != 2)
	{
		usageInstructions();
		exit(EXIT_FAILURE);
	}

	// Convert the command line arguments to usable form
	int listen_port = atoi(argv[1]);
	if(listen_port <= 0)
	{
		usageInstructions();
		exit(EXIT_FAILURE);	
	}


	// Ignoring broken pipe signal to handle writing to a closed socket
	struct sigaction new_actn;
	new_actn.sa_handler = SIG_IGN;
	sigemptyset (&new_actn.sa_mask);
	new_actn.sa_flags = 0;
	sigaction (SIGPIPE, &new_actn, NULL);


	// Create a socket for listening on said port
	int sockfd = socket(AF_INET, SOCK_STREAM, 0);
	if(sockfd < 0)
	{
		printf("Listening socket creation failed\n");
		exit(EXIT_FAILURE);
	}

	// Configure the SimHTTPProxy address and bind it
	struct sockaddr_in income;
	income.sin_family = AF_INET;
	income.sin_addr.s_addr = INADDR_ANY;
	income.sin_port = htons(listen_port);
	if( bind(sockfd, (const struct sockaddr *)&income, sizeof(income)) < 0 )
	{
		printf("Binding of SimHTTPProxy failed\n");
		exit(EXIT_FAILURE);
	}
	printf("HTTPProxy listening on port %d.\n", listen_port);
	listen(sockfd, 200); 	// Listen for incoming requests


	// Create fd sets for using select (Read)
	fd_set origR, tempR;
	FD_ZERO(&origR);
	FD_SET(sockfd, &origR);FD_SET(0, &origR);

	// Create fd sets for using select (Write)
	fd_set origW, tempW;
	FD_ZERO(&origW);

	int maxfd = sockfd;

	// Initialise the connections to NULL
	struct sockConn conns[100];
	for(int i=0; i<100; i++)
		resetConn(&conns[i]);

	// Keep going indefinitely, untill exit command is given.
	while(1)
	{
		// Copy the original settings to the new one (read and write) every time, so that it can stay updated.
		// Because the FDSET passed to select will be modified.
		memcpy(&tempR, &origR, sizeof(origR));
		memcpy(&tempW, &origW, sizeof(origW));

		// Monitor the set of read and write fds, where it will return when some data is ready to be read
		// or data can be written.
		int nfds = select(maxfd+1, &tempR, &tempW, NULL, NULL);
		if(nfds == -1)
		{
			printf("Select Error\n");
			exit(EXIT_FAILURE);
		}

		// Now go through the fds so that you can see which of them is active. Untill all active
		// ready fds have been checked.
		for(int i=0; i <= maxfd & nfds>0; i++)
		{
			// If the file descriptor is ready for read.
			// There are 3 cases
			// 1) Exit command from STDIN, which has a fd of 0. Compare the string input,
			//    and exit after closing all connections.
			// 2) When a new connection is trying to connect, sockfd is ready to be read,
			//    and a new connection is setup and added to read FDSET.
			// 3) When data transfer takes place between localhost and remoteserver. Handle the data,
			//    accordingly (i.e) make sure it goes to the write buff of the other connection.
			if(FD_ISSET(i, &tempR))
			{
				// Reduce the number of fds to be processed.
				nfds --;

				// When content from stdin is available
				if(!i)
				{
					char DUMMY[MAXLINE];
					int temp = read(i, DUMMY, MAXLINE);
					DUMMY[temp] = '\0';
					
					// Match it to the exit command
					if(!strcmp(DUMMY, "exit\n") || !strcmp(DUMMY, "exit") || !strcmp(DUMMY, "exit\t"))
					{
						close(sockfd);
						for(int i=3; i<maxfd+1;i++)
							close(i);
						exit(EXIT_SUCCESS);
					}
					else
						printf("Invalid command\n");
				}
				
				// When a new connection is trying to connect
				else if(i == sockfd)
				{
					// Accept the incoming connection
					struct sockaddr_in client1;
					socklen_t size;
					int new_conn = accept(sockfd, (struct sockaddr *)&client1, &size);
					fcntl(new_conn, F_SETFL, O_NONBLOCK); 	// Set it as non blocking

					// Print the connecting client address
					printf("Connection accepted from %s:%d\n", inet_ntoa(client1.sin_addr), ntohs(client1.sin_port));
					
					// Add the socket to readfds
					FD_SET(new_conn, &origR);	
					if(new_conn > maxfd)
						maxfd = new_conn;

					// Create connection details
					conns[new_conn].status = true;
					conns[new_conn].type = BROWSER;
					conns[new_conn].sockfd = new_conn;
				}

				// Other fds
				else
				{
					// If toClose was set, then this socket must be closed, because the other side has already closed
					// connection or connection was not established.
					if(conns[i].toClose)
					{
						close(i);
						FD_CLR(i, &origR);
						FD_CLR(i, &origW);
						resetConn(&conns[i]);
						continue;
					}

					// - If no space in read buffer, copy it to write buffer of the other connection (if it exists),
					// and remove this from the read FDSET untill the write has been accomplished.
					// - Will only be added to the read FDSET when the write buffer of other side is empty.
					// - We are assuming the other connection cannot not exist in the scenario where the read buffer is 
					// full ( assumption verfied ) 
					// - Moreover, the other side's write buffer is assumed to be empty (assumption verified). 
					// whenever read of this side happens.
					// - Then add the other side's connection to write FDSET
					// - After wards continue to the next fd that is ready for read or write.
					if(conns[i].rS + CHUNK >= MAXLINE)
					{
						memcpy(conns[conns[i].otherfd].writeBuff, conns[i].readBuff, conns[i].rS);
						conns[conns[i].otherfd].wS = conns[i].rS;
						conns[i].rS = 0;
						conns[i].parsed = false;

						FD_CLR(i, &origR);
						FD_SET(conns[i].otherfd, &origW);
						if(conns[i].otherfd > maxfd)
							maxfd = conns[i].otherfd;
						
						continue;
					}

					// Now, read untill either 
					// 1) Read buffer is full (In that case, do the same as above)
					// 2) End of file is reached (Treat as if the read buffer is full, just close the
					//	  connection, and mark the other connection toClose as true, through which we 
					//    will know to close the connection after write is done)
					// 3) All data has been read (In which case, treat as if read buffer is full) 
					int temp;
					while((temp = read(i, conns[i].readBuff + conns[i].rS, CHUNK)) != -1)
					{
						// EOF reached. When the other connection doesnt exist, just drop the contents.
						if(!temp)
						{	
							if(conns[i].otherfd != -1)
							{
								memcpy(conns[conns[i].otherfd].writeBuff, conns[i].readBuff, conns[i].rS);
								conns[conns[i].otherfd].wS = conns[i].rS;
								conns[i].rS = 0;

								conns[conns[i].otherfd].toClose = true;
								
								FD_SET(conns[i].otherfd, &origW);
								if(conns[i].otherfd > maxfd)
									maxfd = conns[i].otherfd;
							}

							close(i);
							FD_CLR(i, &origR);
							FD_CLR(i, &origW);
							resetConn(&conns[i]);
							break;
						}

						// Update the read buffer size.
						conns[i].rS += temp;

						// - When header hasnt been parsed for the browser connection, 
						// check for the header in the buffer.
						// - If request is not GET/POST, drop the connection.
						// - If header is present, initiate connection to the host.
						// - Keep the status of that connection has dead untill first write has
						// occured.
						// - Continue reading the data from original connection untill read
						// buffer is full or data has been read completely.
						
						if( conns[i].type == BROWSER && !conns[i].parsed)
						{
							char *end, DUMMY[MAXLINE];
							strncpy(DUMMY, conns[i].readBuff, conns[i].rS);
							DUMMY[conns[i].rS]='\0';

							end = strstr(DUMMY, "\r\n\r\n");

							// There are 2 possible cases when a header occurs
							// 1) Connection already exists, in which case just parse that header
							// 2) Connection doesn't exist, in which case create new connection
							if(end != NULL)
							{
								// Ohter side connection doesnt exist.
								if(conns[i].otherfd == -1)
								{
									// When the request is not a GET POST request.
									char te[6];
									strncpy(te, DUMMY, 5);
									te[6] = '\0';
									if(strstr(te, "GET") == NULL && strstr(te, "POST") == NULL)
									{
										printf("Not a GET / POST request. Dropping connection.\n");
										close(i);
										FD_CLR(i, &origR);
										FD_CLR(i, &origW);
										resetConn(&conns[i]);
										break;
									}
									
									// Parse the headers, extract host and port.
									int port;
									char host[256];
									parseHeader(DUMMY, &port, host, conns[i].readBuff, &conns[i].rS);
									
									// Create Host Connection
									int hostfd;
									int res = createConnection(port, host, &hostfd);

									// If unable to create connection, drop the current connection.
									if(res < 0 && errno != EINPROGRESS)
									{
										close(i);
										FD_CLR(i, &origR);
										FD_CLR(i, &origW);
										resetConn(&conns[i]);
										break;
									}
									
									// Else, while the host connectin has been intialised.
									else
									{
										conns[i].otherfd = hostfd;
										
										// Create connection details
										conns[hostfd].status = false;  // Technically CONNECT in progress, 
																		//so it is alive only when we can make the first write
										conns[hostfd].type = HOST;
										conns[hostfd].sockfd = hostfd;
										conns[hostfd].otherfd = i;

										FD_SET(hostfd, &origW);
										if(conns[i].otherfd > maxfd)
											maxfd = conns[i].otherfd;
									}
								}

								// Other side exist.
								else
								{
									// When the request is not a GET POST request. Just drop the request.
									char te[6];
									strncpy(te, DUMMY, 5);
									te[6] = '\0';
									if(strstr(te, "GET") == NULL && strstr(te, "POST") == NULL)
									{
										printf("Not a GET / POST request. Dropping Request.\n");
										conns[i].rS = 0;
										break;
									}
									
									// Parse the headers, extract host and port.
									int port;
									char host[256];
									parseHeader(DUMMY, &port, host, conns[i].readBuff, &conns[i].rS);
								}
								conns[i].parsed = true;
							}
						}

						// If the read buffer is full.
						if(conns[i].rS + CHUNK >= MAXLINE)
						{
							memcpy(conns[conns[i].otherfd].writeBuff, conns[i].readBuff, conns[i].rS);
							conns[conns[i].otherfd].wS = conns[i].rS;
							conns[i].rS = 0;
							conns[i].parsed = false;

							FD_CLR(i, &origR);
							FD_SET(conns[i].otherfd, &origW);
							if(conns[i].otherfd > maxfd)
								maxfd = conns[i].otherfd;
							break;
						}
					}

					// If all data has been read. Remove from read FDSET, and this will be added back in the 
					// read FDSET when the write is done completely.
					if(temp == -1 && (errno == EAGAIN || errno == EWOULDBLOCK))
					{
						memcpy(conns[conns[i].otherfd].writeBuff, conns[i].readBuff, conns[i].rS);
						conns[conns[i].otherfd].wS = conns[i].rS;
						conns[i].rS = 0;
						conns[i].parsed = false;

						FD_CLR(i, &origR);
						FD_SET(conns[i].otherfd, &origW);
						if(conns[i].otherfd > maxfd)
							maxfd = conns[i].otherfd;
					}
				}
			}

			// If the file descriptor is ready for write.
			// There are 4 cases.
			// 1) Connection has already been established (browser connection) or the first
			//   write has been done already both cases have their conn status as alive.
			// 2) The first write has yet to been done, but the connection has successfully connected.
			//    Here, this can be understood from SO_ERROR.	
			// 3) The first write has yet to been done, and the connection is unable to be established.
			//    Here, this can be understood from SO_ERROR.
			// 4) The connection has to be closed immediately after write buffer has been written to the socket.
			//    Because the other side is not alive. 	
			if(FD_ISSET(i, &tempW))
			{
				// Reduce the number of fds to be processed.
				nfds--;

				// First write hasn't taken place yet.
				// Check for socket error, to see whether the connection was successful or not.
				// 1) If the connection was successful, mark the connection has alive. Then do the same has normal write.
				// 2) If the connection wasn't successful, close the connection. Mark the other connection's toClose as
				//    true so that they would know that the attempt at connection was unsuccessful.
				if(!conns[i].status)
				{
					int error;
					socklen_t slen = sizeof(error);
					getsockopt(i, SOL_SOCKET, SO_ERROR, &error, &slen);

					// Connection was unsuccessful. Close it. Go to the next fd.
					if(error == 1)
					{
						conns[conns[i].otherfd].toClose = true;
						close(i);
						FD_CLR(i, &origR);
						FD_CLR(i, &origW);
						resetConn(&conns[i]);
						continue;
					}

					// Connection was successful. Mark alive. Then treat it as normal write.
					else
						conns[i].status = true;
				}

				// Trying to write the data in writeBuff into the socket.
				// When data is not completely written, just modify the amount done.				

				while(conns[i].wDone < conns[i].wS)
				{
					int temp = write(i, conns[i].writeBuff + conns[i].wDone, conns[i].wS - conns[i].wDone);
					if(temp == -1)
					{
						// When the other end is closed, so that no more write can take place.
						// Close this connection. Mark the other connection's toClose as true, so that
						// it knows this end is not alive.
						if(errno == EPIPE)
						{
							conns[conns[i].otherfd].toClose = true;

							close(i);
							FD_CLR(i, &origR);
							FD_CLR(i, &origW);
							resetConn(&conns[i]);
							break;
						}

						// When there is no more space to write the rest of the contents.
						// Wait for space to be available.
						if(errno == EAGAIN || errno == EWOULDBLOCK)
							break;
					}

					// Just update the amount of data written.
					else
						conns[i].wDone += temp;
				}

				// When all data has been written into the socket, add the other end of the connection
				// to read FDSET and remove the current connection from write FDSET.
				// The connection shouldn't have already been reset because of SIGPIPE
				if(conns[i].wS == conns[i].wDone && conns[i].wS != 0)
				{
					// If the other side is not alive and all data is written. Close it.
					if(conns[i].toClose)
					{
						close(i);
						FD_CLR(i, &origR);
						FD_CLR(i, &origW);
						resetConn(&conns[i]);
					}

					// If the other side is alive, add the sockets to the proper FDSETs.
					else
					{
						FD_CLR(i, &origW);
						
						FD_SET(conns[i].otherfd, &origR);
						if(conns[i].otherfd > maxfd)
							maxfd = conns[i].otherfd;

						FD_SET(i, &origR);
						if(i > maxfd)
							maxfd = i;

						conns[i].wS = conns[i].wDone = 0;
					}
				}
			}			
		}
	}
}
