int gcd(int a, int b) 
{ 
    if (b == 0) 
        return a; 
    return gcd(b, a % b); 
} 
  
// Returns LCM of array elements 
int findlcm(int arr[], int n) 
{ 
    // Initialize result 
    int ans, i;
    ans = arr[0]; 
  
    // ans contains LCM of arr[0], ..arr[i] 
    // after i'th iteration, 
    for (i = 1; i < n; i++) 
        ans = (((arr[i] * ans)) / 
                (gcd(arr[i], ans))); 
  
    return ans; 
} 
  
// Driver Code 
int main() 
{ 
    // int arr[] = { 2, 7, 3, 9, 4 }; 
    // int n = sizeof(arr) / sizeof(arr[0]); 
    // printf("%lld", findlcm(arr, n)); 
    int a[10],i,n,m,c,l,u;
    int err=1;
    prints("This Program implements LCM\n");
    prints("Enter the size of an array(<=10): \n");
    n=readi(&err);
    prints("Enter the elements of the array one by one i.e. single element in a line: \n");
    for(i=0;i<n;i++){
         a[i]=readi(&err);
    }

    l = findlcm(a, n);

    prints("lcm of given no is: ");
    printi(l);
    prints("\n");
    return 0; 
} 