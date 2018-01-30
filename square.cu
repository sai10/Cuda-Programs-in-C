#include<stdio.h>
#include<cuda.h>

//	KERNEL
__global__ 
void Square(float * d_out, float * d_in){
	int idx = threadIdx.x;
	float f = d_in[idx];
	d_out[idx] = f*f;
}

int main(int argc, char ** argv){

	const int ARRAY_SIZE = 64;
	const int ARRAY_BYTES = ARRAY_SIZE * sizeof(float);

//	GENERATING INPUT ARRAY IN HOST
	float h_in[ARRAY_SIZE];
	for(int i=0;i<64;i++)
		h_in[i] = float(i);

	float h_out[ARRAY_SIZE];

//	DESCRIBING GPU MEMORY POINTERS
	float *d_in;
	float *d_out;

//	 ALLOCATING MEMORY IN GPU
	cudaMalloc((void**)&d_in,ARRAY_BYTES);
	cudaMalloc((void**)&d_out,ARRAY_BYTES);	

//	TRANSFER THE ARRAY TO GPU
	cudaMemcpy(d_in,h_in,ARRAY_BYTES,cudaMemcpyHostToDevice);
	
//	LAUNCH THE KERNEL
	Square<<<1,ARRAY_SIZE>>>(d_out,d_in);

//	TRANSFER THE ARRAY BACK TO CPU
	cudaMemcpy(h_out,d_out,ARRAY_BYTES,cudaMemcpyDeviceToHost);

//	DISPLAYING THE RESULT
	for(int i=0; i<ARRAY_SIZE;i++){
		printf("%f",h_out[i]);
		printf(((i%4)!=3)?"\t":"\n");
	}
}
