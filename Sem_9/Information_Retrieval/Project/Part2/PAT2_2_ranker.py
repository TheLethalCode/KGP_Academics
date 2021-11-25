import sys
import pickle
import numpy as np
import math
from collections import Counter

def document_frequency(inverted_index):
    # Calculate the Document Frequency as well as order the vocabulary
    # Here order means, the dimension number for the vector
    # DF: key -> (num, df(key))
    DF = dict()
    for ind, term in enumerate(inverted_index):
        DF[term] = (ind, len(inverted_index[term]))

    print("Calculated Document Frequencies")
    return DF


def term_frequency_document(inverted_index):
    # Calculate for each document, the terms present and their frequency.
    # Since processing data will take too much time, we will use 
    # the inverted index for this purpose
    TF_d = dict()
    for term in inverted_index:
        for doc in inverted_index[term]:
            if doc[0] not in TF_d:
                TF_d[doc[0]] = []
            TF_d[doc[0]].append((term, doc[1]))

    print("Calculated Term Frequencies for Documents")
    return TF_d


def term_frequency_query(path_to_queries, DF):
    # Calculate for each query, the vocabulary terms and
    # their frequency
    TF_q = dict()
    with open(path_to_queries, 'r') as queries:    
        # process each query
        for query in queries.readlines():
            # Split the query into tokens
            Qid, QStr = query[:-1].split(',')
            tokens = QStr.split()

            # Initialise entry
            TF_q[Qid] = []

            # Calculate frequency of the tokens and add it to the list
            # only if it is in the vocabulary
            for token, frequency in Counter(tokens).items():
                if token in DF:
                    TF_q[Qid].append((token, frequency))

    print("Calculated Term Frequencies for Queries")
    return TF_q

# lnc scheme for docs
def calculate_vec_ln(tf, df, N):
    V = len(df)                             # Vocabulary size
    vec = [0 for i in range(V)]
    for term in tf:
        ind = df[term[0]][0]                                    # Calculate dimension in the vector 
        term_frequency = 1 + math.log10(term[1])                # Using l scheme
        document_frequency = 1                                  # Using n scheme
        vec[ind] = term_frequency * document_frequency
    return np.array(vec)

# Lnc scheme for docs
def calculate_vec_Ln(tf, df, N):
    V = len(df)                             # Vocabulary size
    vec = [0 for i in range(V)]

    # Find the average tf
    ave_tf = 0
    for term in tf:
        ave_tf += term[1]
    ave_tf /= len(tf)

    for term in tf:
        ind = df[term[0]][0]                                                        # Calculate dimension in the vector 
        term_frequency = (1 + math.log10(term[1])) / (1 + math.log10(ave_tf))       # Using L scheme
        document_frequency = 1                                                      # Using n scheme
        vec[ind] = term_frequency * document_frequency
    return np.array(vec)

# anc scheme for doc
def calculate_vec_an(tf, df, N):
    V = len(df)                             # Vocabulary size
    vec = [0 for i in range(V)]

    # Find the max tf
    max_tf = 0
    for term in tf:
        max_tf = max(max_tf, term[1])

    for term in tf:
        ind = df[term[0]][0]                                  # Calculate dimension in the vector 
        term_frequency = 0.5 + (0.5 * term[1]) / max_tf       # Using a scheme
        document_frequency = 1                                # Using n scheme
        vec[ind] = term_frequency * document_frequency
    return np.array(vec)


# ltc scheme for query
def calculate_vec_lt(tf, df, N):
    V = len(df)                             # Vocabulary size
    vec = [0 for i in range(V)]
    for term in tf:
        ind = df[term[0]][0]                                    # Calculate dimension in the vector 
        term_frequency = 1 + math.log10(term[1])                # Using l scheme
        document_frequency = math.log10(N / df[term[0]][1])     # Using t scheme
        vec[ind] = term_frequency * document_frequency
    return np.array(vec)

# Lpc scheme for query
def calculate_vec_Lp(tf, df, N):
    V = len(df)                             # Vocabulary size
    vec = [0 for i in range(V)]

    # Find the average tf
    ave_tf = 0
    for term in tf:
        ave_tf += term[1]
    ave_tf /= len(tf)

    for term in tf:
        ind = df[term[0]][0]                                                        # Calculate dimension in the vector 
        term_frequency = (1 + math.log10(term[1])) / (1 + math.log10(ave_tf))       # Using L scheme
        
        if df[term[0]][1] < N / 2:                                                  # Using p scheme
            document_frequency = math.log10(N / df[term[0]][1] - 1)
        else:
            document_frequency = 0    
        
        vec[ind] = term_frequency * document_frequency
    return np.array(vec)

