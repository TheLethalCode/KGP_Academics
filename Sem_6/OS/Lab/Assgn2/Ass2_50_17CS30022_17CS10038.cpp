#include<bits/stdc++.h>
#include<unistd.h>
#include<fcntl.h>
#include<sys/wait.h>

using namespace std;

// Trims all the whitespaces to the left of the string
string ltrim(string s)
{
    string te;
    for(int i=0;i<s.size();i++)
        if(!isspace(s[i]))
            return s.substr(i);
    return te;
}

// Trims all the whitespaces to the right of the string
string rtrim(string s)
{
    string te;
    int n=s.size();
    for(int i=0;i<n;i++)
        if(!isspace(s[n-1-i]))
            return s.substr(0, n-i);
    return te;
}

// Split the string into several ones by the delimiter
vector<string> split(string cmd, char delim)
{
    vector<string> res;
    stringstream ss(cmd); // Create a string stream from the command
    string temp;

    // Read from the string stream till the delimiter
    while(getline(ss, temp, delim))
        res.push_back(temp);
    
    return res;
}

// Splits the command into input and ouput
vector<string> splitInputOuput(string cmd)
{
    vector<string> res(3);
    vector< string > output = split(cmd,'>');
    
    // No output redirection
    if(output.size() == 1)
    {
        vector< string > input = split(cmd,'<');
        
        // No input, output redirection
        if( input.size() == 1) 
        {
            res[0] = rtrim(ltrim(output[0]));
            return res;
        }

        // Input redirection present, no output redirection
        else
        {
            // Trim whitespaces
            res[1] = rtrim(ltrim(input[1]));
            res[0] = rtrim(ltrim(input[0]));
            return res;
        }   
    }

    vector< string > input = split(cmd,'<');

    // No input redirection, output redirection present
    if(input.size() == 1)
    {
        // Trim whitespaces
        res[2] = rtrim(ltrim(output[1]));
        res[0] = rtrim(ltrim(output[0]));
        return res;
    }

    // Input, output redirection present
    
    // Input redirection present in the second arg of the output
    if( split(output[0],'<').size() == 1 )
    {
        // Split the second argument into output and input respectively
        vector< string > output_input = split(output[1],'<');

        // Trim the whitespaces in out and in
        res[2] = rtrim(ltrim(output_input[0])), res[1] = rtrim(ltrim(output_input[1]));
        res[0] = rtrim(ltrim(output[0]));
        return res;
    }

    // Input redirection present in the first arg of the output

    // Split the first argument into commmand and input respectively
    vector< string > cmd_input = split(output[0],'<');
    
    // Trim the whitespaces in out and in
    res[1] = rtrim(ltrim(cmd_input[1])), res[2] = rtrim(ltrim(output[1]));
    res[0] = rtrim(ltrim(cmd_input[0]));
    return res;    
} 

// Open files and redirect input and output with files as arguments
void redirect(string inp, string out)
{
    int inp_fd, out_fd;

    // Open input redirecting file
    if(inp.size())
    {
        inp_fd = open(inp.c_str(),O_RDONLY);  // Open in read only mode
        if(inp_fd < 0)
        {
            cout<<"Error opening file: "<<inp<<endl;
            exit(EXIT_FAILURE);
        }
        // Redirect input
        if( dup2(inp_fd,0) < 0 )
        {
            cout<<"Input redirecting error"<<endl;
            exit(EXIT_FAILURE);
        }
    }

    // Open output redirecting file
    if(out.size())
    {
        out_fd = open(out.c_str(), O_CREAT|O_WRONLY|O_TRUNC, S_IRWXU);  // Open in create and truncate mode
        // Redirect output
        if( dup2(out_fd,1) < 0 )
        {
            cout<<"Ouput redirecting error"<<endl;
            exit(EXIT_FAILURE);
        }
    }
}

// Execute the commands
void execCmd(string cmd)
{
    // Split the command and its arguments
    vector<string> args;
    for(string te : split(cmd,' '))
        if(te.size()) // Ignore whitespaces
            args.push_back(te);

    // Create a char* array for the arguments
    char* argv[args.size()+1];
    for(int i=0 ; i<args.size() ; i++)
        argv[i] = const_cast<char*>(args[i].c_str()); // Convert string to char *
    argv[args.size()] = NULL; // Terminate with NULL pointer

    char* const* argv1 = argv; // Assign it to a constant array
    execvp(args[0].c_str(),argv1); // Call the execvp command
}

int main()
{
    
    string cmd;
    int status = 0;

    while(true)
    {
        bool bg = false; // flag for background running

        // Get input command
        cout<<"COMMAND> ";
        getline(cin, cmd); // get the entire line

        // Check for background run
        cmd = rtrim(ltrim(cmd));
        if( cmd.back() == '&')
            bg = true, cmd.back() = ' ';

        // Split into several commands wrt to |
        vector<string> cmds = split(cmd, '|');

        // If no pipes are required
        if(cmds.size()==1)
        {
            // Split the commands and redirection
            vector< string > parsed = splitInputOuput(cmds[0]);
            
            pid_t pid = fork();
            if(pid == 0)
            {
                redirect(parsed[1],parsed[2]); // Redirect input and output if required
                execCmd(parsed[0]); // Execute the command
                exit(0); // Exit the child process
            }

            if(!bg)
                wait(&status);
        }

        else
        {
            int n=cmds.size(); // No. of pipe commands
            int newFD[2], oldFD[2];

            for(int i=0; i<n; i++)
            {
                vector<string> parsed = splitInputOuput(cmds[i]);
                if(i!=n-1)                   // Create new pipe except for the last command
                    pipe(newFD);
                
                pid_t pid = fork();          // Fork for every command

                // In the child process
                if(pid == 0)
                {
                    if( !i || i==n-1)
                        redirect(parsed[1], parsed[2]);  // For the first and last command redirect the input output files

                    // Read from previous command for everything except the first command
                    if(i)
                        dup2(oldFD[0],0), close(oldFD[0]), close(oldFD[1]);

                    // Write into pipe for everything except last command
                    if(i!=n-1)
                        close(newFD[0]), dup2(newFD[1],1), close(newFD[1]);

                    // Execute command
                    execCmd(parsed[0]);
                }

                // In parent process
                if(i)
                    close(oldFD[0]), close(oldFD[1]);
                
                // Copy newFD into oldFD for everything except the last process
                if(i!=n-1)
                    oldFD[0] = newFD[0], oldFD[1] = newFD[1];
            }

            // If no background, then wait for all child processes to return
            if(!bg)
                while( wait(&status) > 0);
        }
    }
}