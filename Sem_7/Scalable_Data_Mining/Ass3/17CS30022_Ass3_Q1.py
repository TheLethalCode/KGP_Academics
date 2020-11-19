import matplotlib.pyplot as plt
import numpy as np
from sklearn.model_selection import train_test_split

EPOCHS = 100
DATA = "LinearRegdata.txt"

# Shuffle X and Y in unison
def shuf(X, Y):
    p = np.random.permutation(len(X))
    return X[p], Y[p]


# Gradient of a
def diffa(y, ypred, x):
    return (y-ypred)*(-x)


# Gradient of b
def diffb(y, ypred):
    return (y-ypred)*(-1)


# Calculate Loss
def calc_loss(a, b, X, Y):
    losst = 0
    for i in range(len(X)):
        y_pred = a*X[i] + b
        losst += (Y[i] - y_pred)**2 / 2

    return losst / len(X)


# Calc loss and gradients
def gradients(a, b, X_train, Y_train):
    all_da, all_db = 0, 0
    for i in range(len(X_train)):
        y_pred = a*X_train[i] + b
        all_da += diffa(Y_train[i], y_pred, X_train[i])
        all_db += diffb(Y_train[i], y_pred)

    return all_da, all_db


# Batch Gradient Descent
def batch_gd(X_tra, Y_tra, X_test, Y_test, rate = 0.008):

    print("Running Batch GD")
    a, b = 12.0, 12.0
    best = 10**9
    X_train, Y_train = shuf(X_tra, Y_tra)

    loss_all, loss_ep = [calc_loss(a, b, X_train, Y_train)], [calc_loss(a, b, X_train, Y_train)]
    for _ in range(EPOCHS):
        print("Epoch {}".format(_))

        # Calc gradients and loss
        all_da, all_db = gradients(a, b, X_train, Y_train) # Calc grads
        
        # Update parameters
        a -= rate * all_da
        b -= rate * all_db

        # Loss after update
        loss_all.append(calc_loss(a, b, X_train, Y_train))

        # Epoch Loss
        loss_ep.append(calc_loss(a, b, X_train, Y_train))
        
        # Calculate best model
        best = min(best, calc_loss(a, b, X_test, Y_test))

    return "BATCH", loss_all, loss_ep, best


