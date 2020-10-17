import os
import snap as sn

TOP = 100
PATH = "centralities"

# Read the top 100 values from the file
def readValues(location):
    values = list()
    with open(os.path.join(PATH, location)) as data:
        for _ in range(TOP):
            node, value = data.readline()[:-1].split(" ")
            values.append([float(value), int(node)])

    return values


# Find the number of values that overlap from the two lists
def getMatch(data1, data2):
    data1 = [item[1] for item in data1]
    data2 = [item[1] for item in data2]
    return len([node for node in data1 if node in data2])


if __name__ == "__main__":
    
    # Create the graph from the edge list
    G = sn.TUNGraph.New()
    with open("FB.txt", "r") as FB:
        for edge in FB.readlines():
            u, v = map(int, edge[:-1].split(" "))
            G.AddEdge2(u, v)
    
    # Closeness Centrality
    cl = [[sn.GetClosenessCentr(G, u.GetId()), u.GetId()] for u in G.Nodes()] # Calculate using SNAP
    clPr = readValues("closeness.txt") # Read top 100 previously calculated values
    ## Extract top 100, and find the overlaps
    print("#overlaps for Closeness Centrality: {}".format(getMatch(sorted(cl, reverse=True)[:TOP], clPr)))

    # Betweenness Centrality
    NodeCentr = sn.TIntFltH()
    EdgeCentr = sn.TIntPrFltH()
    sn.GetBetweennessCentr(G, NodeCentr, EdgeCentr, 0.8)
    bw = [[NodeCentr[u], u] for u in NodeCentr] # Calculate using SNAP
    bwPr = readValues("betweenness.txt") # Read top 100 previously calculated values
    ## Extract top 100, and find the overlaps
    print("#overlaps for Betweenness Centrality: {}".format(getMatch(sorted(bw, reverse=True)[:TOP], bwPr)))

    # PageRank Centrality
    PR = sn.TIntFltH()
    sn.GetPageRank(G, PR, 0.8, 1e-5, 500)
    pr = [[PR[u], u] for u in PR] # Calculate using SNAP
    prPr = readValues("pagerank.txt") # Read top 100 previously calculated values
    ## Extract top 100, and find the overlaps
    print("#overlaps for PageRank Centrality: {}".format(getMatch(sorted(pr, reverse=True)[:TOP], prPr)))

