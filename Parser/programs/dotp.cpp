#include <iostream>
#include <stdio.h>
using namespace std;

int main(){
  int A[10] = {1, 50, 30, -20, 100, 5, 8, -200, 50, 20};
  int B[10] = {10, 20, 40, 30, 100, 0, 300, 30, 100, 50};
  int dop = 0;
  for (int i = 9; i >= 0; i--) {
    dop +=A[i]*B[i];
  }
  cout<<dop;
  return 0;
}
