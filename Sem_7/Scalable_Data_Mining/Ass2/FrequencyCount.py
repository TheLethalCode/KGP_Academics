# -*- coding: utf-8 -*-
import numpy as np
from collections import Counter
import mmh3
import matplotlib.pyplot as plt

# data generation parameter
"""### **Frequent Count Algorithms**
1. Misra-Gries
2. Space-saving
3. Count-min
"""

# frequency count algorithms parameter
num_counters = 10
class MISRA(object):
    def __init__(self, stream):
        self.k = num_counters
        self.counters = Counter()
        for item in stream:
            ## case 1: item already has counter or there are empty counters
            if item in self.counters or len(self.counters) < self.k:
                self.counters[item] += 1

            ## case 2: item doesn't have counter and there are no empty counters
            else:
                for key in list(self.counters.keys()):
                    self.counters[key] -= 1
                    if self.counters[key] == 0:
                        del self.counters[key]
    
    def estimate(self, search):
        return self.counters[search]

    def type(self):
        return "Misra-Gries"


class SPACE(object):
    def __init__(self, stream):
        self.k = num_counters
        self.counters = Counter()
        for item in stream:
            ## case 1: item already has counter or there are empty counters
            if item in self.counters or len(self.counters) < self.k:
                self.counters[item] += 1
            ## case 2: item doesn't have counter and there are no empty counters
            else:
                min_key = min(self.counters, key = self.counters.get)
                self.counters[min_key] += 1
                self.counters[item] = self.counters.pop(min_key)
        
    def estimate(self, search):
        return self.counters[search]

    def type(self):
        return "Space-Saving"


class COUNT(object):
    ''' Class for a CountMinSketch data structure
    '''
    def __init__(self, stream):
        ''' Method to initialize the data structure
        @param width int: Width of the table
        @param depth int: Depth of the table (num of hash func)
        @param seeds list: Random seed list
        '''
        self.width = 100
        self.depth = 10
        self.table = np.zeros([self.depth, self.width])  # Create empty table
        self.seed = np.random.randint(self.width, size = self.depth) # np.random.randint(w, size = d) // create some seeds
        self.n = len(stream)
        for item in stream:
            self.increment(str(item))

    def increment(self, key):
        ''' Method to add a key to the CMS
        @param key str: A string to add to the CMS
        '''
        for i in range(0, self.depth):
            index = mmh3.hash(key, self.seed[i]) % self.width
            self.table[i, index] = self.table[i, index]+1

    def estimate(self, key):
        ''' Method to estimate if a key is in a CMS
        @param key str: A string to check
        '''
        min_est = self.n + 1
        key = str(key)
        for i in range(0, self.depth):
            index = mmh3.hash(key, self.seed[i]) % self.width
            if self.table[i, index] < min_est:
                min_est = self.table[i, index]
        return min_est

    def type(self):
        return "Count-min Sketch"


stream_length = 1000
class NORM(object):

    def __init__(self, cnt = 100):
        self.count = cnt

    def dist(self):
        for _ in range(self.count):
            yield np.random.normal(0, np.random.uniform(40, 500), stream_length).astype(int)

    def type(self):
        return "Normal"


class GAMMA(object):
    
    def __init__(self, cnt = 100):
        self.count = cnt

    def dist(self):
        for _ in range(self.count):
            yield np.random.gamma(np.random.uniform(13, 14), np.random.uniform(10, 300), stream_length).astype(int)

    def type(self):
        return "Gamma"


def plotGraphs(distrs, algos):
    
    plX = {}
    for distr in distrs:                    # Type of distribution    
        distObj = distr()
        disTy = distObj.type()

        plX[disTy] = {}

        for data in distObj.dist():             # Generate 100 data 

            freq_orig = Counter(data)

            # Calculate Entropy of Data
            entr = np.array([item[1] for item in freq_orig.most_common()])
            entr = entr/np.sum(entr)
            entr = (-entr * np.log2(entr)).sum()
            
            for algo in algos:              # Type of algorithm

                # Create object
                algoObj = algo(data)
                algTy = algoObj.type()
                if algTy not in plX[disTy]:
                    plX[disTy][algTy] = []

                size = np.ceil(0.1 * len(freq_orig)).astype(int)

                # Calculate error of estimates
                totErr = 0
                for item in freq_orig.most_common(size):
                    estimate = algoObj.estimate(item[0])
                    totErr += np.abs(item[1] - estimate)
                totErr /= size

                # Append the data to the plot data
                plX[disTy][algTy].append((entr, totErr))


    for dist in plX:
        for algo in plX[dist]:
            plX[dist][algo].sort()
            plt.plot([it[0] for it in plX[dist][algo]], [it[1] for it in plX[dist][algo]])
            plt.xlabel("Entropy")
            plt.ylabel("Error")
            plt.title("{} distribution - {} Algorithm".format(dist, algo))
            plt.show()


if __name__ == "__main__":

    distr = [NORM]
    algo = [COUNT]
    plotGraphs(distr, algo)