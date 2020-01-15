int fib(int n) 
{ 
   if (n <= 1) 
      return n; 
   return fib(n-1) + fib(n-2); 
} 
  
int main () 
{ 
  int n;
  int err=1;
  prints("Program to compute fibonacci number\n"); 
  prints("Enter a Number: ");
  n = readi(&err);
  prints("\nNth fibonacci number is: "); //0,1,1,2,3,5,8
  printi(fib(n));
  prints("\n");
  return 0; 
} 