__global__`
void rgba_to_greyscale(const uchar4* const rgbaImage,
               unsigned char* const greyImage,
               int numRows, int numCols)
{`

int pos_x = (blockIdx.x * blockDim.x) + threadIdx.x;
int pos_y = (blockIdx.y * blockDim.y) + threadIdx.y;
if(pos_x >= numCols || pos_y >= numRows)
    return;

uchar4 rgba = rgbaImage[pos_x + pos_y * numCols];
greyImage[pos_x + pos_y * numCols] = (.299f * rgba.x + .587f * rgba.y + .114f * rgba.z); 

}

void your_rgba_to_greyscale(const uchar4 * const h_rgbaImage,
                            uchar4 * const d_rgbaImage,
                            unsigned char* const d_greyImage,
                            size_t numRows,
                            size_t numCols)
{
  //You must fill in the correct sizes for the blockSize and gridSize
  //currently only one block with one thread is being launched
  const dim3 blockSize(numCols/32, numCols/32 , 1);  //TODO
  const dim3 gridSize(numRows/12, numRows/12 , 1);  //TODO
  rgba_to_greyscale<<<gridSize, blockSize>>>(d_rgbaImage,
                                             d_greyImage,
                                             numRows,
                                             numCols);

  cudaDeviceSynchronize(); checkCudaErrors(cudaGetLastError());
}
