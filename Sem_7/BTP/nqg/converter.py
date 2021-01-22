import os, json

TYPE = "dev"
LANG = "telugu"
PATH = os.path.join("..", "TyDiQA", "{}_{}".format(LANG, TYPE), "{}_{}_data.json".format(TYPE, LANG))
DEST = os.path.join("data", LANG, TYPE)


if __name__ == '__main__':
    
    if not os.path.exists(DEST):
        os.makedirs(DEST)

    with open(PATH) as reader:
        contents = [json.loads(line) for line in reader.readlines()]

    datas = [(con['context'], qa['question']) for con in contents for qa in con['qas']]
    
    with open(os.path.join(DEST, "{}.source.txt".format(TYPE)), "w") as temp:
        for data in datas:
            temp.write("{}\n".format(data[0]))

    with open(os.path.join(DEST, "{}.target.txt".format(TYPE)), "w") as temp:
        for data in datas:
            temp.write("{}\n".format(data[1]))

    with open(os.path.join(DEST, "{}.case.txt".format(TYPE)), "w") as temp:
        for data in datas:
            for word in data[0].split():
                temp.write("UP ")
            temp.write("\n")

    with open(os.path.join(DEST, "{}.pos.txt".format(TYPE)), "w") as temp:
        for data in datas:
            for word in data[0].split():
                temp.write("NNP ")
            temp.write("\n")

    with open(os.path.join(DEST, "{}.bio.txt".format(TYPE)), "w") as temp:
        for data in datas:
            for word in data[0].split():
                temp.write("I ")
            temp.write("\n")

    with open(os.path.join(DEST, "{}.ner.txt".format(TYPE)), "w") as temp:
        for data in datas:
            for word in data[0].split():
                temp.write("0 ")
            temp.write("\n")