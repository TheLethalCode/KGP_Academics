#include "../include/graph.h"
#include <fstream>
#include <iostream>
#include <algorithm>
#include <random>

Graph::Graph(int argc, char* argv[]) {
    // Take Input Manually
    if (argc == 1 || (argc == 2 && atoi(argv[1]) == 0)) {
        readGraph(std::cin);

    } else if (argc == 3 && atoi(argv[1]) == 1) {
        // Read Input From Dataset File
        std::ifstream graphFile(argv[2]);
        if (!graphFile.is_open()) {
            std::cerr << "Error opening file " << std::endl;
            exit(EXIT_FAILURE);
        }
        readGraph(graphFile);

    } else if (argc >= 4 && argc <= 6 && atoi(argv[1]) == 2) { 
        // Generate Random Graph
        n = atoi(argv[2]), m = atoi(argv[3]);
        int lim = (argc >= 5? atoi(argv[4]): 20);
        int seed = (argc >= 6? atoi(argv[5]): 81);
        genGraph(lim, seed);

    } else {
        std::cerr << "Incorrect Arguments " << std::endl;
        exit(EXIT_FAILURE);
    }
    normGraph();
    convGraph();
}

void Graph::genGraph(int lim, int seed) {
    E.resize(n + 1);
    std::mt19937 rng(seed);
    for (int i = 1, a, b, c; i <= m; i++) {
        a = std::uniform_int_distribution<int>(0, n)(rng);
        b = std::uniform_int_distribution<int>(0, n)(rng);
        c = std::uniform_int_distribution<int>(1, lim)(rng);
        if (a != b) {
            E[a].emplace_back(b, c);
            E[b].emplace_back(a, c);
        }
    }
}

void Graph::readGraph(std::istream& input) {
    input >> n >> m;
    E.resize(n + 1);
    for (int i = 1, a, b, c; i <= m; i++) {
        input >> a >> b >> c;
        if (a != b) {
            E[a].emplace_back(b, c);
            E[b].emplace_back(a, c);
        }
    }
}

void Graph::normGraph() {
    int size = 0;
    for (int i = 0, x; i <= n; i++) {
        std::sort(E[i].begin(), E[i].end());
        auto it = std::unique(E[i].begin(), E[i].end(), [](std::pair<int,int> l, std::pair<int,int> r){
            return l.first == r.first;
        });
        x = it - E[i].begin();
        E[i].resize(x);
        std::shuffle(E[i].begin(), E[i].end(), std::mt19937());
        size += x;
    }
    m = size / 2;
}

void Graph::convGraph() {
    for (int i = 0; i <= n; i++) {
        posV.emplace_back((int)packE.size());
        packE.emplace_back((int)E[i].size());
        packW.emplace_back(0);
        for (auto it : E[i]) {
            packE.emplace_back(it.first);
            packW.emplace_back(it.second);
        }
    }
}

void Graph::printGraph(){
    // std::cout << "----------Graph----------" << std::endl;
    // std::cout << "Num Vertices: " << n << std::endl;
    // std::cout << "Edges: " << m << std::endl;
    std::cout << n << " " << m << std::endl;
    for (int i = 0; i <= n; i++){
        // std::cout << "Vertex " << i <<" : ";
        for (int j = 1; j <= packE[posV[i]]; j++){
            int v = packE[posV[i] + j];
            if (i < v) {
                std::cout << i << " ";
                std::cout << v << " ";
                std::cout << packW[posV[i] + j] << std::endl;
            }
        }
        // std::cout << std::endl;
    }
}