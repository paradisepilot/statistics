
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

    model.add(layers.Conv2D(32, (3, 3), activation='relu', input_shape=(28, 28, 1)))
    model.add(layers.MaxPooling2D((2, 2)))
    model.add(layers.Conv2D(64, (3, 3), activation='relu'))
    model.add(layers.MaxPooling2D((2, 2)))
    model.add(layers.Conv2D(64, (3, 3), activation='relu'))

    model.add(layers.Flatten())
    model.add(layers.Dense(64, activation='relu'))
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
        train_images,
        train_labels,
        epochs     =  5,
        batch_size = 64,
        verbose    =  2
        )

    test_loss, test_acc = myMLP.evaluate(test_images, test_labels)
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
    print('\n### starting: fitting CNN ...')
    myCNN = get_untrained_CNN()

    print('\nmyCNN.summary()')
    print(   myCNN.summary() )

    myCNN.fit(
        train_images,
        train_labels,
        epochs     =  5,
        batch_size = 64,
        verbose    =  2
        )

    test_loss, test_acc = myCNN.evaluate(test_images, test_labels)
    print('\ntest_acc')
    print(   test_acc )

    print('\n### finished: fitting CNN')
    print('\n')

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    # normalize data
    mean        = train_data.mean(axis=0)
    train_data -= mean
    std         = train_data.std(axis=0)
    train_data /= std

    test_data  -= mean
    test_data  /= std

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print('\n### starting: fitting model with 80 epochs ...')
    model = build_model(train_data = train_data)

    print('\nmodel.summary()')
    print(   model.summary() )

    model.fit(
        train_data,
        train_targets,
        epochs     = 80,
        batch_size = 16,
        verbose    =  2
        )

    test_mse_score, test_mae_score = model.evaluate(test_data, test_targets)

    print('\ntest_mse_score:',test_mse_score)
    print('\ntest_mae_score:',test_mae_score)

    print('\n### finished: fitting model with 80 epochs')
    print('\n')

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    # return( None )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print('\n### starting: training with k-fold cross-validation ...')

    k = 4 # number of fold (in k-fold cross-validation)
    num_val_samples = len(train_data) // k

    num_epochs        = 500
    all_mae_histories = []
    for i in range(k):
        print('processing fold #', i)
        val_data    = train_data[   i * num_val_samples: (i + 1) * num_val_samples]
        val_targets = train_targets[i * num_val_samples: (i + 1) * num_val_samples]

        partial_train_data = np.concatenate(
            [train_data[:i * num_val_samples], train_data[(i + 1) * num_val_samples:]],
            axis = 0
            )

        partial_train_targets = np.concatenate(
            [train_targets[:i * num_val_samples], train_targets[(i + 1) * num_val_samples:]],
            axis = 0
            )

        model = build_model(train_data = partial_train_data)

        history = model.fit(
            partial_train_data,
            partial_train_targets,
            validation_data = (val_data, val_targets),
            epochs     = num_epochs,
            batch_size = 1,
            verbose    = 2
            )
        mae_history = history.history['val_mean_absolute_error']
        all_mae_histories.append(mae_history)

    average_mae_history = [ np.mean([x[i] for x in all_mae_histories]) for i in range(num_epochs) ]

    print('\n### finished: training with k-fold cross-validation')
    print('\n')

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    outputFILE = 'plot-housing-validation.png'
    plt.plot(range(1, len(average_mae_history) + 1), average_mae_history)
    plt.title('Validation MAE by epoch')
    plt.xlabel('Epochs')
    plt.ylabel('Validation MAE')
    plt.legend()
    plt.savefig(fname = outputFILE, dpi = 600, bbox_inches = 'tight', pad_inches = 0.2)
    plt.clf()

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    outputFILE = 'plot-housing-validation-exclude-first-ten.png'
    smooth_mae_history = smooth_curve(average_mae_history[10:])
    plt.plot(range(1, len(smooth_mae_history) + 1), smooth_mae_history)
    plt.title('Validation MAE by epoch, excluding first 10 data points')
    plt.xlabel('Epochs')
    plt.ylabel('Validation MAE')
    plt.savefig(fname = outputFILE, dpi = 600, bbox_inches = 'tight', pad_inches = 0.2)
    plt.clf()

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print('\nexitng: section5pt1()')
    print('\n##############################')

    return( None )

