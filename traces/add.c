
int main()
{
	int fib(int);

	int answer = fib(30);
}

int fib(int N)
{
	int c;
	int a = 0;
	int b = 1;
	int i;
	
	for (i = 2; i <= N; i++)
	{
		c = a + b;
		a = b;
		b = c;
	}

	return c;
}
