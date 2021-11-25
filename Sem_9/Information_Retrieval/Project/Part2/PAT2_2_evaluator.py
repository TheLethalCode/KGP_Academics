import csv, sys
import math
import numpy as np

if __name__ == '__main__':

    # Open the gold standards and store it in a dictionary
    # qId -> doc -> relevance_score
    path_to_gold_standard = sys.argv[1]
    relevance = dict()
    with open(path_to_gold_standard) as csvFile:
        csv_reader = csv.reader(csvFile, delimiter=',')
        for ind, line in enumerate(csv_reader):
            if ind:
                qId = line[0]
                if qId not in relevance:
                    relevance[qId] = dict()
                relevance[qId][line[1]] = int(line[2])

    # Open the results stored and store them in dictionary as well
    results = dict()
    path_to_results = sys.argv[2]
    with open(path_to_results) as res:
        for result in res.readlines():
            qId, docs = result[:-1].split(':')
            docs = docs.split()
            results[qId] = docs[:20]

    # Calculate precision metrics
    metrics = dict()
    for qId in results:
        relevant_cnt, precisions, metrics[qId] = 0, [], []

        # Calculate precision at each position from 1 to 20
        for pos, doc in enumerate(results[qId]):
            if doc in relevance.get(qId, dict()):       # Check the number of relevant documents till now
                relevant_cnt += 1
            precisions.append(relevant_cnt / (pos + 1))
        
        metrics[qId].append(np.mean(precisions[:10]))    # AP@10
        metrics[qId].append(np.mean(precisions))         # AP@20
        

    # Calculate cumulative gain metrics
    for qId in results:
        # Calculate the ideal rankings with the highest relevance first
        temp = relevance.get(qId, dict())
        ideal_results = sorted(results[qId], reverse = True, key = lambda x: temp.get(x, 0))
        score, ideal_score = 0, 0
        dcgs, ideal_dcgs = [], []

        # Calculate dcg and ideal_dcg at each position
        for ind in range(len(results[qId])):
            # Calculate the value
            if ind >= 1:
                score += temp.get(results[qId][ind], 0) / math.log2(ind + 1)
                ideal_score += temp.get(ideal_results[ind], 0) / math.log2(ind + 1)
            else:
                score += temp.get(results[qId][ind], 0)
                ideal_score += temp.get(ideal_results[ind], 0)

            # Append it to the list
            dcgs.append(score)
            ideal_dcgs.append(ideal_score)

        # Store it in the final results
        if ideal_dcgs[9] == 0:
            metrics[qId].append(0)
        else:
            metrics[qId].append(dcgs[9] / ideal_dcgs[9])         # NDCG@10

        if ideal_dcgs[19] == 0:
            metrics[qId].append(0)
        else:
            metrics[qId].append(dcgs[19] / ideal_dcgs[19])         # NDCG@20


    # Write the results to the file
    dest_file = 'PAT2_2_metrics_{}.csv'.format(path_to_results[-5])
    with open(dest_file, 'w') as metric_file:
        metric_file.write('Query Id, AP@10, AP@20, NDCG@10, NDCG@20')   # Column headers

        sum_mets = [0, 0, 0, 0] # Sum all of them to average

        # For each query
        for qId in metrics: 
            metric_file.write('{}'.format(qId))

            # Iterate through each of the metric
            for ind, met in enumerate(metrics[qId]):
                metric_file.write(', {}'.format(met))         # Write the results to the file
                sum_mets[ind] += met                        # Sum the individual metrics

            metric_file.write('\n')

        # Calculate average and write it in the final row
        size = len(metrics)
        for ave_met in sum_mets:
            metric_file.write(', {}'.format(ave_met / size))
        metric_file.write('\n')


        