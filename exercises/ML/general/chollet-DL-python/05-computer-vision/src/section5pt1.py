
from keras.datasets import mnist
from keras.utils    import to_categorical
from keras          import models, layers, optimizers, metrics

import numpy as np
import matplotlib.pyplot as plt

from smoothCurve import smooth_curve

def get_untrained_MLP():
    model = models.Sequential()

    model.add(layers.Dense(512, activation='relu', input_shape=(28 * 28,)))
    model.add(layers.Dense( 10, activation='softmax'))

    model.compile(optimizer = 'rmsprop', loss = 'categorical_crossentropy', metrics = ['accuracy'])
    return model

def get_untrained_CNN():
    model = models.Sequential()

    nFilters1 = 32
    nFilters2 = 64
    nFilters3 = 64
    nFilters4 = 64

    model.add(layers.Conv2D(nFilters1, (3, 3), activation='relu', input_shape=(28, 28, 1)))
    model.add(layers.MaxPooling2D((2, 2)))
    model.add(layers.Conv2D(nFilters2, (3, 3), activation='relu'))
    model.add(layers.MaxPooling2D((2, 2)))
    model.add(layers.Conv2D(nFilters3, (3, 3), activation='relu'))

    model.add(layers.Flatten())
    model.add(layers.Dense(nFilters4, activation='relu'))
    model.add(layers.Dense(10, activation='softmax'))

    model.compile(optimizer = 'rmsprop', loss = 'categorical_crossentropy', metrics = ['accuracy'])
    return model

def section5pt1():

    print('\n##############################')
    print('\nstarting: section5pt1()')

    (train_images, train_labels), (test_images, test_labels) = mnist.load_data()

    print('\ntrain_images.shape')
    print(   train_images.shape )

    print('\ntrain_labels.shape')
    print(   train_labels.shape )

    print('\ntest_images.shape')
    print(   test_images.shape )

    print('\ntest_labels.shape')
    print(   test_labels.shape )

    print('\ntrain_images[0].shape')
    print(   train_images[0].shape )

    print('\ntrain_images[0]')
    print(   train_images[0] )

    print('\ntrain_images[0][0][0]')
    print(   train_images[0][0][0] )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    train_images = train_images.reshape((60000, 28 * 28))
    train_images = train_images.astype('float32') / 255

    test_images  = test_images.reshape((10000, 28 * 28))
    test_images  = test_images.astype('float32') / 255

    train_labels = to_categorical(train_labels)
    test_labels  = to_categorical(test_labels)

    print('\n### starting: fitting MLP ...')
    myMLP = get_untrained_MLP()

    print('\nmyMLP.summary()')
    print(   myMLP.summary() )

    myMLP.fit(
        x          = train_images,
        y          = train_labels,
        epochs     =  5,
        batch_size = 64,
        verbose    =  2
        )

    test_loss, test_acc = myMLP.evaluate(
        x       = test_images,
        y       = test_labels,
        verbose = 2
        )

    print('\ntest_acc')
    print(   test_acc )

    print('\n### finished: fitting MLP')
    print('\n')

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    # return( None )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    (train_images, train_labels), (test_images, test_labels) = mnist.load_data()

    train_images = train_images.reshape((60000, 28, 28, 1))
    train_images = train_images.astype('float32') / 255

    test_images  = test_images.reshape((10000, 28, 28, 1))
    test_images  = test_images.astype('float32') / 255

    train_labels = to_categorical(train_labels)
    test_labels  = to_categorical(test_labels)

    print('\n### data reshaped for fitting CNN ...')

    print('\ntrain_images.shape')
    print(   train_images.shape )

    print('\ntrain_labels.shape')
    print(   train_labels.shape )

    print('\ntest_images.shape')
    print(   test_images.shape )

    print('\ntest_labels.shape')
    print(   test_labels.shape )

    print('\ntrain_images[0].shape')
    print(   train_images[0].shape )

    print('\ntrain_images[0][0][0]')
    print(   train_images[0][0][0] )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    #print('\n### starting: fitting CNN ...')
    #myCNN = get_untrained_CNN()
    #
    #print('\nmyCNN.summary()')
    #print(   myCNN.summary() )
    #
    #myCNN.fit(
    #    train_images,
    #    train_labels,
    #    epochs     =  5, # 5
    #    batch_size = 64,
    #    verbose    =  2
    #    )
    #
    #test_loss, test_acc = myCNN.evaluate(
    #    x       = test_images,
    #    y       = test_labels,
    #    verbose = 2
    #    )
    #
    #print('\ntest_acc')
    #print(   test_acc )
    #
    #print('\n### finished: fitting CNN')
    #print('\n')

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    # return( None )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print('\n### starting: training with k-fold cross-validation ...')

    k = 4 # number of fold (in k-fold cross-validation)
    num_val_samples = len(train_images) // k

    num_epochs        = 20
    val_acc_histories = []
    for i in range(k):
        print('processing fold #', i)
        val_images = train_images[i * num_val_samples: (i + 1) * num_val_samples]
        val_labels = train_labels[i * num_val_samples: (i + 1) * num_val_samples]

        partial_train_images = np.concatenate(
            [train_images[:i * num_val_samples], train_images[(i + 1) * num_val_samples:]],
            axis = 0
            )

        partial_train_labels = np.concatenate(
            [train_labels[:i * num_val_samples], train_labels[(i + 1) * num_val_samples:]],
            axis = 0
            )

        model = get_untrained_CNN()

        history = model.fit(
            partial_train_images,
            partial_train_labels,
            validation_data = (val_images, val_labels),
            epochs     = num_epochs,
            batch_size = 64,
            verbose    =  2
            )

        history_dict = history.history
        print('\nhistory_dict.keys()')
        print(   history_dict.keys() )

        val_acc_history = history.history['val_acc']
        val_acc_histories.append(val_acc_history)

    avg_val_acc_history = [ np.mean([x[i] for x in val_acc_histories]) for i in range(num_epochs) ]

    print('\n### finished: training with k-fold cross-validation')
    print('\n')

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    outputFILE = 'plot-mnist-validation.png'
    plt.plot(range(1, len(avg_val_acc_history) + 1), avg_val_acc_history)
    plt.title('')
    plt.xlabel('epoch')
    plt.ylabel('mean 4-fold cross validation Accuracy')
    plt.legend()
    plt.savefig(fname = outputFILE, dpi = 600, bbox_inches = 'tight', pad_inches = 0.2)
    plt.clf()

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    outputFILE = 'plot-mnist-validation-smoothed-exclude-first-ten.png'
    smooth_val_acc_history = smooth_curve(avg_val_acc_history[10:])
    plt.plot(range(1, len(smooth_val_acc_history) + 1), smooth_val_acc_history)
    plt.title('smoothed, excluding first 10 data points')
    plt.xlabel('epoch')
    plt.ylabel('mean 4-fold cross validation Accuracy')
    plt.savefig(fname = outputFILE, dpi = 600, bbox_inches = 'tight', pad_inches = 0.2)
    plt.clf()

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print('\nexitng: section5pt1()')
    print('\n##############################')

    return( None )

