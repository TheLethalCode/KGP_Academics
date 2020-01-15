// Test Statements functionality
int test = 3;
int add (int a, int b) {
	a = 10;
	int *x, y;

	// Pointer Assignments
	x = &y;
	*x = y;
	y = *x;
}



void main () {
	int i, a[10], v = 5;
	double d;
	char *g=NULL;
	char testChar[152];
	char tst='s';


	tst='t';
	tst='u';

	tst=testChar[0];

	for (i=1; i<a[10]; i++) 
		i++;
	do i = i - 1; while (a[i] < v);
	i = 2;
	if (i&&v) i = 1;
	while (v>a[i]) {
		i--;
	}
	

	return;
}