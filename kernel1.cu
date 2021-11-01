#include <stdio.h>
#include "kernel1.h"


//extern  __shared__  float sdata[];

////////////////////////////////////////////////////////////////////////////////
//! Weighted Jacobi Iteration
//! @param g_dataA  input data in global memory
//! @param g_dataB  output data in global memory
////////////////////////////////////////////////////////////////////////////////
__global__ void k1( float* g_dataA, float* g_dataB, int floatpitch, int width) 
{
    extern __shared__ float s_data[];
    // TODO, implement this kernel below
	
	//global thread ID's//for reading global mem
	int idX = blockIdx.x * blockDim.x + threadIdx.x;//column
	int IdY = blockIdx.y * blockDim.y + threadIdx.y;//row
	int mid_row =blockIdx.y + 1;
	int st_col = blockDim.x * blockIdx.x 
	int shared_row = 0;
	//make sure we are within bounds of input array.	
	if(idX >= width - 2 || idY >= width -2){
		return;
	}
	
	
	//read input to shared mem- > global
	//each thread has to read
	//if you are thread 0 or blockDim.x you have to do 
	  if(threadIdx.x == 0){
		  shared_row = 0;
		for(int i =mid_row - 1 ; i =< mid_row + 1; i++){			
			s_data[j*(blockDim.x+2) + threadIdx.x] = g_dataA[ st_col + (i*width) + threadIdx.x];
			shared_row++;
		}
	  }else if (threadIdx.x = blockDim.x || idX == width - 1){//
		  shared_row = 0;
		for(int i =mid_row - 1 ; i =< mid_row + 1; i++){			
			s_data[j*(blockDim.x+2)+ 2 + threadIdx.x] = g_dataA[ (st_col + 2) + (i*width) + threadIdx.x];
			shared_row++;
		}
	  }
	//everybody reads 3 elements
		shared_row = 0;
		for(int i =mid_row - 1 ; i =< mid_row + 1; i++){			
			s_data[j*(blockDim.x+2)+ 1 + threadIdx.x] = g_dataA[ (st_col + 1) + (i*width) + threadIdx.x];
			shared_row++;
		}
	
	
	
	__syncThreads();
	//sync threads
	
	
	
	
	//do the math
	//write the result
	
	
	
    
}

