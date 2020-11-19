import os, json

TYPE = "train"
PATH = "{}_bengali_data.json".format(TYPE)


if __name__ == '__main__':
    
    with open(PATH) as reader:
        contents = [json.loads(line) for line in reader.readlines()]

    datas = [(con['context'], qa['question']) for con in contents for qa in con['qas']]
    
    with open("{}.source.txt".format(TYPE), "w") as temp:
        for data in datas:
            temp.write("{}\n".format(data[0]))

    with open("{}.target.txt".format(TYPE), "w") as temp:
        for data in datas:
            temp.write("{}\n".format(data[1]))

    with open("{}.case.txt".format(TYPE), "w") as temp:
        for data in datas:
            for word in data[0].split():
                temp.write("UP ")
            temp.write("\n")

    with open("{}.pos.txt".format(TYPE), "w") as temp:
        for data in datas:
            for word in data[0].split():
                temp.write("NNP ")
            temp.write("\n")

    with open("{}.bio.txt".format(TYPE), "w") as temp:
        for data in datas:
            for word in data[0].split():
                temp.write("I ")
            temp.write("\n")

    with open("{}.ner.txt".format(TYPE), "w") as temp:
        for data in datas:
            for word in data[0].split():
                temp.write("0 ")
            temp.write("\n")