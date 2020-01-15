int gen(int *a)
{
	*a=10;
	return 0;
}
int main()
{
	int *p;
	int i=5;
	p=&i;
	*p=61;
	printi(i);
	prints("\n");
	int *q=p;
	*q=55;
	printi(i);
	prints("\n");
	char c='A';
	char *d;
	d=&c;
	*d='k';
	if(c=='k')
	{
		prints("YIPPEEE\n");
	}
	else
	{
		prints("OOOOPS\n");
	}
	gen(p);
	printi(i);
	prints("\n");
	
	return 0;
}
