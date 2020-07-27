import numpy as np
import matplotlib.pyplot as plt

class TwoLayerMLP(object):
  """
  A two-layer fully-connected neural network. The net has an input dimension of
  N, a hidden layer dimension of H, and performs classification over C classes.
  We train the network with a softmax loss function and L2 regularization on the
  weight matrices. The network uses a ReLU nonlinearity after the first fully
  connected layer.

  In other words, the network has the following architecture:

  input - fully connected layer - ReLU - fully connected layer - softmax

  The outputs of the second fully-connected layer are the scores for each class.
  """

  def __init__(self, input_size, hidden_size, output_size, std=1e-4, activation='relu'):
    """
    Initialize the model. Weights are initialized to small random values and
    biases are initialized to zero. Weights and biases are stored in the
    variable self.params, which is a dictionary with the following keys:

    W1: First layer weights; has shape (D, H)
    b1: First layer biases; has shape (H,)
    W2: Second layer weights; has shape (H, C)
    b2: Second layer biases; has shape (C,)

    Inputs:
    - input_size: The dimension D of the input data.
    - hidden_size: The number of neurons H in the hidden layer.
    - output_size: The number of classes C.
    """
    self.params = {}
    self.params['W1'] = std * np.random.randn(input_size, hidden_size)
    self.params['b1'] = np.zeros(hidden_size)
    self.params['W2'] = std * np.random.randn(hidden_size, output_size)
    self.params['b2'] = np.zeros(output_size)
    self.activation = activation

  def loss(self, X, y=None, reg=0.0):
    """
    Compute the loss and gradients for a two layer fully connected neural
    network.

    Inputs:
    - X: Input data of shape (N, D). Each X[i] is a training sample.
    - y: Vector of training labels. y[i] is the label for X[i], and each y[i] is
      an integer in the range 0 <= y[i] < C. This parameter is optional; if it
      is not passed then we only return scores, and if it is passed then we
      instead return the loss and gradients.
    - reg: Regularization strength.

    Returns:
    If y is None, return a matrix scores of shape (N, C) where scores[i, c] is
    the score for class c on input X[i].

    If y is not None, instead return a tuple of:
    - loss: Loss (data loss and regularization loss) for this batch of training
      samples.
    - grads: Dictionary mapping parameter names to gradients of those parameters
      with respect to the loss function; has the same keys as self.params.
    """
    # Unpack variables from the params dictionary
    W1, b1 = self.params['W1'], self.params['b1']
    W2, b2 = self.params['W2'], self.params['b2']
    _, C = W2.shape
    N, D = X.shape

    # Compute the forward pass
    scores = None
    ###########################################################################
    # TODO: Fill in the blanks.
    # Perform the forward pass, computing the class scores for the input.
    # Store the result in the scores variable, which should be an array of
    # shape (N, C).
    ###########################################################################
    z1 = np.dot(X, W1) + b1  # 1st layer activation, N*H   

    # 1st layer nonlinearity, N*H
    if self.activation is 'relu':
        hidden = np.maximum(0, z1)

    elif self.activation is 'softplus':
        z1 = np.clip(z1, -20, 20)
        hidden = np.log(1 + np.exp(z1))

    elif self.activation is 'sigmoid':
        hidden = 1/(1+np.exp(-1*(z1 * (z1 < 20)))) * (z1 < 20)
        hidden = hidden * (z1 > -20) + np.ones(z1.shape, dtype=np.float) * (z1 <= -20)

    else:
        raise ValueError('Unknown activation type')
        
    scores = np.dot(hidden, W2) + b2  # 2nd layer activation, N*C
    ###########################################################################
    #                            END OF YOUR CODE
    ###########################################################################
    
    # If the targets are not given then jump out, we're done
    if y is None:
      return scores

    # Compute the loss
    loss = None
    ###########################################################################
    # TODO: Finish the forward pass, and compute the loss. This should include
    # both the data loss and L2 regularization for W1 and W2. Store the result
    # in the variable loss, which should be a scalar. Use the Softmax
    # classifier loss. So that your results match ours, multiply the 
    # regularization loss by 0.5.
    ###########################################################################
    logits = np.exp(scores)
    prob = logits/np.sum(logits, axis=1, keepdims=True)
    loss = np.mean(-np.log(prob)[range(N),y])
    weight_reg = np.linalg.norm(W1) ** 2 + np.linalg.norm(W2) ** 2
    loss += 0.5 * reg * weight_reg
    ###########################################################################
    #                            END OF YOUR CODE
    ###########################################################################

    # Backward pass: compute gradients
    grads = {}
    ###########################################################################
    # TODO: Fill in the blanks, replace the `None`s with your implementation.
    #
    # Compute the backward pass, computing the derivatives of the weights
    # and biases. Store the results in the grads dictionary. For example,
    # grads['W1'] should store the gradient on W1, and be a matrix of same size
    ###########################################################################

    # output layer
    dscore = (np.exp(scores)/np.sum(np.exp(scores), axis=1, keepdims=True) - np.identity(C)[y])/N # partial derivative of loss wrt. the logits (dL/dz)
    dW2 = hidden.T @ dscore + reg * W2     # partial derivative of loss wrt. W2
    db2 = np.sum(dscore, axis=0)     # and so on...

    # hidden layer
    dhidden = dscore @ W2.T

    if self.activation is 'relu':
        dz1 = dhidden
        dz1[z1 <= 0] = 0
        # bug: thanks Ruidi Chen for pointing it out!
        # dz1[hidden <= 0] = 0
    
    elif self.activation is 'softplus':
          dz1 = dhidden
          dz1 *= np.exp(z1)/(1 + np.exp(z1))

    elif self.activation is 'sigmoid':
          dz1 = dhidden
          dz1 *= hidden * (1 - hidden)
          
    else:
        raise ValueError('Unknown activation type')

    # first layer
    dW1 = X.T @ dz1 + reg * W1
    db1 =  np.sum(dz1, axis=0)

    grads['W2'] = dW2
    grads['b2'] = db2
    grads['W1'] = dW1
    grads['b1'] = db1
    ###########################################################################
    #                            END OF YOUR CODE
    ###########################################################################

    return loss, grads

  def train(self, X, y, X_val, y_val,
            learning_rate=1e-3, learning_rate_decay=0.95,
            reg=1e-5, num_epochs=10,
            batch_size=200, verbose=False):
    """
    Train this neural network using stochastic gradient descent.

    Inputs:
    - X: A numpy array of shape (N, D) giving training data.
    - y: A numpy array f shape (N,) giving training labels; y[i] = c means that
      X[i] has label c, where 0 <= c < C.
    - X_val: A numpy array of shape (N_val, D) giving validation data.
    - y_val: A numpy array of shape (N_val,) giving validation labels.
    - learning_rate: Scalar giving learning rate for optimization.
    - learning_rate_decay: Scalar giving factor used to decay the learning rate
      after each epoch.
    - reg: Scalar giving regularization strength.
    - num_iters: Number of steps to take when optimizing.
    - batch_size: Number of training examples to use per step.
    - verbose: boolean; if true print progress during optimization.
    """
    num_train = X.shape[0]
    iterations_per_epoch = max(num_train // batch_size, 1)
    epoch_num = 0

    # Use SGD to optimize the parameters in self.model
    loss_history = []
    grad_magnitude_history = []
    train_acc_history = []
    val_acc_history = []

    np.random.seed(1)
    for epoch in range(num_epochs):
        # fixed permutation (within this epoch) of training data
        perm = np.random.permutation(num_train)

        # go through minibatches
        for it in range(iterations_per_epoch):
            X_batch = None
            y_batch = None

            # Create a random minibatch
            idx = perm[it*batch_size:(it+1)*batch_size]
            X_batch = X[idx, :]
            y_batch = y[idx]

            # Compute loss and gradients using the current minibatch
            loss, grads = self.loss(X_batch, y=y_batch, reg=reg)
            loss_history.append(loss)

            # do gradient descent
            for param in self.params:
                self.params[param] -= grads[param] * learning_rate

            # record gradient magnitude (Frobenius) for W1
            grad_magnitude_history.append(np.linalg.norm(grads['W1']))

        # Every epoch, check train and val accuracy and decay learning rate.
        # Check accuracy
        train_acc = (self.predict(X_batch) == y_batch).mean()
        val_acc = (self.predict(X_val) == y_val).mean()
        train_acc_history.append(train_acc)
        val_acc_history.append(val_acc)
        if verbose:
            print ('Epoch %d: loss %f, train_acc %f, val_acc %f'%(
                epoch+1, loss, train_acc, val_acc))

        # Decay learning rate
        learning_rate *= learning_rate_decay

    return {
      'loss_history': loss_history,
      'grad_magnitude_history': grad_magnitude_history, 
      'train_acc_history': train_acc_history,
      'val_acc_history': val_acc_history,
    }

  def predict(self, X):
    """
    Use the trained weights of this two-layer network to predict labels for
    data points. For each data point we predict scores for each of the C
    classes, and assign each data point to the class with the highest score.

    Inputs:
    - X: A numpy array of shape (N, D) giving N D-dimensional data points to
      classify.

    Returns:
    - y_pred: A numpy array of shape (N,) giving predicted labels for each of
      the elements of X. For all i, y_pred[i] = c means that X[i] is predicted
      to have class c, where 0 <= c < C.
    """
    y_pred = None

    ###########################################################################
    # TODO: Implement this function; it should be VERY simple!
    ###########################################################################
    y_pred = np.argmax(self.loss(X), axis=1)
    ###########################################################################
    #                              END OF YOUR CODE
    ###########################################################################

    return y_pred


