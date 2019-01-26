
from keras.datasets import boston_housing
from keras import models, layers, optimizers, metrics

import numpy as np
import matplotlib.pyplot as plt

from smoothCurve import smooth_curve

def build_model(train_data):
    model = models.Sequential()

    model.add(layers.Dense(64, activation = 'relu', input_shape = (train_data.shape[1],)))
    model.add(layers.Dense(64, activation = 'relu'))
    model.add(layers.Dense(1)) # no activation function; hence a linear layer

    model.compile(optimizer = 'rmsprop', loss = 'mse', metrics = ['mae'])
    return model

def section3pt6():

    print('\n##############################')
    print('\nstarting: section3pt6()')

    (train_data, train_targets), (test_data, test_targets) = boston_housing.load_data()

    print('\ntrain_data.shape')
    print(   train_data.shape )

    print('\ntrain_targets.shape')
    print(   train_targets.shape )

    print('\ntest_data.shape')
    print(   test_data.shape )

    print('\ntest_targets.shape')
    print(   test_targets.shape )

    print('\ntrain_targets')
    print(   train_targets )

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
    print('\nexitng: section3pt6()')
    print('\n##############################')

    return( None )

