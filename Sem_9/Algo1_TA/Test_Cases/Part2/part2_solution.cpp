#include<iostream>
#include<cstring>

using namespace std;
#define lli long long

// The predicate function for the binary search which checks if a particular strength is achievable
bool check(lli target, int num_pos, lli reserve, int range, lli cover[]) {
    // Declare and initialise required data structures and variables
    lli archers_left = reserve;

    // 'prefix' stores the prefix sum of the newly added reserve archers to that battlement and everything before it. 
    // Here we assume that the battlement stretches past 'num_pos'. All the archers added to these battlements 
    // are in fact only added to <num_pos>th battlement. We do this for the ease of implementation. 
    // Initially initialise everything to 0
    lli prefix[2 * num_pos + 5];                                
    memset(prefix, 0, sizeof(prefix));

    // Iterate through each battlement and see if required number of archers cover it
    // If not, greedily allot more to the right most battlement that can reach this one.
    for (int i = 0; i < num_pos; i++) {
        
        // We calculate the range
        // Here right side is open because we assume it is extending infinitely after num_pos 
        int left = max(1, i + 1 - range), right = i + 1 + range;

        // Calculate prefix for the index we are going to handle i.e. 'right'
        prefix[right] += prefix[right - 1];

        // Subtract original cover as well as the cover from newly allotted archers from the required strenght
        // to get the remaining archers needed. If we do not need any archers (negative amount), just treat it as 0 archers
        lli required = max(0LL, target - cover[i] - (prefix[right] - prefix[left - 1])); 
        
        // If we do not have the required amount of archers, this is not possible
        if (archers_left < required) {
            return false;
        }

        // Add the 'required' archers to the 'right' index. This is a greedy approach where we add the archers
        // to the rightmost reachable to this one so that the allotted archers can cover as many potential
        // 'weak' battlements that comes after this.
        prefix[right] += required;
        archers_left -= required;
    }

    // If we can make all batllements at least have 'target' archers cover it, then we have a wall of that strength.
    // So return true
    return true;
}

void solve() {
    
    // Get the initial inputs
    int num_pos, range;
    lli reserve;
    cin >> num_pos >> reserve >> range;
    
    // Get the number of archers in each battlement and calculate their prefix sum
    lli archers[num_pos], prefix[num_pos + 1];
    prefix[0] = 0;
    for (int i = 0; i < num_pos; i++) {
        cin >> archers[i];
        prefix[i + 1] = prefix[i] + archers[i];
    }

    // Calculate how many archers are covering each battlement
    lli cover[num_pos];
    for (int i = 0; i < num_pos; i++) {
        // The left and right borders for the archers that can reach this battlement
        int left = max(1, i + 1 - range), right = min(i + 1 + range, num_pos);
        cover[i] = prefix[right] - prefix[left - 1];
    }

    // Perform binary search to find out the maximum possible strength
    // The low is the 0 strength, and the high is the number of archers available
    lli low = 0, high = prefix[num_pos] + reserve, ans;
    while (low <= high) {
        lli mid = low + high >> 1;
        // If possible for this range, check whether there is a better solution in the later half
        if (check(mid, num_pos, reserve, range, cover)) {
            ans = mid;
            low = mid + 1;
        } else { // If not possible, check for the lower half
            high = mid - 1;
        }
    }

    // Output the answer
    cout << ans << endl;
}

int main(int argc, char *argv[]) {
    int test_cases;
    cin >> test_cases;
    while (test_cases--) {
        solve();
    }    
}