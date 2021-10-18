import sys
import pickle
import numpy as np
from collections import Counter

def document_frequency(inverted_index):
    # Calculate the Document Frequency as well as order the vocabulary
    # Here order means, the dimension number for the vector
    # DF: key -> (num, df(key))
    DF = dict()
    for ind, term in enumerate(inverted_index):
        DF[term] = (ind, len(inverted_index[term]))
    return DF


def term_frequency_document(inverted_index):
    # Calculate for each document, the terms present and their frequency.
    # Since processing data will take too much time, we will use 
    # the inverted index for this purpose
    TF_d = dict()
    for term in inverted_index:
        for doc in inverted_index[term]:
            if doc[0] not in TF:
                TF[doc[0]] = []
            TF[doc[0]].append((term, doc[1]))
    return TF_d


def term_frequency_query(path_to_queries, DF):
    # Calculate for each query, the vocabulary terms and
    # their frequency
    TF_q = dict()
    with open(path_to_queries, 'r') as queries:    
        # process each query
        for query in queries.readlines():
            # Split the query into tokens and sort them
            Qid, QStr = query[:-1].split(',')
            tokens = QStr.split().sort()

            # Initialise entry
            TF_q[Qid] = []

            # Calculate frequency of the tokens and add it to the list
            # only if it is in the vocabulary
            for token, frequency in Counter(tokens).items():
                if token in DF:
                    TF_q[Qid].append((token, frequency))

            # Sort the terms according to the dimension
            TF_q[Qid].sort(key = lambda x: DF[x][0])


def cosine_similarity(vec1, vec2):
    # Calculate unit vector and then find dot product
    unit_vec1 = vec1 / np.linalg.norm(vec1)
    unit_vec2 = vec2 / np.linalg.norm(vec2)
    return np.dot(unit_vec1, unit_vec2)    


if __name__ == '__main__':

    # Load the inverted index
    path_to_index = sys.argv[2]
    with open(path_to_index, 'rb') as index:
        inverted_index = pickle.load(index)

    # Calculate essentials
    DF = document_frequency(inverted_index) # Document frequency
    TF_d = term_frequency_document(inverted_index) # Term frequency document
    
    path_to_queries = sys.argv[3]
    TF_q = term_frequency_query(path_to_queries, DF) # Term frequency query

    # We basically have the compressed vectors, and we expand them whenever we need them.
    # Otherwise storing all of them in memory is very memory inefficient, whereas the time
    # tradeoff is not much in our apporach

    # for each query, calculate cosine similarity for each doc
    # for each of the formats

    results = dict()
    for qId in TF_q:
        lnc_ltc_scores = []
        Lnc_Lpc_scores = []
        anc_apc_scores = []

        # Calculate scores for each doc
        for docId in TF_d:
            # for lnc_ltc scheme
            query_vec, doc_vec = calculate_vectors_lnc_ltc(TF_q[qId], TF_d[docId], DF)
            lnc_ltc_scores.append(docId, cosine_similarity(query_vec, doc_vec))

            # for Lnc_Lpc scheme
            query_vec, doc_vec = calculate_vectors_Lnc_Lpc(TF_q[qId], TF_d[docId], DF)
            Lnc_Lpc_scores.append(docId, cosine_similarity(query_vec, doc_vec))

            # for anc_apc scheme
            query_vec, doc_vec = calculate_vectors_anc_apc(TF_q[qId], TF_d[docId], DF)
            anc_apc_scores.append(docId, cosine_similarity(query_vec, doc_vec))

        # Sort the docs according to score and add the top 50 to results
        lnc_ltc_scores.sort(key = lambda x: x[1], reverse=True)
        results[qId] = [lnc_ltc_scores[:50]]

        Lnc_Lpc_scores.sort(key = lambda x: x[1], reverse=True)
        results[qId].append(Lnc_Lpc_scores[:50])

        anc_apc_scores.sort(key = lambda x: x[1], reverse=True)
        results[qId].append(anc_apc_scores[:50])

    
    

    
    

    

    