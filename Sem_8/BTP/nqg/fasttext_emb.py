import torch

SRC = "vocab.txt.20k"
EMB = "telugu_vec_300.txt"
DEST = "pretrain.txt"
DIM = 300

if __name__ == '__main__':

    embs = {}
    with open(SRC) as temp:
        vocab = [line[:-1].lower().split()[0] for line in temp.readlines()]
    
    with open(EMB) as temp:
        for line in temp.readlines():
            wordEmb = line[:-1].split()
            if len(wordEmb) == 2:
                continue
            try:
                if wordEmb[0].lower() in vocab:
                    embs[wordEmb[0].lower()] = wordEmb[1:]
            except:
                pass

    print(len(embs))
    
    with open(DEST, "w") as temp:
        for word in vocab:
            if word not in embs:
                for _ in range(DIM):
                    temp.write("0.0 ")  
            else:
                for dim in embs[word]:
                    temp.write("{} ".format(dim))
            temp.write('\n')

    # mat = []

    # with open(DEST, "w") as temp:
    #     for word in vocab:
    #         if word not in embs:
    #             mat.append([0.0 for _ in range(DIM)])
    #         else:
    #             mat.append([float(dim) for dim in embs[word]])

    # embs = torch.Tensor(mat)
    # print(embs.shape)
    # torch.save(embs, "pretrained.pt")
