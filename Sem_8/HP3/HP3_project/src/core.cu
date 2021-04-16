#include <iostream>
#include <vector>

bool cudaCheck(cudaError_t err) {
    if (err != cudaSuccess) {
        std::cerr << "Code Failed due to " << cudaGetErrorString(err) << std::endl;
        exit(EXIT_FAILURE);
    }
    return true;   
}

void printProp(cudaDeviceProp devP) {
    std::cout << "Name: " << devP.name << std::endl;
    std::cout << "\tTotal Global Memory: " << devP.totalGlobalMem << std::endl;
    std::cout << "\tShared Memory per Block: " << devP.sharedMemPerBlock << std::endl;
    std::cout << "\tWarp Size: " << devP.warpSize << std::endl;
    std::cout << "\tMax Threads per Block: " << devP.maxThreadsPerBlock << std::endl;
    std::cout << "\tNumber of multiprocessors: " << devP.multiProcessorCount << std::endl;
    for (int i = 0; i < 3; i++) {
        std::cout << "\tMax of dimension " << i << " of block: " << devP.maxThreadsDim[i] << std::endl;
    }
    for (int i = 0; i < 3; i++) {
         std::cout << "\tMax of dimension " << i << " of grid: " << devP.maxGridSize[i] << std::endl;
    }
}

void DeviceProp() {
    int devCount ;
    cudaGetDeviceCount(&devCount) ;
    for (int i = 0; i < devCount ; ++i) {
        cudaDeviceProp devP;
        cudaGetDeviceProperties(&devP, i);
        printProp(devP);
    }
}

int vecToArr(std::vector< int > &v, int **A) {
    *A = new int[v.size()];
    for (int i = 0; i < v.size(); i++) {
        (*A)[i] = v[i];
    }
    return v.size();
}