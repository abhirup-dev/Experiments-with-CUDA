#include "stdio.h"
#include<iostream>
#include <cuda.h>
#include <cuda_runtime.h>

//Defining two constants
__constant__ float constant_f;
__constant__ float constant_g;
#define N 5

//Kernel function for using constant memory
__global__ void gpu_constant_memory(float *d_in, float *d_out)
{
  //Getting thread index for current kernel
  int tid = threadIdx.x;
  d_out[tid] = constant_f*d_in[tid] + constant_g;
}
int main()
{
	float h_x[N], h_y[N], h_f, h_g;
	float *d_x, *d_y;
	h_f = 5; h_g = 10;
	for(int i=0; i<N; i++)
		h_x[i] = i;
	cudaMalloc(&d_x, N*sizeof(float));
	cudaMalloc(&d_y, N*sizeof(float));
	cudaMemcpyToSymbol(constant_f, &h_f, sizeof(float), 0, cudaMemcpyHostToDevice);
	cudaMemcpyToSymbol(constant_g, &h_g, sizeof(float));
	cudaMemcpy(d_x, &h_x, N*sizeof(float), cudaMemcpyHostToDevice);
	gpu_constant_memory<<<1,N>>>(d_x, d_y);

	cudaMemcpy(&h_y, d_y, N*sizeof(float), cudaMemcpyDeviceToHost);

	for(int i=0; i<N; i++)
		printf("%0.3f * %0.3f + %0.3f = %0.3f\n", h_x[i], h_f, h_g, h_y[i]);

	cudaFree(d_x);
	cudaFree(d_y);
}
