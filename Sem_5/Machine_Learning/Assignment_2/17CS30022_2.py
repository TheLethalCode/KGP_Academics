# Roll : 17CS30022
# Name : Kousshik Raj
# Assignment No : 2

# coding: utf-8

import numpy as np
import csv

# Name of the training and testing file
TRAIN = 'data2_19.csv'
TEST = 'test2_19.csv'

# A function to read the data given in the csv file
def csv_data(file_name):

    with open(file_name,'r') as fil:
        data = [row[0].split(',') for row in csv.reader(fil)]
        return np.array(data)    


# Functions for splitting the data
def splitData(data, train):

    # Splitting the training data
    if train:
        features = data[0,1:]
        trainX = data[1:, 1:]
        trainY = data[1:, 0]
        return features, trainX, trainY
    
    # Splitting the testing data
    else:
        testX = data[1:, 1:]
        testY = data[1:, 0]
        return testX, testY


# Training the data
def train(attributes, trainX, trainY):
    
    probUnhappy = (trainY == '0').sum()/trainY.size
    probhappy = (trainY == '1').sum()/trainY.size

    measures = ['1','2','3','4','5']
    happyIndex = np.where(trainY == '1')[0]
    unhappyIndex = np.where(trainY == '0')[0]
    
    # Calculating and printing probHappyX
    probHappyX = [ ((trainX[happyIndex, i] == measure).sum()+1)/(happyIndex.size+2) \
                            for i in range(trainX[0].shape[0]) for measure in measures ]
    probHappyX = np.array(probHappyX).reshape(6,5)
    print("probHappyX = {}\n".format(probHappyX))
    
    # Calculating and printing probUnhappyX
    probUnhappyX = [ ((trainX[unhappyIndex, i] == measure).sum()+1)/(unhappyIndex.size+2) \
                            for i in range(trainX[0].shape[0]) for measure in measures ]
    probUnhappyX = np.array(probUnhappyX).reshape(6,5)
    print("probUnhappyX = {}\n".format(probUnhappyX))

    return [probhappy, probUnhappy, probHappyX, probUnhappyX]


# Testing
def test(testX, testY, probabilities):
    
    predictY = []
    for i in range(testX.shape[0]):

        happy, unhappy = 1, 1
        for temp, j in enumerate(testX[i]):
            happy *= probabilities[2][temp][int(j)-1]
            unhappy *= probabilities[3][temp][int(j)-1]
        
        if(happy*probabilities[0] > unhappy*probabilities[1]):
            predictY.append('1')
        else:
            predictY.append('0')
    
    print("Predicted = {}".format(predictY))
    print("Actual = {}".format(testY))
    print("Percentage accuracy = {}".format(((predictY == testY).sum()/testY.size) * 100 ))


if __name__ == '__main__':

    # Reading and splitting training data
    trainingData = csv_data(TRAIN)
    attributes, trainX, trainY = splitData(trainingData, True)

    # Calculating the various probabilities
    probabilities = train(attributes, trainX, trainY)


    # Reading and splitting test data
    testingData = csv_data(TEST)
    testX, testY = splitData(testingData,False)

    # Predicting the test
    test(testX, testY, probabilities)











