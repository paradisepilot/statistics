
from keras.datasets import reuters
from keras.utils.np_utils import to_categorical
from keras import models, layers, optimizers, metrics

import numpy as np
import matplotlib.pyplot as plt

from vectorizeSequences import vectorize_sequences

def section3pt5():

    print('\n##############################')
    print('\nstarting: section3pt5()')

    (train_data, train_labels), (test_data, test_labels) = reuters.load_data(num_words=10000)

    print('\ntrain_data.shape')
    print(   train_data.shape )

    print('\ntrain_labels.shape')
    print(   train_labels.shape )

    print('\ntest_data.shape')
    print(   test_data.shape )

    print('\ntest_labels.shape')
    print(   test_labels.shape )

    print('\ntrain_data[10]')
    print(   train_data[10] )

    print('\ntrain_labels[10]')
    print(   train_labels[10] )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    max_train_data = max([max(sequence) for sequence in train_data])
    print('\nmax_train_data')
    print(   max_train_data )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    word_index = reuters.get_word_index()
    reverse_word_index = dict([(value, key) for (key, value) in word_index.items()])
    decoded_reuters = ' '.join([reverse_word_index.get(i - 3, '?') for i in train_data[0]])
    # Note that the indices are offset by 3 because 0, 1, and 2 are reserved
    # indices for “padding,” “start of sequence,” and “unknown.”
    print('\ndecoded_reuters')
    print(   decoded_reuters )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    x_train = vectorize_sequences(train_data)
    x_test  = vectorize_sequences( test_data)

    one_hot_train_labels = to_categorical(train_labels)
    one_hot_test_labels  = to_categorical( test_labels)

    print('\nx_train.shape')
    print(   x_train.shape )

    print('\none_hot_train_labels.shape')
    print(   one_hot_train_labels.shape )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print('\n### starting: fitting model with 9 epochs ...')

    model = models.Sequential()
    model.add(layers.Dense(64, activation='relu', input_shape=(10000,)))
    model.add(layers.Dense(64, activation='relu'   ))
    model.add(layers.Dense(46, activation='softmax'))

    print('\nmodel.summary()')
    print(   model.summary() )

    model.compile(
        optimizer = 'rmsprop',
        loss      = 'categorical_crossentropy',
        metrics   = ['accuracy']
        )

    model.fit(x_train, one_hot_train_labels, verbose = 2, epochs = 9, batch_size = 512)

    results = model.evaluate(x_test, one_hot_test_labels)
    print('\nresults (9 epochs)')
    print(   results )

    predictions = model.predict(x_test)
    print('\npredictions (9 epochs)')
    print(   predictions )

    print('\n### finished: fitting model with 9 epochs')
    print('\n')

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    # return( None )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    model = models.Sequential()

    model.add(layers.Dense(64, activation = 'relu', input_shape=(10000,)))
    model.add(layers.Dense(64, activation = 'relu'   ))
    model.add(layers.Dense(46, activation = 'softmax'))

    model.compile(
        #optimizer = optimizers.RMSprop(lr=0.001),
        optimizer  = 'rmsprop',
        loss       = 'categorical_crossentropy',
        metrics    = ['accuracy']
        # metrics  = [metrics.binary_accuracy]
        )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    x_val           = x_train[:1000]
    partial_x_train = x_train[1000:]

    y_val           = one_hot_train_labels[:1000]
    partial_y_train = one_hot_train_labels[1000:]

    print('\npartial_x_train.shape')
    print(   partial_x_train.shape )

    print('\npartial_y_train.shape')
    print(   partial_y_train.shape )

    fitting_history = model.fit(
        partial_x_train,
        partial_y_train,
        verbose         =   2,
        epochs          =  20,
        batch_size      = 512,
        validation_data = (x_val, y_val)
        )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    fitting_history_dict = fitting_history.history
    print('\nfitting_history_dict.keys()')
    print(   fitting_history_dict.keys() )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    loss_values     = fitting_history_dict['loss']
    val_loss_values = fitting_history_dict['val_loss']

    epochs = range(1, len(loss_values) + 1)

    outputFILE = 'plot-reuters-train-validation-loss.png'
    plt.plot(epochs,     loss_values, 'bo', label='Training loss'  )
    plt.plot(epochs, val_loss_values, 'b',  label='Validation loss')
    plt.title('Training and validation loss')
    plt.xlabel('Epochs')
    plt.ylabel('Loss')
    plt.legend()
    plt.savefig(fname = outputFILE, dpi = 600, bbox_inches = 'tight', pad_inches = 0.2)
    plt.clf()

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    acc_values     = fitting_history_dict['acc']
    val_acc_values = fitting_history_dict['val_acc']

    outputFILE = 'plot-reuters-train-validation-accuracy.png'
    plt.plot(epochs,     acc_values, 'bo', label='Training accuracy'  )
    plt.plot(epochs, val_acc_values, 'b',  label='Validation accuracy')
    plt.title('Training and validation accuracy')
    plt.xlabel('Epochs')
    plt.ylabel('Loss')
    plt.legend()
    plt.savefig(fname = outputFILE, dpi = 600, bbox_inches = 'tight', pad_inches = 0.2)
    plt.clf()

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print('\nexitng: section3pt5()')
    print('\n##############################')

    return( None )

