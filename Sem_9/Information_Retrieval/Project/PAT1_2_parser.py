import os, sys, re
import nltk
from nltk.corpus import stopwords
from nltk.stem import WordNetLemmatizer
from nltk.tokenize import RegexpTokenizer

lemmatizer = WordNetLemmatizer()
tokenizer = RegexpTokenizer(r'\w+')

def parse_query(query):

    # Same as indexer. Remove punctuations, stop words and then
    # lemmatize
    tokens = tokenizer.tokenize(query)
    parsed_tokens = [w for w in tokens if w not in set(stopwords.words('english'))]
    parsed_lemmatized_tokens = [lemmatizer.lemmatize(w) for w in parsed_tokens]

    # Rejoin the tokens back into a string
    return " ".join(parsed_lemmatized_tokens)


if __name__ == '__main__':
    
    # the query file path
    path_to_query = sys.argv[1]
    queries = []


    with open(path_to_query, 'r') as query_file:
        file_data = query_file.readlines()

        # read the query file line by line
        for ind, line in enumerate(file_data):
            # Extract the desired qid and query content
            if line.startswith('<num>'):
                Qid = line[5:-7]
                QStr = file_data[ind + 1][7:-9].lower()
                queries.append([Qid, QStr])

    # Write the queries after parsing them
    dest_file = 'queries_2.txt'
    with open(dest_file, 'w') as quer_file:
        for query in queries:
            query_id, query_str = query[0], parse_query(query[1])
            quer_file.write('{}, {}\n'.format(query_id, query_str))

    # Stats
    print('Written {} queries to file'.format(len(queries)))


