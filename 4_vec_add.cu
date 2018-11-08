#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>
#include <cuda_runtime.h>
#include <vector>
#define num 25

__global__ void gpuAdd(int *d_a, int *d_b, int* d_c, int N=num)
{
	int tid = blockIdx.x;
	if(tid < N)
	{
		d_c[tid] = d_a[tid] + d_b[tid];
		printf("%d + %d = %d\n", d_a[tid], d_b[tid], d_c[tid]);
	}
}
void cpuAdd(int *h_a, int *h_b, int *h_c, int N=num)
{
	for(int i = 0; i < N; i++)
		h_c[i] = h_a[i] + h_b[i];
}
void cpuAdd_vec(std::vector<int> &h_a, std::vector<int> &h_b, std::vector<int> &h_c, int N=num)
{
	for(int i = 0; i < N; i++)
		h_c[i] = h_a[i] + h_b[i];
}
int main(void)
{
//	int N;
//	std::cout << "N?";
//	std::cin >> N;
	int N=num;
	std::cout << "N is " << num << "\n";
	int *d_a, *d_b, *d_c;//device pointer to store answer
	std::cout <<"Device allocate.. ";
	cudaMalloc((void**)&d_a, N*sizeof(int));
	cudaMalloc((void**)&d_b, N*sizeof(int));
	cudaMalloc((void**)&d_c, N*sizeof(int));
	std::vector<int> h_a(N), h_b(N), h_c(N);
//	int
//		*h_a = (int*)malloc(N*sizeof(int)),
//		*h_b = (int*)malloc(N*sizeof(int)),
//		*h_c = (int*)malloc(N*sizeof(int));
	std::cout << "Allocated\n";
	for(int i=0; i<N; i++)
	{
		h_a[i] = i;
		h_b[i] = i * i;
		h_c[i] = i;
	}
	std::cout << "Finished!!!\n";
	//copy host to device
	cudaMemcpy(d_a, h_a.data(), N*sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(d_b, h_b.data(), N*sizeof(int), cudaMemcpyHostToDevice);
	std::cout << "Ported to device\n";


	clock_t start, end;
//	start = clock();
////	cpuAdd(h_a, h_b, h_c);
//	cpuAdd_vec(h_a, h_b, h_c);
//	end = clock();
//	std:: cout << "CPU time: " << (double)(end-start)/ CLOCKS_PER_SEC << "\n";
	start = clock();
	gpuAdd <<<N, 1>>> (d_a, d_b, d_c, N);
	cudaDeviceSynchronize();
	end = clock();
	std:: cout << "GPU time: " << (double)(end-start)/ CLOCKS_PER_SEC <<'\n';

//	free(h_a);
//	free(h_b);
//	free(h_c);
	cudaFree(d_a);
	cudaFree(d_b);
	cudaFree(d_c);
	return 0;
}
