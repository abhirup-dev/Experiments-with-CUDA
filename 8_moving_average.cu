#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>
#include <cuda_runtime.h>
#define N 10
__global__ void gpu_shared_mem(float *d)
{
	int i, idx = threadIdx.x;
	float avg, sum=0.0;

	//Defining shared memory
	__shared__ float sh_arr[N];
	sh_arr[idx] = d[idx];

	__syncthreads();

	for(i=0; i<=idx; i++)
		sum += sh_arr[i];
	avg = sum / (idx+1.0f);

	d[idx] = avg;
}
int main(void)
{
	float h[10], *d;
	for(int i=0; i<N; i++)
		h[i] = i;

	cudaMalloc(&d, sizeof(float)*N);
	cudaMemcpy(d, h, sizeof(float)*N, cudaMemcpyHostToDevice);

	gpu_shared_mem<<<1, N>>>(d);

	cudaMemcpy(h, d, sizeof(float)*N, cudaMemcpyDeviceToHost);

	printf("Averaged array: ");
	for(int i=0; i<N; i++)
		printf("%f ", h[i]);
	printf("\n");

}