# apc scheme for query
def calculate_vec_ap(tf, df, N):
    V = len(df)                             # Vocabulary size
    vec = [0 for i in range(V)]

    # Find the max tf
    max_tf = 0
    for term in tf:
        max_tf = max(max_tf, term[1])

    for term in tf:
        ind = df[term[0]][0]                                  # Calculate dimension in the vector 
        term_frequency = 0.5 + (0.5 * term[1]) / max_tf       # Using a scheme
        
        if df[term[0]][1] < N / 2:                              # Using p scheme
            document_frequency = math.log10(N / df[term[0]][1] - 1)
        else:
            document_frequency = 0    

        vec[ind] = term_frequency * document_frequency
    return np.array(vec)


def write_results(file_path, results, ind):
    # Write the <ind>th result in the corresponding file_path
    # Here ind referes to the different schemes
    
    with open(file_path, 'w') as scheme:
        for qid in sorted(results.keys()):        
            # Sort the results according to decreasing cosine similarity
            results[qid][ind].sort(reverse=True, key = lambda x: x[1])
            
            # Write the top 50 results to file
            scheme.write('{}:'.format(qid))
            for docs in results[qid][ind][:50]:
                scheme.write(' {}'.format(docs[0]))
            scheme.write('\n')       


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

    # We basically only precalculate the query vectors, and have the compressed
    # vectors for documents and expand them on a need basis. Otherwise, it will be
    # very memory inefficient, whereas the time tradeoff is not much in our apporach
    query_vectors = dict()
    results = dict()    #  initialise results as well
    for cnt, qId in enumerate(TF_q):
        query_vectors[qId] = []
        
        query_vec = calculate_vec_lt(TF_q[qId], DF, len(TF_d))
        query_vectors[qId].append(query_vec / np.linalg.norm(query_vec))

        query_vec = calculate_vec_Lp(TF_q[qId], DF, len(TF_d))
        query_vectors[qId].append(query_vec / np.linalg.norm(query_vec))

        query_vec = calculate_vec_ap(TF_q[qId], DF, len(TF_d))
        query_vectors[qId].append(query_vec / np.linalg.norm(query_vec))

        results[qId] = [[], [], []]
    print("Calculated the query vectors")
    
    # For each doc 
    for cnt1, docId in enumerate(TF_d):
    
        # Calculate (Expand) the doc vectors from the compressed ones
        # Also calculate their unit ones
        doc_vec_1 = calculate_vec_ln(TF_d[docId], DF, len(TF_d))
        doc_vec_1 = doc_vec_1 / np.linalg.norm(doc_vec_1)        

        doc_vec_2 = calculate_vec_Ln(TF_d[docId], DF, len(TF_d))
        doc_vec_2 = doc_vec_2 / np.linalg.norm(doc_vec_2)        

        doc_vec_3 = calculate_vec_an(TF_d[docId], DF, len(TF_d))
        doc_vec_3 = doc_vec_3 / np.linalg.norm(doc_vec_3)        

        # For each query, use the previously calculated query vectors
        # to caculate cosine similarity for each scheme and store them
        for cnt, qId in enumerate(TF_q):

            results[qId][0].append((docId, np.dot(doc_vec_1, query_vectors[qId][0])))
            results[qId][1].append((docId, np.dot(doc_vec_2, query_vectors[qId][1])))
            results[qId][2].append((docId, np.dot(doc_vec_3, query_vectors[qId][2])))

        print("Processed {} / {} docs\t\t\t\t\r".format(cnt1 + 1, len(TF_d)), end = '')
    
    print("Calculated all the cosine similarity scores")

    # Write the results to the files
    lnc_ltc_file = 'PAT2_2_ranked_list_A.csv'
    Lnc_Lpc_file = 'PAT2_2_ranked_list_B.csv'
    anc_apc_file = 'PAT2_2_ranked_list_C.csv'

    write_results(lnc_ltc_file, results, 0)
    write_results(Lnc_Lpc_file, results, 1)
    write_results(anc_apc_file, results, 2)

    print("Written the values to the file")
    
     
    

    
    

    

    