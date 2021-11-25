import sys
import pickle

# The Merge Algorithm to find AND of two postings list
def merge(post1, post2):
    ind1, ind2 = 0, 0
    result = []
    while (ind1 < len(post1)) and (ind2 < len(post2)):
        if post1[ind1] == post2[ind2]:
            result.append(post1[ind1])
            ind1 += 1
            ind2 += 1
        elif post1[ind1] < post2[ind2]:
            ind1 += 1
        else:
            ind2 += 1

    return result


if __name__ == '__main__':

    # the index and query file respectively
    index_file = sys.argv[1]
    query_file = sys.argv[2]

    # load the index
    with open(index_file, 'rb') as index:
        inverted_index = pickle.load(index)
        
    query_results = []
    with open(query_file, 'r') as queries:
        # for each query find the document results
        for query in queries.readlines():

            # Split the query into tokens
            Qid, QStr = query[:-1].split(',')
            # Sort the tokens in terms of their increasing postings size
            tokens = sorted(QStr.split(), key = lambda x: len(inverted_index.get(x, [])))

            # Find AND of all postings list corresponding to the tokens sequentially
            # Ignore the frequency of terms
            cur_result = [t[0] for t in inverted_index.get(tokens[0], [])]
            for i in range(1, len(tokens)):
                temp = [t[0] for t in inverted_index.get(tokens[i], [])]
                cur_result = merge(cur_result, temp)
            
            # Store the results
            query_results.append((Qid, cur_result))


    # Save the results for the query in a file
    dest_file = 'PAT1_2_results.txt'
    with open(dest_file, 'w') as results:
        for query in query_results:
            results.write('{}:'.format(query[0]))
            for result in query[1]:
                results.write(' {}'.format(result))
            results.write('\n')