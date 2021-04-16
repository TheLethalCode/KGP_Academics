#include "../include/core.h"
#include "../include/graph.h"
#include "../include/BFSutils.h"
#include "../include/algoCPU.h"
#include <iostream>
#include <chrono>
#include <vector>
#include <utility>
#include <cuda.h>
#include <cuda_runtime.h>

#define NUM_THREADS 1024

int main(int argc, char* argv[]) {

    int s;
    Graph G(argc, argv);
    // G.printGraph();
    std::cout << "Source Vertex: ";
    std::cin >> s;
    // ========================= CUDA ============================= //
      
    cudaEventCreate(&start);
    cudaEventCreate(&stop);

    // Declare and Initialise Host Array
    int N, level, queueSize, Es;
    int *V, *E, *D, *P;
    N = vecToArr(G.posV, &V);
    Es = vecToArr(G.packE, &E);
    D = new int[N];
    P = new int[N];
    std::fill_n(D, N, INF);
    std::fill_n(P, N, -1);
    D[s] = level = 0; // Update source values
    queueSize = 1;

    int *nextQueueSize;
    cudaMallocHost((void **) &nextQueueSize, sizeof(int));
    *nextQueueSize = 0;
    // Declare and Initialise Device Array
    int *devV, *devE, *devD, *devP;
    int *devCurrentQueue, *devNextQueue;
    allocCopy<int>(&devV, V, N, "V_a");
    allocCopy<int>(&devE, E, Es, "E_a");
    allocCopy<int>(&devD, D, N, "D_a");
    allocCopy<int>(&devP, P, N, "P_a");
    alloc<int>(&devCurrentQueue, N, "devCurrentQueue");
    alloc<int>(&devNextQueue, N, "devNextQueue");

    int firstElemQueue = s;
    cudaMemcpy(devCurrentQueue, &firstElemQueue, sizeof(int), cudaMemcpyHostToDevice);
    
    // Run Cuda Parallel
    int blocks = (N + NUM_THREADS - 1) / NUM_THREADS;
    cudaEventRecord(start);
    while (queueSize) {
        queueBfs<<< blocks, NUM_THREADS >>>(level, devV, devE, devD, devP, queueSize, nextQueueSize, devCurrentQueue, devNextQueue);
        cudaDeviceSynchronize();
        level += 1;
        queueSize = *nextQueueSize;
        *nextQueueSize = 0;
        std::swap(devCurrentQueue, devNextQueue);
    }
    cudaEventRecord(stop);
    cudaCheck(cudaPeekAtLastError());
    if (cudaCheck(cudaMemcpy(D, devD, N * sizeof(int), cudaMemcpyDeviceToHost))) {
        std::cout << "Obtained distance in host at D_a" << std::endl;
    }

    // Calculate Time Taken
    cudaEventSynchronize(stop);
    float timeGPU = 0;
    cudaEventElapsedTime(&timeGPU, start, stop);

    // Free memory
    clear<int>(devV, "devV");
    clear<int>(devE, "devE");
    clear<int>(devD, "devD");
    clear<int>(devP, "devP");
    clear<int>(devCurrentQueue, "devCurrentQueue");
    clear<int>(devNextQueue, "devNextQueue");
    
    // ========================= CPU ============================= //
    int *dis = new int[N];
    int *parent = new int[N];
    bool *visited = new bool[N];
    std::fill_n(dis, N, INF);
    std::fill_n(parent, N, -1);
    std::fill_n(visited, N, false);
    auto beg = std::chrono::high_resolution_clock::now();
    bfsCPU(s, G, dis, parent, visited);
    auto end = std::chrono::high_resolution_clock::now();
    float timeCPU = std::chrono::duration_cast<std::chrono::microseconds>(end - beg).count();

    std::cout << "CUDA Elapsed Time (in ms): " << timeGPU << std::endl;
    std::cout << "CPU  Elapsed Time (in ms): " << timeCPU / 1000 << std::endl;

    // ======================= Verification ==========================//
    for (int i = 0; i < N; i++) {
        if (dis[i] != D[i]) {
            std::cout << "Not a Match at " << i << std::endl;
            std::cout << "GPU dist: " << D[i] << std::endl;
            std::cout << "CPU dist: " << dis[i] << std::endl;
            exit(EXIT_FAILURE);
        }
    }
}
