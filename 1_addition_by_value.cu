#include <iostream>
#include <stdio.h>
#include <cuda.h>
#include <cuda_runtime.h>

__global__ void gpuAdd(int d_a, int d_b, int* d_c)
{
	*d_c = d_a + d_b;
}
int main(void)
{
	int h_c;//host var to store answer
	int *d_c;//device pointer to store answer

	cudaMalloc((void**) &d_c, sizeof(int));

	gpuAdd << <1, 1 >> > (3, 5, d_c);
	//copy results from device to host
	cudaMemcpy(&h_c, d_c, sizeof(int), cudaMemcpyDeviceToHost);
	printf("3 + 5 = %d\n", h_c);

	cudaFree(d_c);
	return 0;
}
