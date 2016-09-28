#include <stdio.h>
#include <limits.h>

void test(int max)
{
  printf("%d", max);
}

int main()
{
  char a = 'a';
  char* p = &a;
  
  test(SSIZE_MAX);
}
