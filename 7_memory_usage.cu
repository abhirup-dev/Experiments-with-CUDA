#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>
#include <cuda_runtime.h>

#define N 5

__global__ void gpu_global_memory(int *d_a)
{
	d_a[threadIdx.x] = threadIdx.x;
}
__global__ void gpu_local_memory(int d_in)
{
	int t_local;
	t_local = d_in * threadIdx.x;
	printf("Val of local var in current thread is %d\n", t_local);
}
__global__ void gpu_shared_memory(float *d_a)
{
	int i, idx = threadIdx.x;
}
int main(void)
{
	int h_a[N]; int *d_a;

	//	writing in Global Memory
	cudaMalloc(&d_a, N*sizeof(int));
	cudaMemcpy(d_a, h_a, N*sizeof(int), cudaMemcpyHostToDevice);
	gpu_global_memory<<<1,N>>>(d_a);
	cudaDeviceSynchronize();
	cudaMemcpy(h_a, d_a, N*sizeof(int), cudaMemcpyDeviceToHost);
	printf("Array in Global Memory is: \n");
	for(int i=0; i<N; i++)
		printf("At Index: %d --> %d \n", i, h_a[i]);

	// writing in Local Memory
	printf("Use of Local memory on GPU.\n");
	gpu_local_memory <<<1,N>>>(5);
	cudaDeviceSynchronize();
}
