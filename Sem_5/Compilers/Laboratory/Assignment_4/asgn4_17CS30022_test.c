// This is a test file.

// Make changes in this file to test the various rules coded

int main () { 
  int p,i,n,k;
  char strin[] = "Hello Rohan";
  char singlech = 'p';
  float val = 323;
  for (i=1;i<100;i++) {
    if(val<500) {
      printf ("%s",c);
    }
  }
  // Quicksort driver
  int arr[] = {10, 7, 8, 9, 1, 5};
    int n = sizeof(arr)/sizeof(arr[0]);
    quickSort(arr, 0, n-1);
    printf("Sorted array: \n");
    printArray(arr, n);

    //driver for nth fibonacci problem
    int n1 = 40;
    _initialize();
    printf("Fibonacci number is %d ", fib(n1));


    //driver for 0-1 knapsack problem using dynamic programming
    int val[] = {60, 100, 120};
    int wt[] = {10, 20, 30};
    int  W = 50;
    int n = sizeof(val)/sizeof(val[0]);
    printf("%d", knapSack(W, wt, val, n));

  // Program to print area of rectangle
  int person=101,a,b;
  printf("Enter the length and breadth of rectangle: \n");
  scanf("%d%d",&a,&b);
  printf("Area of rectangle is: %d",a*b);
  return;
}