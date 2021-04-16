#include <cuda.h>
#include <cuda_runtime.h>

__global__ void SSSP_kernel1(int *V, int *E, int *W, bool *M, int *C, int *U, int n) {
    int tid = threadIdx.x + blockIdx.x * blockDim.x;
    if (tid < n && M[tid]) {
        M[tid] = false;
        int pos = V[tid], size = E[pos];
        for (int i = pos + 1; i < pos + size + 1; i++) {
            int nid = E[i];
            atomicMin(&U[nid], C[tid] + W[i]);
        }
    }
}

__global__ void SSSP_kernel2(bool *M, int *C, int *U, bool *flag, int n) {
    int tid = threadIdx.x + blockIdx.x * blockDim.x;
    if (tid < n) {
        if (C[tid] > U[tid]) {
            C[tid] = U[tid];
            M[tid] = true;
            *flag = true;
        }
        U[tid] = C[tid];
    }
}