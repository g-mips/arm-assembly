#include <stdio.h>

void test(char* glow)
{
  printf("%c", *glow);
}

int main()
{
  char a = 'a';
  char* p = &a;
  test(p);
}
