#include <stdio.h>

int main()
{
  printf("Char     : %zu\n", sizeof(char));
  printf("Short    : %zu\n", sizeof(short));
  printf("Int      : %zu\n", sizeof(int));
  printf("Long     : %zu\n", sizeof(long));
  printf("Long Long: %zu\n", sizeof(long long));
  printf("Float    : %zu\n", sizeof(float));
  printf("Double   : %zu\n", sizeof(double));

  return 0;
}
