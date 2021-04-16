#include "../include/core.h"
#include "../include/graph.h"
#include "../include/SSSPutils.h"
#include "../include/algoCPU.h"
#include <iostream>
#include <chrono>
#include <vector>
#include <utility>

#define NUM_THREADS 256

int main(int argc, char* argv[]) {

    Graph G(argc, argv);
    std::cout << "Graph Created " << std::endl;
    // ========================= CUDA ============================= //
      
    cudaEventCreate(&start);
    cudaEventCreate(&stop);

    // Declare and Initialise Host Array
    int *V, *E, *W, **C, **U, Vs, Es;
    bool **M, flag;
    Vs = vecToArr(G.posV, &V);
    Es = vecToArr(G.packE, &E);
    vecToArr(G.packW, &W);
    C = new int*[Vs];
    U = new int*[Vs];
    M = new bool*[Vs];
    for (int i = 0; i < Vs; i++) {
        C[i] = new int[Vs];
        U[i] = new int[Vs];
        M[i] = new bool[Vs];
        std::fill_n(C[i], Vs, INF);
        std::fill_n(U[i], Vs, INF);
        std::fill_n(M[i], Vs, false);
        C[i][i] = U[i][i] = 0;
        M[i][i] = true;
    }
    
    // Declare and Initialise Device Array
    int *devV, *devE, *devW, *devC, *devU;
    bool *devM, *devFlag;
    allocCopy<int>(&devV, V, Vs, "V_a");
    allocCopy<int>(&devE, E, Es, "E_a");
    allocCopy<int>(&devW, W, Es, "W_a");
    alloc<int>(&devC, Vs, "C_a");
    alloc<int>(&devU, Vs, "U_a");
    alloc<bool>(&devM, Vs, "M_a");
    alloc<bool>(&devFlag, 1, "flag");
    
    // Run Cuda Parallel
    dim3 blocks((Vs + NUM_THREADS - 1) / NUM_THREADS, 1, 1);
    dim3 threads(NUM_THREADS, 1, 1);
    cudaEventRecord(start);
    for (int i = 0; i < Vs; i++) {
        flag = true;
        cudaCheck(cudaMemcpy(devC, C[i], Vs*sizeof(int), cudaMemcpyHostToDevice));
        cudaCheck(cudaMemcpy(devU, U[i], Vs*sizeof(int), cudaMemcpyHostToDevice));
        cudaCheck(cudaMemcpy(devM, M[i], Vs*sizeof(bool), cudaMemcpyHostToDevice));
        while (flag) {
            flag = false;
            cudaMemcpy(devFlag, &flag, sizeof(bool), cudaMemcpyHostToDevice);
            SSSP_kernel1<<< blocks, threads >>>(devV, devE, devW, devM, devC, devU, Vs);
            SSSP_kernel2<<< blocks, threads >>>(devM, devC, devU, devFlag, Vs);
            cudaMemcpy(&flag, devFlag, sizeof(bool), cudaMemcpyDeviceToHost);
        }
        cudaCheck(cudaMemcpy(C[i], devC, Vs*sizeof(int), cudaMemcpyDeviceToHost));
    }
    cudaEventRecord(stop);
    cudaCheck(cudaPeekAtLastError());
    std::cout << "Obtained distance in host at C_a" << std::endl;

    // Free Memory
    clear<int>(devV, "devV");
    clear<int>(devE, "devE");
    clear<int>(devW, "devW");
    clear<int>(devC, "devC");
    clear<int>(devU, "devU");
    clear<bool>(devM, "devM");
    clear<bool>(devFlag, "devFlag");

    // Calculate Time Taken
    cudaEventSynchronize(stop);
    float timeGPU = 0;
    cudaEventElapsedTime(&timeGPU, start, stop);
    std::cout << "CUDA Elapsed Time (in ms): " << timeGPU << std::endl;

    // ========================= CPU ============================= //
    int **dis = new int*[Vs];
    auto beg = std::chrono::high_resolution_clock::now();
    for (int i = 0; i < Vs; i++) {
        dis[i] = new int[Vs];
        std::fill_n(dis[i], Vs, INF);
        djikstraCPU(G, i, dis[i]);
    }
    auto end = std::chrono::high_resolution_clock::now();
    float timeCPU = std::chrono::duration_cast<std::chrono::microseconds>(end - beg).count();
    std::cout << "CPU Elapsed Time (in ms): " << timeCPU / 1000 << std::endl;

    // ======================= Verification ==========================//
    for (int i = 0; i < Vs; i++) {
        for (int j = 0; j < Vs; j++) {
            if (dis[i][j] != C[i][j]) {
                std::cout << "Not a Match at " << i << " " << j << std::endl;
                std::cout << "GPU dist: " << C[i][j] << std::endl;
                std::cout << "CPU dist: " << dis[i][j] << std::endl;
                exit(EXIT_FAILURE);
            }
        }
    }
}