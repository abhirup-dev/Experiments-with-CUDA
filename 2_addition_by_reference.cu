#include <iostream>
#include <stdio.h>
#include <cuda.h>
#include <cuda_runtime.h>

__global__ void gpuAdd(int *d_a, int *d_b, int* d_c)
{
	*d_c = *d_a + *d_b;
}
int main(void)
{
	int h_a, h_b, h_c;//host var to store answer
	int *d_a, *d_b, *d_c;//device pointer to store answer
	cudaMalloc((void**)&d_a, sizeof(int));
	cudaMalloc((void**)&d_b, sizeof(int));
	cudaMalloc((void**)&d_c, sizeof(int));

	std::cout << "enter 2 integers?";
	std::cin >> h_a >> h_b;
	//copy host to device
	cudaMemcpy(d_a, &h_a, sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(d_b, &h_b, , cudaMemcpyHostToDevice);
	
	gpuAdd << <1, 1>> > (d_a, d_b, d_c);
	//copy results from device to host
	cudaMemcpy(&h_c, d_c, sizeof(int), cudaMemcpyDeviceToHost);

	printf("%d + %d = %d\n", h_a, h_b, h_c);

	cudaFree(d_a);
	cudaFree(d_b);
	cudaFree(d_c);
	return 0;
}
