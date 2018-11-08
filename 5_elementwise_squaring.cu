#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>
#include <cuda_runtime.h>
#include <vector>
#include <algorithm>
#define num 10000000

__global__ void gpuSquare(int *d_a, int *d_b, int N=num)
{
	int tid = blockIdx.x;
	if(tid < N)
		d_b[tid] = d_a[tid] * d_a[tid];
}
void cpuSquare(std::vector<int> &h_a, std::vector<int> &h_b)
{
	for(int i=0; i<h_a.size(); i++)
		h_b[i] = h_a[i]*h_a[i];
}
int main(void)
{
//	int N;
//	std::cout << "N?";
//	std::cin >> N;
	int N=num;
	std::cout << "N is " << num << "\n";
	int *d_a, *d_b;//device pointer to store answer
	std::cout <<"Device allocate.. ";
	cudaMalloc((void**)&d_a, N*sizeof(int));
	cudaMalloc((void**)&d_b, N*sizeof(int));
	std::vector<int> h_a(N), h_b(N);
	std::cout << "Allocated\n";
	for(int i=0; i<N; i++)
	{
		h_a[i] = i;
	}
	std::cout << "Finished!!!\n";
	//copy host to device
	cudaMemcpy(&d_a, h_a.data(), N*sizeof(int), cudaMemcpyHostToDevice);
	std::cout << "Ported to device\n";
	clock_t start,end;
	start = clock();
	cpuSquare(h_a, h_b);
	end = clock();
	std:: cout << "CPU time: " << (double)(end-start)/ CLOCKS_PER_SEC << "\n";
	start = clock();
	gpuSquare <<<N, 1>>> (d_a, d_b);
//	cudaDeviceSynchronize();
	cudaThreadSynchronize();
	end = clock();
	std:: cout << "GPU time: " << (double)(end-start)/ CLOCKS_PER_SEC <<'\n';

//	free(h_a);
//	free(h_b);
//	free(h_c);
	cudaFree(d_a);
	cudaFree(d_b);
	return 0;
}
