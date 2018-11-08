#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>
#include <cuda_runtime.h>
#include <vector>
#include <algorithm>
#define num 25

__global__ void gpuAdd(int *d_a, int *d_b, int* d_c, int N=num)
{
	printf("%d -- ", threadIdx.x);
	int tid = blockIdx.x*blockDim.x + threadIdx.x;
	int sum=0;
	while(tid < N)
	{
		d_c[tid] = d_a[tid] + d_b[tid];
		printf("#[%d,%d] %d + %d = %d\n", tid,threadIdx.x, d_a[tid], d_b[tid], d_c[tid]);
		tid += blockDim.x * gridDim.x;
//		sum += d_c[tid];
	}
//	printf("#[%d] sum=%d\n", threadIdx.x, sum);
}
void cpuAdd(std::vector<int> &h_a, std::vector<int> &h_b, std::vector<int> &h_c, int N=num)
{
	for(int i = 0; i < N; i++)
		h_c[i] = h_a[i] + h_b[i];
}
int main(void)
{
	int N;
	std::cout << "N?";
	std::cin >> N;
//	int N=num;
	std::cout << "N is " << num << "\n";
	int *d_a, *d_b, *d_c;//device pointer to store answer
	std::cout <<"Device allocate.. ";
	cudaMalloc((void**)&d_a, N*sizeof(int));
	cudaMalloc((void**)&d_b, N*sizeof(int));
	cudaMalloc((void**)&d_c, N*sizeof(int));

//	std::vector<int> h_a(N), h_b(N), h_c(N);
	int
		*h_a = (int*)malloc(N*sizeof(int)),
		*h_b = (int*)malloc(N*sizeof(int)),
		*h_c = (int*)malloc(N*sizeof(int));

	std::cout << "Allocated\n";
	for(int i=0; i<N; i++)
	{
		h_a[i] = i;
		h_b[i] = i * i;
	}
	std::cout << "Finished!!!\n";

	//copy host to device
	cudaMemcpy(d_a, h_a, N*sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(d_b, h_b, N*sizeof(int), cudaMemcpyHostToDevice);
	std::cout << "Ported to device\n";

	clock_t start, end;
	start = clock();
	gpuAdd <<<5, 7>>> (d_a, d_b, d_c, N);
	cudaDeviceSynchronize();
	end = clock();
	std:: cout << "GPU time: " << (double)(end-start)/ CLOCKS_PER_SEC <<'\n';
//	cudaMemcpy(h_c, d_c, N*sizeof(int), cudaMemcpyDeviceToHost);

//	std::for_each(h_c, h_c+N, [](int x){
//		std::cout << x << "\n";
//	});

	free(h_a);
	free(h_b);
	free(h_c);
	cudaFree(d_a);
	cudaFree(d_b);
	cudaFree(d_c);
	return 0;
}
//N?25
//N is 1000000
//Device allocate.. Allocated
//Finished!!!
//Ported to device
//tid #[0] x #[0]
//tid #[1] x #[1]
//tid #[2] x #[2]
//tid #[3] x #[3]
//tid #[4] x #[4]
//tid #[10] x #[0]
//tid #[11] x #[1]
//tid #[12] x #[2]
//tid #[13] x #[3]
//tid #[14] x #[4]
//tid #[5] x #[0]
//tid #[6] x #[1]
//tid #[7] x #[2]
//tid #[8] x #[3]
//tid #[9] x #[4]
//tid #[15] x #[0]
//tid #[16] x #[1]
//tid #[17] x #[2]
//tid #[18] x #[3]
//tid #[19] x #[4]
//tid #[20] x #[0]
//tid #[21] x #[1]
//tid #[22] x #[2]
//tid #[23] x #[3]
//tid #[24] x #[4]
//GPU time: 0.000183
