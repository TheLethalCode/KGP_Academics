# Roll : 17CS30022
# Name : Kousshik Raj
# Assignment No : 4

# coding: utf-8

import numpy as np
import csv

# required parameters
DATASET = "data4_19.csv"
k = 3
iterations = 10


# A function that returns the data from the csv file
def csv_data(filename):

    with open(filename,'rt') as csv_file:
        contents = csv.reader(csv_file)
        data = [row for row in contents]
        return data[:-1]  


# Convert the strings to float
def convert(data_points):

    data = []
    for points in data_points:
        
        temp = []        
        for ind, val in enumerate(points):
            if ind < 4:
                temp.append(float(val))
            else:
                temp.append(val)

        data.append(temp)

    return data


# Calulate the distance between points
def point_dist(a,b):
    return np.sqrt( (a[0] - b[0])**2 + (a[1] - b[1])**2 + (a[2] - b[2])**2 + (a[3] - b[3])**2 )


# Calculating the jaccard distance
def calc_jaccard(A,B):

    intersection = 0
    for ele_A in A:
        if ele_A in B:
            intersection += 1
    
    jacc_dist = 1 - (intersection/(len(A) + len(B) - intersection))
    return jacc_dist


# Initialize the centroids
def initialize(data):
    
    indices = np.random.choice(len(data),3,replace=False)
    centroids = [data[val] for val in indices]
    return centroids


# Assign the points to the cluster whose mean is the closest
def assignment(data,centroids):
    
    clusters = [[] for i in range(k)]

    for point in data:

        min_val, min_ind = 10**9, None

        for i in range(k):
            if point_dist(point, centroids[i]) < min_val:
                min_ind = i
                min_val = point_dist(point, centroids[i])

        clusters[min_ind].append(point)

    return clusters


# Updating the mean of the clusters
def update(clusters):

    centroids = []
    cluster_conv = [[] for i in range(k)]

    for i in range(k):
        cluster_conv[i] = [point[:-1] for point in clusters[i]]
        centroids.append(np.mean(cluster_conv[i],axis=0))
    
    return centroids


# Prints the Jaccard Distance between the ground truth and the clusters
def jaccard(clusters, data):

    ground_truth = {
        keey : []
        for keey in np.unique(np.array(data)[:,4])
    }
    
    for val in data:
        ground_truth[val[4]].append(val)

    for i in range(k):
        print()
        for flower in ground_truth:
            print("Jaccard Distance between Cluster {} and Cluster {}  : {:.3}".format(i+1,flower,calc_jaccard(ground_truth[flower],clusters[i])))


if __name__ == "__main__":

    # Reading the data from the csv files for training and testing
    data_points = csv_data(DATASET)
    
    # Convert the strings to float
    data = convert(data_points)

    # Initialize the centroids
    centroids = initialize(data)
    
    # Performing the required number of iterations
    for i in range(iterations):

        clusters = assignment(data, centroids) # Assigning the clusters to the means
        centroids = update(clusters) # Update the mean
    
    # Printing the Means
    print("\nAfter 10 iterations, the means of the clusters are:-")
    for i in range(k):
        print("Cluster {}: {:.3}, {:.3}, {:.3}, {:.3}".format(i+1,centroids[i][0],centroids[i][1],centroids[i][2],centroids[i][3]))
    
    # Prints the Jaccard Distance
    jaccard(clusters, data)