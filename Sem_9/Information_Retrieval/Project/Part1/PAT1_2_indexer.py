import os, sys, re
import pickle
import nltk
from nltk.corpus import stopwords
from nltk.stem import WordNetLemmatizer
from nltk.tokenize import RegexpTokenizer

lemmatizer = WordNetLemmatizer()
tokenizer = RegexpTokenizer(r'\w+')

def parse_doc(document_path):

    with open(document_path) as doc:
        data = doc.read()

    # Get the content to be parsed
    start = data.find('<TEXT>') + len('<TEXT>') + 1
    end = data.find('</TEXT>') - 1
    content = data[start:end].lower()

    # Tokenise by removing punctuations
    tokens = tokenizer.tokenize(content)

    # Remove the stopwords
    parsed_tokens = [w for w in tokens if w not in set(stopwords.words('english'))]

    # Lemmatize the words assuming all of them are nouns
    parsed_lemmatized_tokens = [lemmatizer.lemmatize(w) for w in parsed_tokens]

    # Return the parsed tokens
    return parsed_lemmatized_tokens


if __name__ == '__main__':

    # initialise stuff
    # the index stores key -> postings, where postings also contain the frequency of the term
    # in each document it occurs    
    inverted_index = dict()
    doc_cnt = 0
    total_doc = 89286
    
    # path to the data folder
    path_to_data = sys.argv[1]

    # iterate through all the top level directories
    for top_level_folder in os.listdir(path_to_data):
        # iterate through all documents in each directory
        for document in os.listdir(os.path.join(path_to_data, top_level_folder)):
            
            # for each document, the name is the id, and is parsed in the parse_doc function
            # to get the tokens to be indexed
            doc_id = document
            tokens = parse_doc(os.path.join(path_to_data, top_level_folder, document))

            # for each token
            for token in tokens:
            
                # if there is no entry in the index create one
                if token not in inverted_index:
                    inverted_index[token] = []

                # if this is the first entry for the document, create (id, 1) tuple
                # else increase the count of the frequency
                if not inverted_index[token] or inverted_index[token][-1][0] != doc_id:
                    inverted_index[token].append([doc_id, 1])
                else:
                    inverted_index[token][-1][1] += 1
            
            # Record Stats
            doc_cnt += 1
            print("Parsed {} / {} Docs".format(doc_cnt, total_doc))

    # Sort each postings list
    for token in inverted_index:
        inverted_index[token].sort() 

    print("The size of the vocabulary is {}".format(len(inverted_index)))

    # Save it as a pickle file
    dest_file = 'model_queries_2.pth'
    with open(dest_file, 'wb') as pkl_file:
        pickle.dump(inverted_index, pkl_file)
    
