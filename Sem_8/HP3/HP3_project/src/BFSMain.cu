#include "../include/core.h"
#include "../include/graph.h"
#include "../include/BFSutils.h"
#include "../include/algoCPU.h"
#include <iostream>
#include <chrono>
#include <vector>
#include <utility>

#define NUM_THREADS 1024

int main(int argc, char* argv[]) {

    int s;
    Graph G(argc, argv);
    std::cout << "Source Vertex: ";
    std::cin >> s;
    // ========================= CUDA ============================= //
      
    cudaEventCreate(&start);
    cudaEventCreate(&stop);

    // Declare and Initialise Host Array
    int N, level, flag, Es;
    int *V, *E, *D, *P;
    N = vecToArr(G.posV, &V);
    Es = vecToArr(G.packE, &E);
    D = new int[N];
    P = new int[N];
    std::fill_n(D, N, INF);
    std::fill_n(P, N, -1);
    D[s] = level = 0; // Update source values
    flag = 1;

    // Declare and Initialise Device Array
    int *devFlag;
    int *devV, *devE, *devD, *devP;
    allocCopy<int>(&devV, V, N, "V_a");
    allocCopy<int>(&devE, E, Es, "E_a");
    allocCopy<int>(&devD, D, N, "D_a");
    allocCopy<int>(&devP, P, N, "P_a");
    allocCopy<int>(&devFlag, &flag, 1, "flag");
    
    // Run Cuda Parallel
    int blocks = (N + NUM_THREADS - 1) / NUM_THREADS;
    cudaEventRecord(start);
    while (flag) {
        flag = 0;
        cudaMemcpy(devFlag, &flag, sizeof(int), cudaMemcpyHostToDevice);
        BFS_kernel<<< blocks, NUM_THREADS >>>(N, level, devV, devE, devD, devP, devFlag);
        level += 1;
        cudaMemcpy(&flag, devFlag, sizeof(int), cudaMemcpyDeviceToHost);
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
    clear<int>(devFlag, "devFlag");

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