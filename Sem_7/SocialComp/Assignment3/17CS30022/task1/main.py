import os
import re
import numpy as np
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.ensemble import RandomForestClassifier
from sklearn import svm
import spacy
import fasttext

DATA = os.path.join("..", "data")
PREDICT = os.path.join("..", "predictions")

np.random.seed(1)

# remove punctuations and convert to lower case
def preprocess(tweet):
    return re.sub(r'[^\w\s]', '', tweet).lower()


# Read the data from the files
def readData():
    
    with open(os.path.join(DATA, "train.tsv")) as reader:
        temp = reader.readlines()
        trainData = [sample[:-1].split('\t') for sample in temp[1:]]

    with open(os.path.join(DATA, "test.tsv")) as reader:
        temp = reader.readlines()
        testData = [sample[:-1].split('\t') for sample in temp[1:]]

    trainData = [[data[0], preprocess(data[1]), data[2]] for data in trainData]
    testData = [[data[0], preprocess(data[1])] for data in testData]
    return np.array(trainData), np.array(testData)


# Write the predictions to the file
def writeOut(name, ids, values):

    with open(os.path.join(PREDICT, "{}.csv".format(name)), "w") as trump:
        trump.write("id,hateful\n")
        for id, value in zip(ids, values):
            trump.write("{},{}\n".format(id, value))


# Use Tf-Idf vectorisation with random forest classifier
def RandomForest(trainData, testData):

    # Process the data
    trainX, trainY = trainData[:,1], trainData[:,2].astype(np.int8)
    testX, testId = testData[:,1], testData[:,0]

    print("Running RandomForest...")
    # Convert into vectors
    allTweets = np.concatenate((trainX, testX))
    vectorizer = TfidfVectorizer(max_df=0.8, min_df=5)
    vectors = vectorizer.fit_transform(allTweets).todense()

    # Separate train and test vectors
    vectorTrain = vectors[:len(trainX)]
    vectorTest = vectors[len(trainX):]

    # Train the model
    model = RandomForestClassifier()
    model.fit(vectorTrain, trainY)

    # Test the model
    prediction = model.predict(vectorTest)

    assert(len(testId) == len(prediction))
    writeOut("RF", testId, prediction)


# Use word2vec embeddings with SVM classifier
def SVM(trainData, testData):
    
    # Process the data
    trainX, trainY = trainData[:,1], trainData[:,2].astype(np.int8)
    testX, testId = testData[:,1], testData[:,0]

    print("Running SVM...")
    # Generate the embeddings
    word2vec = spacy.load('en_core_web_md')
    vectorTrain = np.array([word2vec(str(tweet)).vector for tweet in trainX])
    vectorTest = np.array([word2vec(str(tweet)).vector for tweet in testX])

    # Train the model
    model = svm.SVC()
    model.fit(vectorTrain, trainY)

    # Test the model
    prediction = model.predict(vectorTest)

    assert(len(testId) == len(prediction))
    writeOut("SVM", testId, prediction)


# Using fasttext library for text classification
def fastText(trainData, testData):
    
    # Process the data
    trainX, trainY = trainData[:,1], trainData[:,2].astype(np.int8)
    testX, testId = testData[:,1], testData[:,0]

    print("Running FastText...")
    # Create temporary file
    with open("temp.train.txt", "w") as ftr:
        for tweet, label in zip(trainX, trainY):
            ftr.write("__label__{} {}\n".format(label, tweet))
    
    # Train supervised model
    model = fasttext.train_supervised('temp.train.txt')
    os.remove("temp.train.txt")

    # Test the model
    prediction = [model.predict(tweet)[0][0][len("__label__"):] for tweet in testX]
    
    assert(len(testId) == len(prediction))
    writeOut("FT", testId, prediction)


if __name__ == '__main__':

    if not os.path.exists(PREDICT):
        os.mkdir(PREDICT)

    trainData, testData = readData() # Get the data
    RandomForest(trainData, testData) # train the random forest classifier
    SVM(trainData, testData) # train the svm classifier
    fastText(trainData, testData) # use fasttext for text classification