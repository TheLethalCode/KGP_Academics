#include <iostream>
#include <fstream>
#include <algorithm>
#include <vector>
#include <queue>
#include <cstring>
#include <iomanip>
#include <numeric>
#include <sys/types.h>
#include <sys/stat.h>

using namespace std;

const int INF = 1000000001;
const long double EPS = 1e-8;

// A class for storing the graph
class graph {
    int maxId, n;
    vector< int > nodes;
    vector< vector< int > > adj, dist, paths;
    void preprocess();
public:
    graph(string);
    vector< int > getNodes();
    long double closeCentre(int);
    long double betweenCentre(int);
    vector< long double > biasedPR();
};

// Initialise the graph (Class constructor)
graph::graph(string PATH) : maxId(0), n(0) {
    
    // Read the graph from the file
    ifstream dataset(PATH);
    vector< pair< int, int> > edges;
    for(int x, y; dataset >> x >> y;) {
        edges.emplace_back(x, y);
        maxId = max(maxId, max(x, y));
    }
    dataset.close();

    // Create the graph by creating an adjacency list
    adj.resize(maxId+1);
    for (auto edge: edges) {
        adj[edge.first].push_back(edge.second);
        adj[edge.second].push_back(edge.first);
    }

    // Remove duplicate edges, and create a node list
    for (int i = 0; i <= maxId; i++) {
        if (!adj[i].empty()) {
            n++, nodes.push_back(i);
            sort(adj[i].begin(), adj[i].end());
            adj[i].resize(unique(adj[i].begin(), adj[i].end())-adj[i].begin());
        }
    }

    // Calculate shortest path and number of shortest path between all pairs
    preprocess();
}

// Function to get a node list
vector< int > graph::getNodes() {
    return nodes;
}

// Using BFS to calculate all pair shortest path and num shortest path
void graph::preprocess() {

    dist.resize(n), paths.resize(n);

    // For every node as a source, calculate the shortest path and 
    // the number of shortest path from source to all nodes using BFS
    for (int s : nodes) {
        
        dist[s].assign(n, INF), paths[s].assign(n, 0);
        queue< int > q;
        q.push(s);
        dist[s][s] = 0, paths[s][s] = 1;

        while (!q.empty()) {
            int u = q.front();
            q.pop();
            // Go through all of its neighbour
            for (int v : adj[u]) {
                if (dist[s][v] < dist[s][u] + 1) {
                    continue;
                }
                // Add the number of paths that lead to v from u to the answer,
                // if it is a shortest path
                if (dist[s][v] > dist[s][u] + 1) {
                    dist[s][v] = dist[s][u] + 1;
                    q.push(v);
                }
                paths[s][v] += paths[s][u];
            }
        }
    }
}

// Using values from dist, calculate closeness centrality according to formula
long double graph::closeCentre(int u) {
    int totDist = accumulate(dist[u].begin(), dist[u].end(), 0);
    return ((long double)n - 1) / totDist;
}

// Using values from dist, calculate betweeness centrality according to formula
long double graph::betweenCentre(int u) {
    long double value = 0;
    // Iterate through every pair of nodes in the graph
    for (int s = 0; s < n; s++) {
        for (int t = s + 1; t < n; t++) {
            // If a shortest path of s to t goes via u, add ratio to answer
            if (s != u && t != u && dist[s][u] + dist[u][t] == dist[s][t]) {
                value += (long double)(paths[s][u] * paths[u][t]) / paths[s][t];        
            }
        }
    }
    return 2 * value / (n-1) / (n-2);
}

vector< long double > graph::biasedPR() {

    vector< long double > PR(n, 0), d(n, 0), PRold(n, 0);
    const long double alp = 0.8;

    // Creating nonuniform preference vector biased towards nodes divisble by 4
    int cnt = (n - 1)/4 + 1;
    long double val = (long double)1 / cnt;
    for (int u : nodes) {
        if (u % 4 == 0) {
            PRold[u] = d[u] = val;
        }
    }

    // Calculate untill Page Rank converges
    bool ok;
    do {
        ok = true;
        for (int u : nodes) {
            // Random walk
            long double t = 0;
            for (int v : adj[u]) {
                t += PRold[v] / adj[v].size();
            }
            // Damping and teleportation
            PR[u] = alp * t + (1 - alp) * d[u];
            // PR already in normalised form as summation of all PRs is 1
            // Check for convergence
            ok &= (abs(PR[u] - PRold[u]) < EPS);
        }
        PRold = PR;
    } while(!ok);
    return PR;
}

// Sort the centrality values and write it in a file
void writeOut(vector< pair< long double, int > > &V, string location) {
    ofstream wri(location, ios::trunc);
    wri << fixed << setprecision(6);
    sort(V.rbegin(), V.rend());
    for (auto val : V) {
        wri << val.second << " " << val.first << endl;
    }
    wri.close();
}

int main(int argc, char *argv[]) {

    graph G("FB.txt"); // Construct graph and preprocess shortest path info

    // Create directory for outputs
    string DIR = "centralities";
    mkdir(DIR.c_str(), 0755);

    vector< pair< long double, int > > V;

    // Calculate Closeness Centrality and write it in a file
    for(int u : G.getNodes()) {
        V.emplace_back(G.closeCentre(u), u);
    }
    writeOut(V, DIR + "/closeness.txt");
    V.clear();

    // Calculate Betweenness Centrality and write in a file
    for(int u : G.getNodes()) {
        V.emplace_back(G.betweenCentre(u), u);
    }
    writeOut(V, DIR + "/betweenness.txt");
    V.clear();

    // Calculate biased Page Rank and write in a file
    auto values = G.biasedPR();
    for (int u : G.getNodes()) {
        V.emplace_back(values[u], u);
    }
    writeOut(V, DIR + "/pagerank.txt");
    V.clear();
}