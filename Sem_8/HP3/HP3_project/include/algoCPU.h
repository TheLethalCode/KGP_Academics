#ifndef ALGO_CPU
#define ALGO_CPU
#include "graph.h"

void bfsCPU(int start, Graph &G, int *distance,
                            int *parent, bool *visited);
void djikstraCPU(Graph&, int, int*);
void floydWarshallCPU(int, int**);

#endif