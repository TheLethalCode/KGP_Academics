import torch
import torch.nn as nn
import torch.optim as optim
from torchvision import datasets, transforms
import matplotlib.pyplot as plt
import numpy as np

BATCH = 100
EPOCHS = 5

# Setting up the model
class ConvNet(nn.Module):
    def __init__(self):
        super(ConvNet, self).__init__()
        self.layer1 = nn.Sequential(
                    nn.Conv2d(1, 32, kernel_size = 5, stride = 1, padding = 2),
                    nn.ReLU(),
                    nn.MaxPool2d(kernel_size = 2, stride = 2))
        self.layer2 = nn.Sequential(
                    nn.Conv2d(32, 64, kernel_size = 5, stride = 1, padding = 2),
                    nn.ReLU(),
                    nn.MaxPool2d(kernel_size = 2, stride = 2))
        self.dropout = nn.Dropout()
        self.fc1 = nn.Linear(7 * 7 * 64, 1000)
        self.fc2 = nn.Linear(1000, 10)

    def forward(self, x):
        output = self.layer1(x)
        output = self.layer2(output)
        output = output.reshape(output.size(0), -1)
        output = self.dropout(output)
        output = self.fc1(output)
        output = self.fc2(output)
        return output


# Train the dataset
def train(model, criterion, optimizer, train_loader):
    
    model.train() # Set the model to training mode

    loss_all = []
    for i, data in enumerate(train_loader):
        
        inputs, labels = data
        optimizer.zero_grad()

        # Forward pass + Loss + Backward
        outputs = model(inputs)
        loss = criterion(outputs, labels)
        loss.backward()
        optimizer.step()

        loss_all.append(loss.item())

        if (i + 1) % 100 == 0:
            print("{} iterations done. Loss:- {:.4f}".format(i+1, loss_all[-1]))

    return loss_all


# Test the model accuracy
def test(model, test_loader):
    
    model.eval() # Set the model to evaluation mode
    with torch.no_grad():

        okay, evaluated = 0, 0
        for data in test_loader:
            
            inputs, labels = data
            out = model(inputs)

            # The number of correct values
            _, value = torch.max(out.data, 1)
            okay += (value == labels).sum().item()
            evaluated += labels.size(0)

    return okay / evaluated * 100


if __name__=='__main__':

    torch.manual_seed(1)

    # Load the dataset into data loader object
    trans = transforms.Compose([
                transforms.ToTensor(),
                transforms.Normalize((0.1307,), (0.3081,)) # Mean and SD of MNSIT
                    ])

    train_data = datasets.MNIST('./', train=True, transform=trans, download=True)
    test_data = datasets.MNIST('./', train=False, transform=trans)

    train_loader = torch.utils.data.DataLoader(train_data, batch_size = BATCH, shuffle = True)
    test_loader = torch.utils.data.DataLoader(test_data, batch_size = BATCH)

    # Model Parameters

    lrs = [0.002, 0.02, 0.2]
    for lr in lrs:

        model = ConvNet()
        criterion = nn.CrossEntropyLoss()

        optimisers = { "ADAM" : optim.Adam(model.parameters(), lr = lr),
                    "MINIBATCH" : optim.SGD(model.parameters(), lr = lr),
                    "MOMENTUM" : optim.SGD(model.parameters(), lr = lr, momentum=0.9),
                    "NESTEROV" : optim.SGD(model.parameters(), lr = lr, momentum=0.9, nesterov=True)
                    }
        
        loss_data = []
        best_data = [[], []]
        for opt_type in optimisers:
            
            print("Training model by {} Gradient Descent with Learning Rate {}".format(opt_type, lr))

            # Optimiser and Step Decay Learning rate Scheduler.
            optimiser = optimisers[opt_type]
            scheduler = optim.lr_scheduler.StepLR(optimiser, step_size = 1, gamma = 0.6)

            loss_epoch = []
            loss_all = []
            test_acc = []

            for epoch in range(EPOCHS):

                loss_cur = train(model, criterion, optimiser, train_loader)

                # Loss per update and per epoch
                loss_epoch.append(np.mean(loss_cur))
                loss_all.extend(loss_cur) 
                
                test_acc.append(test(model, test_loader)) # Test Accuracy
                
                scheduler.step() # Learning Rate Decay
                print("EPOCH {} DONE. \nCurrent Loss:- {:.4f}\n".format(epoch + 1, loss_epoch[-1]))
                print("Current learning rate:- {:0.7f}".format(scheduler.get_last_lr()[0]))

            print("Training Done.\nBest Accuracy : {:.2f} %".format(np.max(test_acc)))

            # Plot loss per update
            plt.plot(loss_all)
            plt.title("{} GRADIENT DESCENT (LR = {})".format(opt_type, lr))
            plt.ylabel("Training Loss")
            plt.xlabel("Updates")
            plt.show()

            # Loss epoch data
            loss_data.append((opt_type, loss_epoch))

            # Best Accuracy
            best_data[0].append(opt_type)
            best_data[1].append(np.max(test_acc))
        
        # Plot loss epoch graph
        for temp in loss_data:
            plt.plot(temp[1], label = temp[0])
        plt.xlabel("Epochs")
        plt.ylabel("Training Loss")
        plt.title("Training Loss for all optimisers (LR = {})".format(lr))
        plt.legend()
        plt.show()

        # Plot Accuracy vs Optimiser
        plt.bar(best_data[0], best_data[1])
        plt.ylabel("Accuracy")
        plt.xlabel("Optimiser")
        plt.title("Best Accuracy vs. Optimiser (LR = {})".format(lr))
        plt.show()

