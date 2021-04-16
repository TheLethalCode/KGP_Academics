#include "../include/graph.h"
#include <vector>
#include <utility>
#include <algorithm>
#include <set>
#include <queue>

void bfsCPU(int start, Graph &G, int *distance,
                            int *parent, bool *visited) {
    distance[start] = 0;
    parent[start] = start;
    visited[start] = true;
    std::queue<int> Q;
    Q.push(start);

    while (!Q.empty()) {
        int u = Q.front();
        Q.pop();

        for (int i = 1; i <= G.packE[G.posV[u]]; i++) {
            int v = G.packE[G.posV[u]+i];
            if (!visited[v]) {
                visited[v] = true;
                distance[v] = distance[u] + 1;
                parent[v] = i;
                Q.push(v);
            }
        }
    }
}

void djikstraCPU(Graph &G, int s, int *dis) {
    dis[s] = 0;
    std::set < std::pair< int, int > > S;
    S.insert({0, s});
    
    while (!S.empty()) {
        int u = S.begin()->second;
        S.erase(S.begin());
        for (auto v : G.E[u]) {
            if (dis[v.first] > dis[u] + v.second) {
                if (dis[v.first] != INF) {
                    S.erase({dis[v.first], v.first});
                }
                dis[v.first] = dis[u] + v.second;
                S.insert({dis[v.first], v.first});
            }
        }
    }
}

void floydWarshallCPU(int n, int **dis) {
    for (int k = 0; k <= n; k++) {
        for (int i = 0; i <= n; i++) {
            for (int j = 0; j <= n; j++) {
                dis[i][j] = std::min(dis[i][j], dis[i][k] + dis[k][j]);
            }
        }
    }
}