
from keras.utils import to_categorical
from keras       import models, layers, optimizers, metrics

from keras.preprocessing.image import ImageDataGenerator

import os
import numpy as np
import matplotlib.pyplot as plt

from makeDataDogsVsCats import makeData_dogs_vs_cats

def get_untrained_CNN():
    model = models.Sequential()

    model.add(layers.Conv2D(32, (3, 3), activation='relu', input_shape=(150, 150, 3)))
    model.add(layers.MaxPooling2D((2, 2)))

    model.add(layers.Conv2D(64, (3, 3), activation='relu'))
    model.add(layers.MaxPooling2D((2, 2)))

    model.add(layers.Conv2D(128, (3, 3), activation='relu'))
    model.add(layers.MaxPooling2D((2, 2)))

    model.add(layers.Conv2D(128, (3, 3), activation='relu'))
    model.add(layers.MaxPooling2D((2, 2)))

    model.add(layers.Flatten())
    model.add(layers.Dense(512, activation='relu'   ))
    model.add(layers.Dense(  1, activation='sigmoid'))

    model.compile(
        loss      = 'binary_crossentropy',
        optimizer = optimizers.RMSprop(lr=1e-4),
        metrics   = ['accuracy']
        )

    return model

def section5pt2(dir_original, dir_derived):

    print('\n##############################')
    print('\nstarting: section5pt2()')

    print("\ndir_original: " + dir_original)
    print("\ndir_derived:  " + dir_derived )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    #makeData_dogs_vs_cats(
    #    dir_original = dir_original,
    #    dir_derived  = dir_derived
    #    )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    dir_train      = os.path.join(dir_derived,"train")
    dir_validation = os.path.join(dir_derived,"validation")

    print("\ndir_train:      " + dir_train      + ", exists:" + str(os.path.exists(dir_train     )))
    print("\ndir_validation: " + dir_validation + ", exists:" + str(os.path.exists(dir_validation)))
    print("")

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    imgDG_training   = ImageDataGenerator(rescale=1./255)
    imgDG_validation = ImageDataGenerator(rescale=1./255)

    generator_training = imgDG_training.flow_from_directory(
        directory   = os.path.join(dir_derived,"train"),
        target_size = (150, 150),
        batch_size  = 20,
        class_mode  = 'binary'
        )

    generator_validation = imgDG_validation.flow_from_directory(
        directory   = os.path.join(dir_derived,"validation"),
        target_size = (150, 150),
        batch_size  = 20,
        class_mode  = 'binary'
        )

    for data_batch, labels_batch in generator_training:
        print('data batch shape:',     data_batch.shape)
        print('labels batch shape:', labels_batch.shape)
        break

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print('\n### starting: fitting CNN ...')
    myCNN = get_untrained_CNN()

    print('\nmyCNN.summary()')
    print(   myCNN.summary() )

    history = myCNN.fit_generator(
        generator        = generator_training,
        verbose          =   2,
        steps_per_epoch  = 100,
        epochs           =   2, # 30,
        validation_data  = generator_validation,
        validation_steps =  50
        )

    print('\n### finished: fitting CNN')
    print("\n")

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print('\n### starting: saving trained model ...')

    myCNN.save(filepath = 'trained-CNN-dogs-vs-cats-small-01.h5')

    print('\n### finished: saving trained model')
    print("\n")

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print('\n### starting: generating graphics ...')

    outputFILE = 'plot-dogs-vs-cats-accuracy.png'

    acc     = history.history['acc']
    val_acc = history.history['val_acc']

    epochs = range(1, len(acc) + 1)
    plt.plot(epochs,     acc, 'bo', label='training'  )
    plt.plot(epochs, val_acc, 'b',  label='validation')

    plt.title('Training and validation accuracy')
    plt.xlabel('epoch')
    plt.ylabel('accuracy')
    plt.legend()

    plt.savefig(fname = outputFILE, dpi = 600, bbox_inches = 'tight', pad_inches = 0.2)
    plt.clf()

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    outputFILE = 'plot-dogs-vs-cats-loss.png'

    loss     = history.history['loss']
    val_loss = history.history['val_loss']

    epochs = range(1, len(loss) + 1)
    plt.plot(epochs,     loss, 'bo', label='training'  )
    plt.plot(epochs, val_loss, 'b',  label='validation')

    plt.title('Training and validation loss')
    plt.xlabel('epoch')
    plt.ylabel('loss')
    plt.legend()

    plt.savefig(fname = outputFILE, dpi = 600, bbox_inches = 'tight', pad_inches = 0.2)
    plt.clf()

    print('\n### finished: generating graphics')
    print("\n")

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print('\nexitng: section5pt2()')
    print('\n##############################')

    return( None )

