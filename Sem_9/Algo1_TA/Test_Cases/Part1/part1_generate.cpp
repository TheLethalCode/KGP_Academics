#include<bits/stdc++.h>
#include <ext/pb_ds/assoc_container.hpp>
#include <ext/pb_ds/tree_policy.hpp>
using namespace __gnu_pbds;
using namespace std;

#define mod 1000000007
#define lli long long
#define fi first
#define se second
#define ordered_set tree<int, null_type, less<int>, rb_tree_tag, tree_order_statistics_node_update>
#define C1 200005
#define C2 2005

const int NUM_LIM = 100;

int main(int argc, char **argv)
{
    ios::sync_with_stdio(0);
    cin.tie(0);
    mt19937 rng(time(nullptr));
    int SUM_LIM = 350;
    
    int test_cases = 0, sum_cases = 0;
    set < vector < int > > tests;
    auto sizeDis = uniform_int_distribution<int>(1, 5);
    auto healthDis = uniform_int_distribution<int>(1, 5);
    auto valueDis = uniform_int_distribution<int>(-10, 10);
    while (test_cases < NUM_LIM && sum_cases < SUM_LIM) {
        int size = sizeDis(rng);
        int health = healthDis(rng);
        
        vector < int > temp = {size, health};
        for (int i = 0; i < size; i++) {
            temp.push_back(valueDis(rng));
        }
        if (tests.insert(temp).second) {
            test_cases++;
            sum_cases += size;
        } 
    }
    cout << tests.size() << endl;
    for (auto &test: tests) {
        cout << test[0] << " " << test[1] << endl;
        for (int j = 2; j < test.size(); j++) {
            cout << test[j] << " ";
        }
        cout << endl;
    }
}