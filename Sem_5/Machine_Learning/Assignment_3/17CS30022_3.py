# Roll : 17CS30022
# Name : Kousshik Raj
# Assignment No : 3

# coding: utf-8

import numpy as np
import csv

# The training and testing data file
DATASET = "data3_19.csv"
TESTSET = "test3_19.csv"
iterations = 7

class tree_node:
    def __init__(self, attribute, label, subAttributes):
        self.attribute = attribute
        self.label = label
        self.subAttributes = subAttributes
        self.child = []


# A function that returns the data from the csv file
def csv_data(filename):

    with open(filename,'rt') as csv_file:
        contents = csv.reader(csv_file)
        data = [row for row in contents]
        return np.array(data)    


# Functions for splitting the data
def splitData(data, train):

    # Splitting the training data
    if train:
        features = data[0,:3]
        trainX = data[1:, :3]
        trainY = data[1:, 3]
        return trainX, trainY, features
    
    # Splitting the testing data
    else:
        testX = data[1:, :3]
        testY = data[1:, 3]
        return testX, testY


# A function to find the entropy
def findEntropy(countYes, countNo):

    ratio_yes, ratio_no = countYes/(countYes + countNo), countNo/(countYes + countNo)

    if not (ratio_yes and ratio_no):
        return 0
    
    return -ratio_yes * np.log(ratio_yes) - ratio_no * np.log(ratio_no)


# Finding the best attribute using information gain
def findBestAttribute(trainX, trainY, attributes, entropy):

    gains = []

    for index in range(len(attributes)):

        total_entropy , total_population = 0, 0        
        for indexY in np.unique(trainX[:,index]):
            
            temp = np.where(trainX == indexY)[0]
            
            countYes = ( trainY[temp]=="yes" ).sum()
            countNo = ( trainY[temp]=="no" ).sum()
            
            newEntropy = findEntropy(countYes, countNo)
            total_entropy += temp.shape[0]*newEntropy
            
            total_population += temp.shape[0]
        
        total_entropy /= total_population
        gains.append(entropy - total_entropy)
    
    return gains.index(max(gains))


# Training the classifier using the given dataset
def train(trainX, trainY, attributes):

    countYes = ( trainY == "yes" ).sum()
    countNo = ( trainY == "no" ).sum()
    
    if not countYes:
        return tree_node(None, "no", None)
    
    elif not countNo:
        return tree_node(None, "yes", None)
    
    elif not attributes.shape[0]:
        if countYes > countNo:
            return tree_node(None, "yes", None)
        return tree_node(None, "no", None)

    entropy = findEntropy(countYes, countNo)
    
    bestIndex = findBestAttribute(trainX, trainY, attributes, entropy)
    bestAttribute = attributes[bestIndex]
    subAttributes = np.unique(trainX[:,bestIndex])
    
    node = tree_node(bestAttribute, None, subAttributes)
    
    for attribute in subAttributes:
        
        temp = np.where( trainX == attribute )[0]
        
        newTrainX = np.delete(trainX[temp], bestIndex, 1)
        newTrainY = trainY[temp]
        
        newAttributes = np.delete(attributes, bestIndex)
        
        node.child.append(train(newTrainX, newTrainY, newAttributes))
    
    return node    


# Check if C(x) = y
mp = {'pclass': 0, 'age': 1, 'gender': 2}
def check_data(root, X, Y):

    if root.subAttributes is None:
        return Y == root.label

    for ind,val in enumerate(root.subAttributes):
        if X[mp[root.attribute]] == val:
            return check_data(root.child[ind],X,Y)
        

# Calculate Ei
def caluclate_Ei(dataX, dataY, weight, root):

    N = len(dataX)
    err = 0
    for i in range(N):
        if check_data(root, dataX[i], dataY[i]):
            err += weight[i]

    return err


# Calculate Ai
def caluclate_alpha(err):
    return  0.5 * np.log((1-err)/err)


# Calculate the new weight of data points and classifier weight
def calculate_params(root, dataX, dataY, weight):
    
    err = caluclate_Ei(dataX, dataY, weight, root)
    alpha = caluclate_alpha(err)

    weight_new = []
    for i in range(len(weight)):

        if check_data(root, dataX[i], dataY[i]):
            weight_new.append( weight[i] * np.exp(alpha * -1) )

        else:
            weight_new.append( weight[i] * np.exp(alpha) )

    Z = np.sum(weight_new)
    
    for i in range(len(weight)):
        weight_new[i] /= Z

    return alpha, weight_new


# Choosing dataset based on weights
def select_dataset(trainX, trainY, weight):
    
    N = len(trainX)
    temp = [ind for ind in range(N)]
    new = np.random.choice(temp, N, weight)

    new_X = np.array([trainX[val] for val in new])
    new_Y = np.array([trainY[val] for val in new])

    return new_X, new_Y


# Calculating accuracy
def test(testX, testY, roots, alphas):
    
    N = len(testX)
    choice = ['yes','no']
    count  = 0

    # Go through all test data
    for i in range(N):

        temp, val = -10**9, None
        
        # Go through all possible Y states
        for y_val in choice:
            cur = 0

            # Go through all classifiers
            for j in range(iterations):
                if check_data(roots[j],testX[i],y_val):
                    cur += alphas[j]
            
            # Calculate the maximum
            if temp <= cur:
                temp = cur
                val = y_val

        if val == testY[i]:
            count += 1

    print("Percentage accuracy = {} ".format(count/N))


if __name__ == "__main__":

    # Reading the data from the csv files for training and testing
    training_data = csv_data(DATASET)
    test_data = csv_data(TESTSET)
    
    # Separating the data
    trainX, trainY, attributes = splitData(training_data, True)

    N = len(trainX)

    alpha = [0 for i in range(iterations)]
    roots = [0 for i in range(iterations)]
    weights = [[1/N for i in range(N)] for j in range(iterations+1)]
   
    # Running the adaboost Algorithm    
    for i in range(iterations):
        
        # Choosing the dataset based on weights
        trainXi, trainYi = select_dataset(trainX, trainY, weights[i])

        # Training the dataset
        roots[i] = train(trainXi,trainYi,attributes[:3])    
        
        # Calculate params
        alpha[i], weights[i+1] = calculate_params(roots[i], trainX, trainY, weights[i])

    
    testX, testY = splitData(test_data,False)
    test(testX,testY,roots,alpha)
        
