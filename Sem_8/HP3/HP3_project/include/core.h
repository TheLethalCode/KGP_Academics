#ifndef CUDA_CORE
#define CUDA_CORE
#include <cuda.h>
#include <cuda_runtime.h>
#include <string>
#include <vector>
#include <iostream>

bool cudaCheck(cudaError_t);
void DeviceProp();
int vecToArr(std::vector< int >&, int**);

template<typename T>
void allocCopy(T **devV, T *V, int n, std::string s) {
    if (cudaCheck(cudaMalloc((void **)devV, sizeof(T)*n)) &&
          cudaCheck(cudaMemcpy(*devV, V, sizeof(T)*n, cudaMemcpyHostToDevice))) {
        std::cout << "Allocated memory and copied " << s << " to device" << std::endl;
    }
}

template<typename T>
void alloc(T **devV, int n, std::string s) {
    if (cudaCheck(cudaMalloc((void **)devV, sizeof(T)*n))) {
        std::cout << "Allocated memory to " << s << " in device" << std::endl;
    }
}

template<class T>
void clear(T *V, std::string s){
    if (cudaCheck(cudaFree(V))) {
        std::cout << "Device memory from " << s << " freed" << std::endl;
    }
}

cudaEvent_t start, stop;

#endif