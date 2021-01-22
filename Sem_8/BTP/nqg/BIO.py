import argparse
import os
import sys
import json
import unicodedata
    

def load_dataset(path):
    """Load json file and store fields separately."""
    with open(path, encoding='utf-8') as f:
        data = json.load(f)['data']

    count=0
    ret_list = list()

    for article in data:
        for paragraph in article['paragraphs']:
            for qa in paragraph['qas']:
                if(qa['id'].startswith("telugu")):
                    
                    count+=1
                    ans = qa['answers'][0]
                    answer_start = int(ans['answer_start'])
                    answer = ans['text']
                    context = unicodedata.normalize("NFKD", paragraph['context']) + " "
                    cont_len = len(context)
                    add_up = ""
                    flag = 0
                    for i in range(cont_len):
                        if i == answer_start:
                            flag = 1
                        
                        if i == answer_start + len(answer):
                            flag = 3

                        if (context[i] == ' ') and (i > 0) and (context[i-1] != ' '):
                            
                            if flag == 0:
                                add_up += "O "
                            elif flag == 1:
                                add_up += "B "
                                flag = 2
                            elif flag == 2:
                                add_up += "I "
                            elif flag == 3:
                                add_up += "I "
                                flag = 0
                        
                    ret_list.append(add_up)
                            
    print(count)
    return ret_list

def save_txt(filename, data):
    with open(filename, 'w', encoding='utf-8') as f:
        for line in data:
            f.write(line + '\n')

in_file = "tydiqa-goldp-v1.1-dev.json"
ret_list = load_dataset(in_file)
save_txt("tel_dev_encoding.txt", ret_list)

in_file = "tydiqa-goldp-v1.1-train.json"
ret_list = load_dataset(in_file)

save_txt("tel_train_encoding.txt", ret_list)


