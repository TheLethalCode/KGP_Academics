#include "../include/core.h"
#include "../include/graph.h"
#include "../include/APSPutils.h"
#include "../include/algoCPU.h"
#include <iostream>
#include <chrono>
#include <vector>
#include <utility>

int main(int argc, char* argv[]) {
    cudaEvent_t start, stop;

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
    int *graphDevice;
    size_t height = size;
    size_t width = height*sizeof(int);
    size_t pitch;

    cudaCheck(cudaMallocPitch(&graphDevice, &pitch, width, height));
    cudaCheck(cudaMemcpy2D(graphDevice, pitch, adj, width, width, height, cudaMemcpyHostToDevice));

    dim3 gridPhase1(1 ,1, 1);
    dim3 gridPhase2((size - 1) / BLOCK_SIZE + 1, 2 , 1);
    dim3 gridPhase3((size - 1) / BLOCK_SIZE + 1, (size - 1) / BLOCK_SIZE + 1 , 1);
    dim3 dimBlockSize(BLOCK_SIZE, BLOCK_SIZE, 1);
    int numBlock = (size - 1) / BLOCK_SIZE + 1;

    cudaEventRecord(start);
    for(int blockID = 0; blockID < numBlock; ++blockID) {
        // Start dependent phase
        _blocked_fw_independent_ph<<<gridPhase1, dimBlockSize>>>(blockID, pitch / sizeof(int), size, graphDevice);

        // Start partially dependent phase
        _blocked_fw_partial_dependent_ph<<<gridPhase2, dimBlockSize>>>(blockID, pitch / sizeof(int), size, graphDevice);

        // Start independent phase
        _blocked_fw_double_dependent_ph<<<gridPhase3, dimBlockSize>>>(blockID, pitch / sizeof(int), size, graphDevice);
    }
    cudaEventRecord(stop);
    cudaCheck(cudaPeekAtLastError());

    if(cudaCheck(cudaMemcpy2D(adj, width, graphDevice, pitch, width, height, cudaMemcpyDeviceToHost))){
        std::cout << "Obtained distance in host at adj" << std::endl;
    }
    cudaCheck(cudaFree(graphDevice));

    // Time Calculation
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