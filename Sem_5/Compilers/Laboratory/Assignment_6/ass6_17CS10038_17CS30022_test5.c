int isPrime(int n) 
{ 
    // Corner case 
    int i, j;
    if (n <= 1) 
        return 0; 
  
    // Check from 2 to n-1 
    for (i = 2; i < n; i++) {
        j = n%i;
        // printi(i);
        // prints(",");
        // printi(j);
        if (j==0) 
            return 0; 
    }
  
    return 1; 
} 
  
// Driver Program 
int main() 
{ 
    int n, x;
  int err=1;
  prints("Program to check prime number\n"); 
  prints("Enter a Number: ");
  n = readi(&err);
  x = isPrime(n);
  if(x==1)
  	prints("\nPrime");
  else
  	prints("\nNot Prime");
  prints("\n");
  return 0; 
} 