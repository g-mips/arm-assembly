#include <sys/syscall.h>
#include <unistd.h>
#include <time.h>

int main()
{
  time_t now = syscall(SYS_times, NULL);
  syscall(SYS_write, 1, now, 10);
  return 0;
}
