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
const int SUM_LIM = 100000;

int main(int argc, char **argv)
{
    ios::sync_with_stdio(0);
    cin.tie(0);
    mt19937 rng(time(nullptr));
    int MIN_SZ = 10000, MAX_SZ = 20000;
    int MIN_VAL = 0, MAX_VAL = 1000000000;
    int RANGE_F = 4000;
    lli RES_MIN = 0, RES_MAX = 100000000000000LL;
    
    int test_cases = 0, sum_cases = 0;
    auto sizDis = uniform_int_distribution<int>(MIN_SZ, MAX_SZ);
    auto valueDis = uniform_int_distribution<int>(MIN_VAL, MAX_VAL);
    auto rngDis = uniform_int_distribution<int>(0, RANGE_F);
    auto resDis = uniform_int_distribution<lli>(RES_MIN, RES_MAX);
    vector < vector < lli > > tests;
    while (test_cases < NUM_LIM && SUM_LIM - sum_cases >= (MIN_SZ + MAX_SZ) / 2) {
        int sz = sizDis(rng);
        if (sum_cases + sz <= SUM_LIM) {
            lli reserve = resDis(rng);
            int range = min(rngDis(rng), sz - 1);
            vector < lli > temp = {sz, reserve, range};
            for (int i = 0; i < sz; i++) {
                temp.push_back(valueDis(rng));
            }
            test_cases++;
            sum_cases += sz;
            tests.push_back(temp);
        }
    }
    cout << tests.size() << endl;
    for (int i = 0; i < tests.size(); i++) {
        cout << tests[i][0] << " " << tests[i][1] << " " << tests[i][2] << endl;
        for (int j = 3; j < tests[i].size(); j++) {
            cout << tests[i][j] << " ";
        }
        cout << endl;
    }
}