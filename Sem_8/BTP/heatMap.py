import numpy as np
import matplotlib
import matplotlib.pyplot as plt
from matplotlib.font_manager import FontProperties
# sphinx_gallery_thumbnail_number = 2

PATH = "Attn_matrix.txt"

if __name__ == '__main__':

    with open(PATH) as of:
        pred = of.readline()[:-1].split()
        src = of.readline()[:-1].split()
        attn = []
        for i in range(len(pred)):
            attn.append(list(map(float, of.readline()[:-1].split()))[:len(src)])
        attn = np.array(attn)

    print("Old Pred = {}\nOld Src = {}\n".format(len(pred), len(src)))
    pred = input(" ".join(pred) + "- ").split()
    src = input(" ".join(src) + "- ").split()
    print("New Pred = {}\nNew Src = {}\n".format(len(pred), len(src)))


    # predInd = [i for i in range(len(pred)) if i not in []]
    # srcInd = [i for i in range(len(src)) if i not in []]
    # attn = attn[predInd, srcInd]

    fig, ax = plt.subplots()
    im = ax.imshow(attn, cmap=plt.cm.Greys, vmax = 0.9)

    ax.set_xticks(np.arange(len(src)))
    ax.set_yticks(np.arange(len(pred)))
    
    prop = FontProperties()
    prop.set_size(18)
    # prop.set_file('kalpurush.ttf')

    for label in ax.get_xticklabels():
        label.set_fontproperties(prop)

    for label in ax.get_yticklabels():
        label.set_fontproperties(prop)

    ax.set_xticklabels(src)
    ax.set_yticklabels(pred)
    plt.setp(ax.get_xticklabels(), rotation=45, ha="right",
            rotation_mode="anchor")

    for edge, spine in ax.spines.items():
        spine.set_visible(False)

    # ax.set_title("Attention Matrix - With OT")
    fig.tight_layout()
    plt.show()