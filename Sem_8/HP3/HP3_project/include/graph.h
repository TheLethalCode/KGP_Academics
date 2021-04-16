#ifndef GRAPH
#define GRAPH
#include <vector>
#include <utility>
#include <iostream>

const int INF = 1e9;

struct Graph {
    int n, m;
    std::vector < std::vector < std::pair< int, int > > > E;
    std::vector < int > posV, packE, packW; 
    Graph (int, char* argv[]);
    void genGraph(int, int);
    void readGraph(std::istream&);
    void normGraph();
    void convGraph();
    void printGraph();
};

#endif