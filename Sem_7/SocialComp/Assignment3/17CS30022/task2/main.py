import os, re
import numpy as np
import spacy
from sklearn import svm
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics import classification_report

DATA = os.path.join("..", "data")
PREDICT = os.path.join("..", "predictions")

np.random.seed(1)
eng = spacy.load('en_core_web_lg')

# remove punctuations, convert to lower case, lemmatize
def preprocess(tweet):
    tweet = re.sub(r'[^\w\s]', '', tweet).lower()
    tweet = " ".join([token.lemma_ for token in eng(tweet)])
    return tweet


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


# Split the data into train and validation for verification
def train_test_split(data, ratio = 0.25):
    n = int((1 - ratio) * len(data))
    return data[:n, 1], data[:n, 2].astype(np.int8), data[n:, 1], data[n:, 2].astype(np.int8)


# Splitting for final output
def split_actual(trainData, testData):
    trainX, trainY = trainData[:,1], trainData[:,2].astype(np.int8)
    testX, testId = testData[:,1], testData[:,0]
    return trainX, trainY, testX, testId


# train the model and return predictions
# use tf-idf vectorisation trained over svm
def train(trainX, trainY, testX):
    
    # Convert into vectors
    allTweets = np.concatenate((trainX, testX))
    vectorizer = TfidfVectorizer(max_df=0.8, min_df=5)
    vectors = vectorizer.fit_transform(allTweets).todense()

    # Separate train and test vectors
    vectorTrain = vectors[:len(trainX)]
    vectorTest = vectors[len(trainX):]
    
    # Train model
    model =  svm.SVC()
    model.fit(vectorTrain, trainY)

    # Return predictions
    predictions = model.predict(vectorTest)
    assert(len(testX) == len(predictions))
    return predictions


if __name__ == '__main__':

    if not os.path.exists(PREDICT):
        os.mkdir(PREDICT)

    trainData, testData = readData() # Get the data

    # Convert Data
    # trainX, trainY, testX, testY = train_test_split(trainData) 
    trainX, trainY, testX, testId = split_actual(trainData, testData)
    
    predictions = train(trainX, trainY, testX)
    
    # Output result
    # print(classification_report(testY, predictions))
    writeOut("T2", testId, predictions)
