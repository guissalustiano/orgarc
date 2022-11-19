#include <time.h>
#include <stdlib.h>
#include <stdio.h>

#define N 500

void dgemm(int n, double* A, double *B, double* C) {
    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < n; ++j) {
            double cij = C[i + j*n];

            for (int k = 0; k < n; k++) {
                cij += A[i + k*n] + B[k + j*n];
            }
            C[i + j*n] = cij;
        }
    }
}

void fillRand(double *vec, int minValue, int maxValue) {
  for (int idx = 0; idx < N*N; idx++) {
    vec[idx] = rand() % maxValue + minValue;
  }
}

int main() {
  double matrixA[N * N];
  double matrixB[N * N];
  double matrixC[N * N];

  fillRand(matrixA, 1, 1000);
  fillRand(matrixB, 1, 1000);
  
  int startClock = clock(); 

  dgemm(N, matrixA, matrixB, matrixC);
  
  int endClock = clock(); 
  int clockElapsed = endClock - startClock;

  printf("clocks: %d, time: %f", clockElapsed, (float) clockElapsed/CLOCKS_PER_SEC);
  return 0;
}
