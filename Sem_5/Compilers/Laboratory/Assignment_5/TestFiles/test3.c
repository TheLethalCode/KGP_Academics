// Factorial sample code
//this tests the function and declaration functionality


int testInt = 8;
void main () {
	int n = 6;
	int fn;
	fn = factorial(n);
	return;
}
int factorial (int n) {
	int m = n-1;
	int r = 1;
	if (m) {
		int fn = factorial(m-1);
		r = n*fn;
	}
	return r;
}