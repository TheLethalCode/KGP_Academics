
if __name__ == '__main__':

    with open("amazon_o.txt", "r") as amazon:
        with open("amazon.elist", "w") as subg:
            for edge in amazon.readlines():
                u, v = map(int, edge[:-1].split("\t"))
                if u % 4 == 0 and v % 4 == 0:
                    subg.write("{} {}\n".format(u, v))
    
    with open("facebook_o.txt", "r") as facebook:
        with open("facebook.elist", "w") as subg:
            for edge in facebook.readlines():
                u, v = map(int, edge[:-1].split(" "))
                if u % 5 != 0 and v % 5 != 0:
                    subg.write("{} {}\n".format(u, v))
    