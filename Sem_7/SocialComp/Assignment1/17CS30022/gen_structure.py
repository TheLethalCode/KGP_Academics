import os
import snap as sn
import numpy as np
from sys import argv

# Random Generator with seed 42
Rnd = sn.TRnd(42)
Rnd.Randomize()

# Directories
PLOT = os.path.join(os.getcwd(), "plots")
SUBGRAPHS = os.path.join(os.getcwd(), "subgraphs")

# Function to remove unnecessary files
def plotRemove(fro, to, name):
    os.rename("{}.{}.png".format(fro, name), os.path.join(PLOT, "{}_{}.png".format(to, name)))
    os.remove("{}.{}.tab".format(fro, name))
    os.remove("{}.{}.plt".format(fro, name))


if __name__ == "__main__":

    # Create the plots directory
    if not os.path.exists(PLOT):
        os.mkdir(PLOT)

    # Check for proper arguments
    if len(argv) != 2:
        print("Too much or lack of arguments")
        exit(1)
    name = argv[1]
    subG = os.path.join(SUBGRAPHS, name)

    # Create the graph
    graph = sn.TUNGraph.New()
    with open(subG, "r") as subgraph:
        for edge in subgraph.readlines():
            try:
                u, v = map(int, edge[:-1].split(" "))
            except:
                print("Error in subgraph")
                exit(1)
            graph.AddEdge2(u, v)
    
    # Question 1
    
    ## Nodes
    print("Number of nodes: {}".format(graph.GetNodes()))
    
    ## Edges
    print("Number of edges: {}".format(graph.GetEdges()))

    # Question 2

    ## Degree 7
    print("Number of nodes with degree={}: {}".format(7, sn.CntDegNodes(graph, 7)))

    ## The Maximum Degree
    MxDeg = graph.GetNI(sn.GetMxDegNId(graph)).GetDeg()
    print("Node id(s) with highest degree: ", end="")
    flag = True
    for node in graph.Nodes():
        if node.GetDeg() == MxDeg:
            if flag:
                print(node.GetId(), end="")
                flag = False
            else:
                print(", {}".format(node.GetId), end="")
    print()

    ## Plot of degrees
    sn.PlotOutDegDistr(graph, name, "Degree Distribution")
    plotRemove("outDeg", "deg_dist", name)

    # Question 3
    numNodes = [10, 100, 1000]

    ## Full diameter
    fullDia = [sn.GetBfsFullDiam(graph, tNodes) for tNodes in numNodes]
    for i in range(3):
        print("Approximate full diameter by sampling {} nodes: {}".format(numNodes[i], fullDia[i]))
    print("Approximate full diameter (mean and variance): {:.4f} {:.4f}".format(np.mean(fullDia), np.var(fullDia)))

    ## Effective Diameter
    effDia = [sn.GetBfsEffDiam(graph, tNodes) for tNodes in numNodes]
    for i in range(3):
        print("Approximate effective diameter by sampling {} nodes: {:.4f}".format(numNodes[i], effDia[i]))
    print("Approximate effective diameter (mean and variance): {:.4f} {:.4f}".format(np.mean(effDia), np.var(effDia)))

    ## Plot Shortest Path Distr
    sn.PlotShortPathDistr(graph, name, "Shortest Path Distribution")
    plotRemove("diam", "shortest_path", name)

    #Question 4

    ## Max Comp Fraction
    MxConCompSize = sn.GetMxScc(graph).GetNodes()
    print("Fraction of nodes in largest connected component: {:0.4f}".format(MxConCompSize / graph.GetNodes()))

    ## Edge Bridges
    edgeBridge = sn.TIntPrV()
    sn.GetEdgeBridges(graph, edgeBridge)
    print("Number of edge bridges: {}".format(len(edgeBridge)))

    ## Articulation Points
    artPoints = sn.TIntV()
    sn.GetArtPoints(graph, artPoints)
    print("Number of articulation points: {}".format(len(artPoints)))

    ## Connected Components Distribution
    sn.PlotSccDistr(graph, name, "Connected Component Distribution")
    plotRemove("scc", "connected_comp", name)

    #Question 5

    ## Clustering Coefficient
    print("Average clustering coefficient: {:0.4f}".format(sn.GetClustCf(graph)))

    ## Triads
    print("Number of triads: {}".format(sn.GetTriads(graph)))

    ## Random Clustering Coefficient
    rndNode = graph.GetRndNId()
    print("Clustering coefficient of random node {}: {:0.4f}".format(rndNode, sn.GetNodeClustCf(graph, rndNode)))

    ## Random node triads
    rndNode = graph.GetRndNId()
    print("Number of triads random node {} participates: {}".format(rndNode, sn.GetNodeTriads(graph, rndNode)))

    ## Edges in Triads
    print("Number of edges that participate in at least one triad: {}".format(sn.GetTriadEdges(graph)))

    ## Plot Clustering Coefficient
    sn.PlotClustCf(graph, name, "Clustering Coefficient Distribution")
    plotRemove("ccf", "clustering_coeff", name)