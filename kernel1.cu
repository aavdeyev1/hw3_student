#include <stdio.h>
#include "kernel1.h"


//extern  __shared__  float sdata[];

////////////////////////////////////////////////////////////////////////////////
//! Weighted Jacobi Iteration
//! @param g_dataA  input data in global memory
//! @param g_dataB  output data in global memory
////////////////////////////////////////////////////////////////////////////////
__global__ void k1( float* g_dataA, float* g_dataB, int floatpitch, int width) //float pitch is the number of float values in each row of the padded array...we need to offset the float ptch on each row
{
		// use width to disable threads out of array boundry. use floatpitch when doing global memory access.
    extern __shared__ float s_data[];
		s_data 
    // TODO, implement this kernel below
	
	//global thread ID's//for reading global mem
	int idX = blockIdx.x * blockDim.x + threadIdx.x + 1;//column
	int idY = blockIdx.y * blockDim.y + threadIdx.y + 1;//row
	int mid_row = blockIdx.y + 1;
	int st_col = blockDim.x * blockIdx.x; 
	int shared_row = 0;
	//make sure we are within bounds of input array.	
	if(idX >= (width - 1) || idY >= (width -1) || idX < 1 || idY < 1){
		return;
	}
	
	
	//read input to shared mem- > global
	//each thread has to read
	//if you are thread 0 or blockDim.x you have to do 
	  if(threadIdx.x == 0){
		  shared_row = 0;
			for(int i =mid_row - 1 ; i <= mid_row + 1; i++){			
				s_data[shared_row*(blockDim.x+2) + threadIdx.x] = g_dataA[ st_col + (i*floatpitch) + threadIdx.x];
				shared_row++;
			}
	  }
		if (idX == width-2) {
			shared_row = 0;
			for(int i = mid_row - 1 ; i <= mid_row + 1; i++){			
				s_data[shared_row*(blockDim.x+2)+ 2 + threadIdx.x] = g_dataA[ (st_col + 2) + (i*floatpitch) + threadIdx.x];
				shared_row++;
			}
		}
		else if (threadIdx.x == blockDim.x - 1){//
			shared_row = 0;
			for(int i = mid_row - 1 ; i <= mid_row + 1; i++){			
				s_data[shared_row*(blockDim.x+2)+ 2 + threadIdx.x] = g_dataA[ (st_col + 2) + (i*floatpitch) + threadIdx.x];
				shared_row++;
			}
	  }
	//everybody reads 3 elements
    shared_row = 0;
    for(int i = mid_row - 1 ; i <= mid_row + 1; i++){			
        s_data[shared_row*(blockDim.x+2)+ 1 + threadIdx.x] = g_dataA[ (st_col + 1) + (i*floatpitch) + threadIdx.x];
        shared_row++;
    }
	
	__syncthreads();
	//sync threads
    int s_rowwidth = blockDim.x +2;
	// //do the math
    g_dataB[st_col + 1 + threadIdx.x + floatpitch * mid_row] = (                                                        
    .1*(s_data[threadIdx.x])    +
    .1*(s_data[threadIdx.x+1])  +
    .1*(s_data[threadIdx.x+2])  +
    
    .1*(s_data[(s_rowwidth*1) + threadIdx.x])      +
    .2*(s_data[(s_rowwidth*1) + threadIdx.x + 1])  +
    .1*(s_data[(s_rowwidth*1) + threadIdx.x + 2])  +
    
    .1*(s_data[(s_rowwidth*2) + threadIdx.x])      +
    .1*(s_data[(s_rowwidth*2) + threadIdx.x + 1])  +
    .1*(s_data[(s_rowwidth*2) + threadIdx.x + 2])    ) * 0.95; 
	//write the result   
}

