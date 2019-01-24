
from keras.datasets import imdb

from keras import models
from keras import layers
from keras import optimizers
from keras import metrics

import numpy as np

import matplotlib.pyplot as plt

from vectorizeSequences import vectorize_sequences

def section3pt4():

    (train_data, train_labels), (test_data, test_labels) = imdb.load_data(num_words=10000)

    print('\ntrain_data.shape')
    print(   train_data.shape )

    print('\ntrain_labels.shape')
    print(   train_labels.shape )

    print('\ntest_data.shape')
    print(   test_data.shape )

    print('\ntest_labels.shape')
    print(   test_labels.shape )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    max_train_data = max([max(sequence) for sequence in train_data])
    print('\nmax_train_data')
    print(   max_train_data )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    word_index = imdb.get_word_index()
    reverse_word_index = dict([(value, key) for (key, value) in word_index.items()])
    decoded_review = ' '.join([reverse_word_index.get(i - 3, '?') for i in train_data[0]])
    print('\ndecoded_review')
    print(   decoded_review )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    x_train = vectorize_sequences(train_data)
    x_test  = vectorize_sequences( test_data)

    y_train = np.asarray(train_labels).astype('float32')
    y_test  = np.asarray( test_labels).astype('float32')

    print('\nx_train.shape')
    print(   x_train.shape )

    print('\ny_train.shape')
    print(   y_train.shape )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    model = models.Sequential()
    model.add(layers.Dense(16, activation='relu', input_shape=(10000,)))
    model.add(layers.Dense(16, activation='relu'))
    model.add(layers.Dense( 1, activation='sigmoid'))

    model.compile(
        optimizer = 'rmsprop',
        loss      = 'binary_crossentropy',
        metrics   = ['accuracy']
        )

    model.fit(x_train, y_train, epochs = 4, batch_size = 512)

    results = model.evaluate(x_test, y_test)
    print('\nresults (4 epochs)')
    print(   results )

    predictions = model.predict(x_test)
    print('\npredictions (4 epochs)')
    print(   predictions )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    # return( None )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    model = models.Sequential()

    model.add(layers.Dense(16, activation='relu', input_shape=(10000,)))
    model.add(layers.Dense(16, activation='relu'))
    model.add(layers.Dense( 1, activation='sigmoid'))

    model.compile(
        #optimizer = optimizers.RMSprop(lr=0.001),
        optimizer  = 'rmsprop',
        loss       = 'binary_crossentropy',
        metrics    = ['accuracy']
        # metrics  = [metrics.binary_accuracy]
        )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    x_val           = x_train[:10000]
    partial_x_train = x_train[10000:]

    y_val           = y_train[:10000]
    partial_y_train = y_train[10000:]

    fitting_history = model.fit(
        partial_x_train,
        partial_y_train,
        epochs          = 20,
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

    outputFILE = 'plot-train-validation-loss.png'
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

    outputFILE = 'plot-train-validation-accuracy.png'
    plt.plot(epochs,     acc_values, 'bo', label='Training accuracy'  )
    plt.plot(epochs, val_acc_values, 'b',  label='Validation accuracy')
    plt.title('Training and validation accuracy')
    plt.xlabel('Epochs')
    plt.ylabel('Loss')
    plt.legend()
    plt.savefig(fname = outputFILE, dpi = 600, bbox_inches = 'tight', pad_inches = 0.2)
    plt.clf()

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

