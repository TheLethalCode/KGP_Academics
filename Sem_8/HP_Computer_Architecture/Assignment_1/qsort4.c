#include <string.h>
#include <stdio.h>
#define a(i) (((unsigned char *) base) + i*size)
#define N 1000
double a[N];

void
qsort(void *base, size_t nmemb, size_t size,
  int (*compar)(const void *, const void *))
{
  int m, n, i, j;
  unsigned char pivot[size], tmp[size];

  m = 0;
  n = nmemb - 1;
  if (m < n) {
    memcpy(pivot, a(n), size);
    i = m; j = n;
    while (i <= j) {
      while ((*compar)(a(i), pivot) < 0) i++;
      while ((*compar)(a(j), pivot) > 0) j--;
      if (i <= j) {
        memcpy(tmp, a(i), size);
        memcpy(a(i), a(j), size);
        memcpy(a(j), tmp, size);
        i++; j--;
      }
    }
    qsort(a(m), j - m + 1, size, compar);
    qsort(a(i), n - i + 1, size, compar);
  }
}

int
compar_double(const void *p, const void *q)
{
  double x = *((double *) p), y = *((double *) q);
  return x < y ? -1 : x == y ? 0 : 1;
}

int
main()
{
  int i;

  for (i = 0; i < N; i++)
    a[i] = i;
  qsort((void *) a, N, sizeof(double), &compar_double);
  for (i = 0; i < N; i++)
    printf("%f\n", a[i]);
  return 0;
}