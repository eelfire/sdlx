#include <stdio.h>

int func(int x, int y) {
  return x*y;
}
int main() {
  int A[10] = {8, 10, 20, 5, 6, 5, -8, -100, -20, 50};
  int B[10] = {2, 10, 5, 1, 12, 18, 6, 5, 15, 20};
  int res = 0;
  for (int i = 0; i < 10; i++)
  {
    res = res + func(A[i], B[i]);
  }

  printf("%d", res);
  return 0;
}