# Minibatch Gradient Descent
def minibatch_gd(X_tra, Y_tra, X_test, Y_test, batch = 10, rate = 0.02):

    print("Running Minibatch GD")
    a, b = 12.0, 12.0
    best = 10**9
    X_train, Y_train = shuf(X_tra, Y_tra)
    
    loss_all, loss_ep = [calc_loss(a, b, X_train, Y_train)], [calc_loss(a, b, X_train, Y_train)]
    for _ in range(EPOCHS):
        print("Epoch {}".format(_))
        
        # Batch wise 
        for j in range((len(X_train) + batch - 1) // batch):
            # Calc gradients and loss
            start = j * batch
            end = min((j+1) * batch, len(X_train))
            all_da, all_db = gradients(a, b, X_train[start:end], Y_train[start:end])

            # Parameters updated
            a -= rate * all_da
            b -= rate * all_db

            # Loss per update
            loss_all.append(calc_loss(a, b, X_train, Y_train))

        # Epoch Loss
        loss_ep.append(calc_loss(a, b, X_train, Y_train))

        # Calculate best model
        best = min(best, calc_loss(a, b, X_test, Y_test))

    return "MINIBATCH", loss_all, loss_ep, best


# Stochastic Gradient Descent
def stochastic_gd(X_tra, Y_tra, X_test, Y_test, rate = 0.02):
    print("Running Stochastic GD")

    a, b = 12.0, 12.0
    best = 10**9
    X_train, Y_train = shuf(X_tra, Y_tra)

    loss_all, loss_ep = [calc_loss(a, b, X_train, Y_train)], [calc_loss(a, b, X_train, Y_train)]
    for _ in range(EPOCHS):
        print("Epoch {}".format(_))

        for i in range(len(X_train)):
            # Calc gradients and loss
            all_da, all_db = gradients(a, b, X_train[i:i+1], Y_train[i:i+1])

            # Parameters updated
            a -= rate * all_da
            b -= rate * all_db

            # Loss per update
            loss_all.append(calc_loss(a, b, X_train, Y_train))

        # Epoch Loss
        loss_ep.append(calc_loss(a, b, X_train, Y_train))
        
        # Calculate best model
        best = min(best, calc_loss(a, b, X_test, Y_test))

    return "STOCHASTIC", loss_all, loss_ep, best


# Momentum Gradient Descent
def momentum_gd(X_tra, Y_tra, X_test, Y_test, gamma = 0.9, rate = 0.02):
    print("Running Momentum GD")

    a, b = 12.0, 12.0
    best = 10**9
    X_train, Y_train = shuf(X_tra, Y_tra)

    loss_all, loss_ep = [calc_loss(a, b, X_train, Y_train)], [calc_loss(a, b, X_train, Y_train)]
    v_a, v_b = 0, 0
    for _ in range(EPOCHS):
        print("Epoch {}".format(_))
        # Calc gradients and loss
        all_da, all_db = gradients(a, b, X_train, Y_train)

        # Parameters updated
        v_a = gamma * v_a + rate * all_da
        a -= v_a

        v_b = gamma * v_b + rate * all_db
        b -= v_b

        # Loss per update
        loss_all.append(calc_loss(a, b, X_train, Y_train))

        # Epoch Loss
        loss_ep.append(calc_loss(a, b, X_train, Y_train))

        # Calculate best model
        best = min(best, calc_loss(a, b, X_test, Y_test))

    return "MOMENTUM", loss_all, loss_ep, best


# Adam Gradient Descent
def adam_gd(X_tra, Y_tra, X_test, Y_test, b1 = 0.9, b2 = 0.999, eps = 1e-8, rate = 0.2):
    print("Running Adam GD")

    a, b = 12.0, 12.0
    best = 10**9
    X_train, Y_train = shuf(X_tra, Y_tra)

    loss_all, loss_ep = [calc_loss(a, b, X_train, Y_train)], [calc_loss(a, b, X_train, Y_train)]
    v_a, v_b = 0, 0
    m_a, m_b = 0, 0
    for ep in range(1, EPOCHS + 1):
        print("Epoch {}".format(ep))
        # Calc gradients and loss
        all_da, all_db = gradients(a, b, X_train, Y_train)

        # Parameters updated
        m_a = b1 * m_a + (1 - b1) * all_da
        v_a = b2 * v_a + (1 - b2) * all_da ** 2
        m_au = m_a / (1 - b1 ** ep)
        v_au = v_a / (1 - b2 ** ep)
        a -= rate / (np.sqrt(v_au) + eps) * m_au

        m_b = b1 * m_b + (1 - b1) * all_db
        v_b = b2 * v_b + (1 - b2) * all_db ** 2
        m_bu = m_b / (1 - b1 ** ep)
        v_bu = v_b / (1 - b2 ** ep)
        b -= rate / (np.sqrt(v_bu) + eps) * m_bu

        # Loss per update
        loss_all.append(calc_loss(a, b, X_train, Y_train))

        # Epoch Loss
        loss_ep.append(calc_loss(a, b, X_train, Y_train))

        # Calculate best model
        best = min(best, calc_loss(a, b, X_test, Y_test))

    return "ADAM", loss_all, loss_ep, best


def main():

    data = np.loadtxt(DATA)
    x = data[:, 1]
    y = data[:, 2]
    for i in range(5):
        print("x[",i,"] = ",x[i],",","y[",i,"] = ",y[i])

    # Normalize the data
    x_max, x_min, y_max, y_min = max(x), min(x), max(y), min(y)
    X = (x - x_min)/(x_max - x_min)
    Y = (y - y_min)/(y_max - y_min)
    X_train, X_test, Y_train, Y_test = train_test_split(X, Y, test_size=0.3, random_state=109)

    # Train Models
    OPTS = [batch_gd, minibatch_gd, stochastic_gd, momentum_gd, adam_gd]
    loss_data = []
    best_data = [[], []]
    for optimizer in OPTS:
        type_, loss_all, loss_epoch, best = optimizer(X_train, Y_train, X_test, Y_test)
        plt.plot(loss_all)
        plt.title("{} GRADIENT DESCENT".format(type_))
        plt.ylabel("Training Loss")
        plt.xlabel("Updates")
        plt.show()

        loss_data.append((type_, loss_epoch))
        best_data[0].append(type_)
        best_data[1].append(best)

    for temp in loss_data:
        plt.plot(temp[1][1:], label = temp[0])
    plt.xlabel("Epochs")
    plt.ylabel("Training Loss")
    plt.title("Training Loss for all optimisers")
    plt.legend()
    plt.show()

    plt.bar(best_data[0], best_data[1])
    plt.ylabel("Root Mean Square Error")
    plt.xlabel("Optimiser")
    plt.title("Valdiation Error vs. Optimiser")
    plt.show()

if __name__=='__main__':
    np.random.seed()
    main()