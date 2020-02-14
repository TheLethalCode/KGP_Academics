#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<string.h>

#include<sys/socket.h>
#include<sys/select.h>
#include<arpa/inet.h>
#include<netinet/in.h>

#include<fcntl.h>
#include<errno.h>
#include<signal.h>

#define MAXLINE 1024

void usageInstructions()
{
	printf("USAGE INSTRUCTIONS\n");
	printf("==================\n");
	printf("./SimProxy <listen_port> <institute_proxy_IP> <institute_proxy_port>\n");
}

int main(int argc, char* argv[])
{
	// Checking the command line arguments
	if(argc != 4)
	{
		usageInstructions();
		exit(EXIT_FAILURE);
	}

	// Convert the command line arguments to usable form
	int listen_port = atoi(argv[1]);
	int institute_port_ip = atoi(argv[3]);
	struct in_addr institute_proxy_IP;
	if(listen_port <= 0 || institute_port_ip <= 0 || !inet_aton(argv[2], &institute_proxy_IP))
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

	// Configure the SimProxy address and bind it
	struct sockaddr_in income;
	income.sin_family = AF_INET;
	income.sin_addr.s_addr = INADDR_ANY;
	income.sin_port = htons(listen_port);
	if( bind(sockfd, (const struct sockaddr *)&income, sizeof(income)) < 0 )
	{
		printf("Binding of SimProxy failed failed\n");
		exit(EXIT_FAILURE);
	}

	printf("Proxy running on port %d. Forwarding all connections to %s:%d\n", listen_port, argv[2], institute_port_ip);

	// Configure the institute proxy address
	struct sockaddr_in proxy;
	proxy.sin_family = AF_INET;
	proxy.sin_addr = institute_proxy_IP;
	proxy.sin_port = htons(institute_port_ip);

	// Listen for inoming requests
	listen(sockfd, 200);

	// Create fd sets for using select
	fd_set orig, fly;
	FD_ZERO(&orig);
	FD_SET(sockfd, &orig);FD_SET(0, &orig);
	
	int maxfd = sockfd;
	char send_buff[MAXLINE];

	// Initialise the pairs to -1 . Used to store the tunnel pairs
	int pair[10000];
	for(int i=0; i<10000; i++)
		pair[i] = -1;

	// Keep going indefinitely
	while(1)
	{
		// Copy the original settings to the new one every time, so that it can stay updated
		memcpy(&fly, &orig, sizeof(orig));

		// Monitor the set of fds
		int nfds = select(maxfd+1, &fly, NULL, NULL, NULL);
		if(nfds == -1)
		{
			printf("Select Error\n");
			exit(EXIT_FAILURE);
		}

		// Now go through the fds so that you can see which of them is active
		for(int i=0; i<=maxfd & nfds>0; i++)
		{
			if(FD_ISSET(i, &fly))
			{
				nfds--;

				// When a new connection is trying to connect
				if(i == sockfd)
				{
					// Accept the incoming connection
					struct sockaddr_in client1;
					socklen_t size;
					int new_conn = accept(sockfd, (struct sockaddr *)&client1, &size);
					FD_SET(new_conn, &orig);

					// Set it as non blocking
					fcntl(new_conn, F_SETFL, O_NONBLOCK); 

					// Print the connecting client address
					printf("Connection accepted from %s:%d\n", inet_ntoa(client1.sin_addr), ntohs(client1.sin_port));

					// Create separate TLS tunnel for connecting to the institute proxy for this connection
					int sockfd_proxy = socket(AF_INET, SOCK_STREAM, 0);
					if(sockfd_proxy < 0)
					{
						printf("New connecting socket creation failed\n");
						exit(EXIT_FAILURE);
					}

					// Connect to the institute proxy
					if( connect(sockfd_proxy, (const struct sockaddr *)&proxy, sizeof(proxy)) < 0)
					{
						printf("Connection to institute proxy failed\n");
						exit(EXIT_FAILURE);
					}
					fcntl(sockfd_proxy, F_SETFL, O_NONBLOCK);  // Set it as non blocking

					// Map the tunnel pairs
					pair[new_conn] = sockfd_proxy;
					pair[sockfd_proxy] = new_conn;

					// Add these fds to read fdset
					FD_SET(new_conn, &orig);
					FD_SET(sockfd_proxy, &orig);

					// Increase maxfd if needed
					if(new_conn > maxfd)
						maxfd = new_conn;
					if(sockfd_proxy > maxfd)
						maxfd = sockfd_proxy;

					// printf("Created tunnel pairs %d %d\n", new_conn, sockfd_proxy);
				}

				// When content from stdin is available
				else if(!i)
				{
					int temp = read(i, send_buff, MAXLINE);
					send_buff[temp] = '\0';
					
					// Match it to the exit command
					if(!strcmp(send_buff, "exit\n") || !strcmp(send_buff, "exit") || !strcmp(send_buff, "exit\t"))
						exit(EXIT_SUCCESS);
					
					else
						printf("Invalid command\n");
				}

				// When a read from an institute proxy tunnel or client tunnel is available
				else
				{		
					int readSize=0, SreadSize=0; 
					
					// If the fd is already closed
					if(pair[i] == -1)
						continue;

					// Read until all data is read
					while((readSize = read(i, send_buff, MAXLINE)) != -1 )
					{	
						// If EOF file is received, close sockets
						if(!readSize)
						{
							// printf("EOF received in %d\n", i);
							// printf("Closing  %d %d", i, pair[i]);

							// Close the file descriptors corresponding to that connection
							close(i);
							close(pair[i]);

							// Clear the fds from the read fd set
							FD_CLR(i,&orig);
							FD_CLR(pair[i], &orig);

							// Reopen the fds for mapping
							pair[pair[i]] = -1; pair[i] = -1;
						}

						// If the other end is closed already
						else if((SreadSize = write(pair[i], send_buff, readSize)) == -1)
						{
							// printf("Connection already closed in pair of %d\n", i);
							// printf("Closing  %d %d", i, pair[i]);

							// Close the file descriptors corresponding to that connection
							close(i);
							close(pair[i]);

							// Clear the fds from the read fd set
							FD_CLR(i,&orig);
							FD_CLR(pair[i], &orig);

							// Reopen the fds for mapping
							pair[pair[i]] = -1; pair[i] = -1;
						}
					}
				}
			}			
		}
	}
}
