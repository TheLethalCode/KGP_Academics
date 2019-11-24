# Roll : 17CS30022
# Name : Kousshik Raj
# Assignment No : 1

# coding: utf-8

import numpy as np
import csv

# The training data file
DATASET = "data1_19.csv"

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


def test_train(data):

    features = data[0]

    X = data[1: , 0:3]
    Y = data[1: , 3]

    temp = [i for i in range(data.shape[0]) if not i%5]
    
    checkX = data[temp, 0:3]
    checkY = data[temp, 3]
    
    trainX = np.delete(X, temp, axis = 0)
    trainY = np.delete(Y, temp, axis = 0)

    return trainX, trainY, checkX, checkY, features

# A function to find the entropy
def findEntropy(countYes, countNo):

    ratio_yes, ratio_no = countYes/(countYes + countNo), countNo/(countYes + countNo)

    if not (ratio_yes and ratio_no):
        return 0
    
    return -ratio_yes * np.log(ratio_yes) - ratio_no * np.log(ratio_no)

# finding the best attribute using information gain
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

# training the model using the given dataset
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


# displayin the final decision tree
def showTree(root, level):

    if not root.attribute:
       print(root.label)
    
    for ind, child in enumerate(root.child):

        if child.attribute:
            print("\t"*level + root.attribute + " = " + root.subAttributes[ind] + "\n" , end = '')
        
        else:
            print("\t"*level + root.attribute + " = " + root.subAttributes[ind] + ":- " , end = ' ')
        
        showTree(child,level+1)


if __name__ == "__main__":

    # Reading the data from the csv file
    training_data = csv_data(DATASET)

    trainX, trainY, testX, testY, attributes = test_train(training_data)
    
    # Training using the given data
    root = train(trainX, trainY, attributes[:3])

    # Displaying the tree
    showTree(root, 0)

