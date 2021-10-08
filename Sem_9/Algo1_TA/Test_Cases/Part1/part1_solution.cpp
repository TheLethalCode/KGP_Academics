#include <iostream>
#include <cstring>
using namespace std;

void solve() {
    // Get inputs
    int num_elements, answer = 0;
    long long cur_health;
    cin >> num_elements >> cur_health;
    
    // Declare and initialise arrays
    int values[num_elements];   // Array that stores the poison values
    bool included[num_elements];    // Array that stores whether a food is eaten or not
    memset(included, 0, sizeof(included));  // Initalising the array as false

    // Iterate through each food sample
    for (int i = 0; i < num_elements; i++) {
        cin >> values[i];

        // Assume you are eating the food sample
        cur_health += values[i]; 
        included[i] = true;
        answer++;
        
        // If you are dying, try to remove the value of the most poisonest 
        // food sample (most negative) you have eaten till now
        if (cur_health <= 0) {

            // Iterate through all previous food samples and find the smallest one
            // which hasn't been removed yet
            int to_remove = i;  
            for (int j = i - 1; j >= 0; j--) {
                if (included[j] && values[to_remove] > values[j]) {
                    to_remove = j;
                }
            }
            
            // Remove that from the list of food samples to eat
            cur_health -= values[to_remove];
            included[to_remove] = false;
            answer--;
        }
    }

    // Output the answer
    cout << answer << "\n";
}

int main(int argc, char *argv[]) {
    int test_cases;
    cin >> test_cases;
    while (test_cases--) {
        solve();
    }
}