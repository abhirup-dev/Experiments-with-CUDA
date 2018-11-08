#include <stdio.h>
#include <iostream>
#include <cuda.h>
#include <cuda_runtime.h>
#include <cmath>

#define N 1024
#define threads_per_block 512

template<typename T>
__global__ void blockwise_dot(T *d_a, T *d_b, T *block_sum)
{
	__shared__ T partial_sum [threads_per_block];
	int tid = blockDim.x * blockIdx.x + threadIdx.x;
	int idx = threadIdx.x;
	T sum=0;

	while(tid < N)
	{
		sum += d_a[tid]*d_b[tid];
		tid += blockDim.x * gridDim.x;
	}

	//store partial sum of threads of current block
	//in quickly accessible shared memory
	partial_sum[idx] = sum;

	//sync all threads
	__syncthreads();

	int i = blockDim.x /2;
	while(i != 0)
	{
		if(idx < i)
			partial_sum[idx] += partial_sum[idx+i];
		__syncthreads();
		i /= 2;
	}

	if(idx == 0)
		block_sum[blockIdx.x] = partial_sum[0];

}

int main()
{
	int num_blocks = std::ceil(float(N)/threads_per_block);
	float h_a[N], h_b[N], *d_a, *d_b, *d_partsum;
	for(int i=0; i<N; i++)
	{
		h_a[i] = i; h_b[i] = 1;
	}

	printf("#blocks %d #threads/block %d\n", num_blocks, threads_per_block);

	cudaMalloc((void**)&d_a, N*sizeof(float));
	cudaMalloc((void**)&d_b, N*sizeof(float));
	cudaMalloc((void**)&d_partsum, num_blocks*sizeof(float));

	cudaMemcpy(d_a, &h_a, N*sizeof(float), cudaMemcpyHostToDevice);
	cudaMemcpy(d_b, &h_b, N*sizeof(float), cudaMemcpyHostToDevice);

	blockwise_dot<float> <<<num_blocks,threads_per_block>>> (d_a, d_b, d_partsum);

	cudaDeviceSynchronize();

	float h_partsum[num_blocks], total_sum=0;
	cudaMemcpy(&h_partsum, d_partsum, num_blocks*sizeof(float), cudaMemcpyDeviceToHost);

	for(int i=0; i<num_blocks; i++)
	{
//		printf("%.3f ", h_partsum[i]);
		total_sum += h_partsum[i];
	}
	std:: cout << "result = " << total_sum << "\n";
}

