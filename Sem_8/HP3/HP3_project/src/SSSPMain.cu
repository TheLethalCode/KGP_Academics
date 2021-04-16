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

    int s;
    Graph G(argc, argv);
    std::cout << "Source Vertex: ";
    std::cin >> s;

    // ========================= CUDA ============================= //
      
    cudaEventCreate(&start);
    cudaEventCreate(&stop);

    // Declare and Initialise Host Array
    int *V, *E, *W, *C, *U, Vs, Es;
    bool *M, flag;
    Vs = vecToArr(G.posV, &V);
    Es = vecToArr(G.packE, &E);
    vecToArr(G.packW, &W);
    C = new int[Vs];
    U = new int[Vs];
    M = new bool[Vs];
    std::fill_n(C, Vs, INF);
    std::fill_n(U, Vs, INF);
    std::fill_n(M, Vs, false);
    C[s] = U[s] = 0; // Update source values
    M[s] = flag = true;

    // Declare and Initialise Device Array
    int *devV, *devE, *devW, *devC, *devU;
    bool *devM, *devFlag; 
    allocCopy<int>(&devV, V, Vs, "V_a");
    allocCopy<int>(&devE, E, Es, "E_a");
    allocCopy<int>(&devW, W, Es, "W_a");
    allocCopy<int>(&devC, C, Vs, "C_a");
    allocCopy<int>(&devU, U, Vs, "U_a");
    allocCopy<bool>(&devM, M, Vs, "M_a");
    allocCopy<bool>(&devFlag, &flag, 1, "flag");
    
    // Run Cuda Parallel
    int blocks = (Vs + NUM_THREADS - 1) / NUM_THREADS;
    cudaEventRecord(start);
    while (flag) {
        flag = false;
        cudaMemcpy(devFlag, &flag, sizeof(bool), cudaMemcpyHostToDevice);
        SSSP_kernel1<<< blocks, NUM_THREADS >>>(devV, devE, devW, devM, devC, devU, Vs);
        SSSP_kernel2<<< blocks, NUM_THREADS >>>(devM, devC, devU, devFlag, Vs);
        cudaMemcpy(&flag, devFlag, sizeof(bool), cudaMemcpyDeviceToHost);
    }
    cudaEventRecord(stop);
    cudaCheck(cudaPeekAtLastError());
    if (cudaCheck(cudaMemcpy(C, devC, Vs * sizeof(int), cudaMemcpyDeviceToHost))) {
        std::cout << "Obtained distance in host at C_a" << std::endl;
    }

    // Free memory
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
    int *dis = new int[Vs];
    std::fill_n(dis, Vs, INF);
    auto beg = std::chrono::high_resolution_clock::now();
    djikstraCPU(G, s, dis);
    auto end = std::chrono::high_resolution_clock::now();
    float timeCPU = std::chrono::duration_cast<std::chrono::microseconds>(end - beg).count();
    std::cout << "CPU Elapsed Time (in ms): " << timeCPU / 1000 << std::endl;

    // ======================= Verification ==========================//
    for (int i = 0; i < Vs; i++) {
        if (dis[i] != C[i]) {
            std::cout << "Not a Match at " << i << std::endl;
            std::cout << "GPU dist: " << C[i] << std::endl;
            std::cout << "CPU dist: " << dis[i] << std::endl;
            exit(EXIT_FAILURE);
        }
    }
}