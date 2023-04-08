#include <iostream>
#include <stdio.h>
using namespace std;

int main(){
  int N = 30;
  int A[N] <- given;
  int max_val = A[0];
  for (int i = N; i >= 0; i--) {
    if (max_val < A[i]){
      max_val = A[i];   
    }
  }
  cout<<max_val;
  return 0;
}
