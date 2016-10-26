#include <stdio.h>
#include <stdlib.h>

int main()
{
  char *i;
  int j = 6;
  i = (char*)malloc(j);

  int index = 0;
  for (; index < j-2; ++index)
    {
      i[index] = ('a' + 0);
    }
  i[index++] = '\n';
  i[index] = '\0';
  
  printf("%s", i);
  
  free(i);
  
  return 0;
}
