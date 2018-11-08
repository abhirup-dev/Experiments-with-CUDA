#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>
#include <cuda_runtime.h>

#define N 10
#define num_threads 10000

__global__ void increment_naive(int *d)
{
	int tid = threadIdx.x + blockIdx.x*blockDim.x;
	tid = tid % N;
	d[tid] += 1;
}
__global__ void increment_atomic(int *d)
{
	int tid = threadIdx.x + blockIdx.x*blockDim.x;
	tid = tid % N;
	atomicAdd(&d[tid], 1);
}
int main()
{
	int h[N], *d;
	cudaMalloc(&d, sizeof(int)*N);
	cudaMemset(d, 0, sizeof(int)*N);
	increment_naive<<<(num_threads/N), N>>>(d);
	cudaMemcpy(h, d, sizeof(int)*N, cudaMemcpyDeviceToHost);

	for(int i=0; i<N; i++)
		std::cout << h[i] << "\n";

	cudaMemset(d, 0, sizeof(int)*N);
	increment_atomic<<<(num_threads/N), N>>>(d);
	cudaMemcpy(h, d, sizeof(int)*N, cudaMemcpyDeviceToHost);

	for(int i=0; i<N; i++)
		std::cout << h[i] << "\n";
}
//12
//12
//12
//12
//12
//12
//12
//12
//12
//12
//1000
//1000
//1000
//1000
//1000
//1000
//1000
//1000
//1000
//1000
