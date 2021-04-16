#include "../include/core.h"
#include "../include/graph.h"
#include "../include/APSPutils.h"
#include "../include/algoCPU.h"
#include <iostream>
#include <chrono>
#include <vector>
#include <utility>

#define THREADX 16

int main(int argc, char* argv[]) {

    Graph G(argc, argv);
    std::cout << "Graph Generated " << std::endl;
    // ========================= CUDA ============================= //
      
    cudaEventCreate(&start);
    cudaEventCreate(&stop);

    // Declare and Initialise Host Array
    int **dis, *adj, size = G.n + 1;
    adj = new int[size*size];
    dis = new int*[size];
    for (int i = 0; i <= G.n; i++) {
        dis[i] = new int[size];
        for (int j = 0; j <= G.n; j++) {
            adj[i*size + j] = dis[i][j] = INF;
        }
        adj[i*size + i] = dis[i][i] = 0;
        for (auto v : G.E[i]) {
            adj[i*size + v.first] = dis[i][v.first] = v.second;
        }
    }

    // Declare and Initialise Device Array
    int *devAdj; 
    allocCopy<int>(&devAdj, adj, size*size, "Adj");
    
    // Run Cuda Parallel
    dim3 blocks((size+THREADX-1)/THREADX, (size+THREADX-1)/THREADX, 1);
    dim3 threads(THREADX, THREADX, 1);
    cudaEventRecord(start);
    for (int i = 0; i < size; i++) {
        APSP_kernel1<<< blocks, threads >>>(devAdj, i, size);
    }
    cudaEventRecord(stop);
    cudaCheck(cudaPeekAtLastError());
    if (cudaCheck(cudaMemcpy(adj, devAdj, size*size*sizeof(int), cudaMemcpyDeviceToHost))) {
        std::cout << "Obtained distance in host at adj" << std::endl;
    }

    // Calculate Time Taken
    cudaEventSynchronize(stop);
    float timeGPU = 0;
    cudaEventElapsedTime(&timeGPU, start, stop);
    std::cout << "CUDA Elapsed Time (in ms): " << timeGPU << std::endl;

    // ========================= CPU ============================= //
    auto beg = std::chrono::high_resolution_clock::now();
    floydWarshallCPU(G.n, dis);
    auto end = std::chrono::high_resolution_clock::now();
    float timeCPU = std::chrono::duration_cast<std::chrono::microseconds>(end - beg).count();
    std::cout << "CPU Elapsed Time (in ms): " << timeCPU / 1000 << std::endl;

    // ======================= Verification ==========================//
    for (int i = 0; i <= G.n; i++) {
        for (int j = 0; j <= G.n; j++) {
            if (dis[i][j] != adj[i*size + j]) {
                std::cout << "Not a Match at " << i << " " << j << std::endl;
                std::cout << "GPU dist: " << adj[i*size + j] << std::endl;
                std::cout << "CPU dist: " << dis[i][j] << std::endl;
                exit(EXIT_FAILURE);
            }   
        }
    }
}