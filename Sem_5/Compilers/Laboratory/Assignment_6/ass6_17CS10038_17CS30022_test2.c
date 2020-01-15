int merge(int a[],int min,int mid,int max)
{    
	int top_1=min,top_2=mid+1,top=min,i,c[100];
    while(!((top_1==mid+1)||(top_2==max+1)))
    {
        if(a[top_1]>=a[top_2])
        {
			c[top++]=a[top_2++];
		}
        else
        {
			c[top++]=a[top_1++];
		}
    }
	if(top_1==mid+1)
	{
		for(i=top_2;i<=max;i++)
		{
			c[top++]=a[i];
		}
	}
	else
	{
		for(i=top_1;i<=mid;i++)
		{
			c[top++]=a[i];
		}
	}
	for(i=min;i<=max;i++)
	{
		a[i]=c[i];
	}
	return 0;
}

int merge_sort(int a[],int min,int max)
{	
	int mid;
    if(min<max)
    {
		mid=(min+max)/2;
        merge_sort(a,min,mid);
    	merge_sort(a,mid+1,max);
   		merge(a,min,mid,max);
	}
	return 0;
}
int main()
{
    int a[100],i,n;
	int err=1;
	prints("This Program implements merge sort\n");
    prints("Enter the number of Elements\n");
    n=readi(&err);
	prints("Enter the elements of the array one by one i.e. use a new line for every element: \n"); 
    for(i=0;i<n;i++)
    {
        a[i]=readi(&err);
    }
	merge_sort(a,0,n-1);
	prints("The sorted elements are:\n");
    for(i=0;i<n;i++)
	{
		printi(a[i]);
		prints("\n");
	}
	return 0;
}

