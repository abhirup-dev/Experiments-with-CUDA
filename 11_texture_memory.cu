#include <stdio.h>
#include <iostream>
#include <cuda.h>
#include <cuda_runtime.h>
#include <cmath>

#define N 10
#define num_threads 10
texture <float, 1, cudaReadModeElementType> textureRef;

__global__ void gpu_texture_memory(int n, float *d_out)
{
	int idx = blockIdx.x * blockDim.x + threadIdx.x;
	if(idx < n)
	{
		float temp = tex1D(textureRef, float(idx));
		d_out[idx] = temp*temp;
	}
}
int main()
{
	int num_blocks = std::ceil(N / num_threads);
	float *d_out,
		*h_out = (float*)malloc(N*sizeof(float));
	cudaMalloc(&d_out, sizeof(float)*N);
	float h_in[N];
	for(int i=0; i<N; i++)
		h_in[i] = float(i);

	//define CUDA array
	cudaArray *cuArr;

	//set channel description of array (acc. to texture)
	cudaMallocArray(&cuArr, &textureRef.channelDesc, N, 1);

	//copy to array
	cudaMemcpyToArray(cuArr, 0, 0, h_in, sizeof(float)*N, cudaMemcpyHostToDevice);

	//bind texture to array
	cudaBindTextureToArray(textureRef, cuArr);

	gpu_texture_memory <<<num_blocks, num_threads>>>(N, d_out);

	cudaMemcpy(h_out, d_out, sizeof(float)*N, cudaMemcpyDeviceToHost);

	printf("Use of Texture memory on GPU: \n");
	  // Print the result
    for (int i = 0; i < N; i++)
    {
	  printf("Result at %f is : %f\n", h_in[i],h_out[i]);
    }
    free(h_out);
    cudaFree(d_out);
    cudaFreeArray(cuArr);
    cudaUnbindTexture(textureRef);
}
