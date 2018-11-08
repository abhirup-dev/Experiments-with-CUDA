#include <iostream>
#include <stdio.h>
#include <cuda.h>

__global__ void myfirstkernel(void)
{
	printf("First msg\n");
}

int main(void)
{
	myfirstkernel <<< 1,1 >>>();
	printf("Hello Cuda\n");
	return 0;
}
