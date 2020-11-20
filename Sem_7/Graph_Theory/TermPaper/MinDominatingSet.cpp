#include<bits/stdc++.h>
#include <ext/pb_ds/assoc_container.hpp>
#include <ext/pb_ds/tree_policy.hpp>
using namespace __gnu_pbds;
using namespace std;

#define mod 1000000007
#define lli long long
#define fi first
#define se second
#define pb emplace_back
#define FOR(i,n) for(int i=0;i<n;i++)
#define FORR(x,v) for(auto x : v)
#define ordered_set tree<int, null_type, less<int>, rb_tree_tag, tree_order_statistics_node_update>
#define MAXC 200005
// %

const int UP = 32;
const int LIM = 1000;

bool findDom(vector< vector< int > > &adj, vector< int > &cur, int pr, int ind, int size) {
    
    int n = adj.size();
    
    if (ind == size) {
        set < int > covered;
        for (int v : cur) {
            // Add vertex to the covered
            covered.insert(v);

            // Check its outneighbours
            for (int to = 0; to < n; to++) {
                if (adj[v][to]) {
                    covered.insert(to);
                }
            }
        }
        if (covered.size() == n) {
            return true;
        }
        return false;
    }

    // Enumerate all possible subsets of size `size`
    for (int now = pr; now < n; now++) {
        cur[ind] = now;
        if (findDom(adj, cur, now + 1, ind + 1, size)) {
            return true;
        }
    }
    return false;
}


int domSet(vector< vector< int > > &adj) {
    
    int n = adj.size();
    
    // Iterate on the size of the dominating set
    for (int size = 1; ; size++) {
        
        vector< int > curDom(size);

        // Check if it has a dominating set of size `size`
        if(findDom(adj, curDom, 0, 0, size)) {
            return size;
        }
    }
}

int main(int argc, char **argv)
{
    // Initialising Random Engine
    mt19937 rng(chrono::steady_clock::now().time_since_epoch().count());
    uniform_real_distribution<double> dist(0.0, 1.0);

    cout << fixed << setprecision(3);
    cout << "Calculating Statistics on Size of Minimum Dominating Set of Random Tournaments\n";
    cout << "Till Tournament Size "<< UP << "\n\n";
    for (int size = 3; size <= UP; size++) {
        
        int tot = min(1LL<<size, (lli)LIM);
        
        cout << "SIZE = " << size << "\n";
        cout << "Generating " << tot << " random tournaments\n" << endl;

        int sum = 0, small = size, big = 1;
        for (int tour = 1; tour <= tot; tour++){
            
            // Generating Random Tournaments
            vector< vector< int > > adj(size, vector<int>(size, 0));
            for (int sm = 0; sm < size; sm++) {
                for (int bi = sm + 1; bi < size; bi++) {
                    adj[sm][bi] = 1;
                    if (dist(rng) < 0.5) {
                        swap(adj[sm][bi], adj[bi][sm]);
                    }
                }
            }

            // Finding min dominating set
            int minDom = domSet(adj);

            // Update statistics
            small = min(small, minDom);
            big = max(big, minDom);
            sum += minDom; 
        }

        cout << "Average:- " << sum * 1.0 / tot << endl;
        cout << "Minimum:- " << small << endl;
        cout << "Maximum:- " << big << endl;
        cin.ignore();
    }
}