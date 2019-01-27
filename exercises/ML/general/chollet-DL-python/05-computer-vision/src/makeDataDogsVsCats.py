
import os, shutil

def makeData_dogs_vs_cats( dir_original, dir_derived ):

    ### ~~~~~~~~~~ ###
    train_dir      = os.path.join(dir_derived, 'train'     )
    validation_dir = os.path.join(dir_derived, 'validation')
    test_dir       = os.path.join(dir_derived, 'test'      )

    os.mkdir(train_dir)
    os.mkdir(validation_dir)
    os.mkdir(test_dir)

    ### ~~~~~~~~~~ ###
    train_cats_dir      = os.path.join(train_dir, 'cats')
    train_dogs_dir      = os.path.join(train_dir, 'dogs')

    validation_cats_dir = os.path.join(validation_dir, 'cats')
    validation_dogs_dir = os.path.join(validation_dir, 'dogs')

    test_cats_dir       = os.path.join(test_dir, 'cats')
    test_dogs_dir       = os.path.join(test_dir, 'dogs')

    os.mkdir(train_cats_dir)
    os.mkdir(train_dogs_dir)
    os.mkdir(validation_cats_dir)
    os.mkdir(validation_dogs_dir)
    os.mkdir(test_cats_dir)
    os.mkdir(test_dogs_dir)

    ### ~~~~~~~~~~ ###
    fnames = ['cat.{}.jpg'.format(i) for i in range(1000)]
    for fname in fnames:
        src = os.path.join(dir_original,   fname)
        dst = os.path.join(train_cats_dir, fname)
        shutil.copyfile(src, dst)

    fnames = ['cat.{}.jpg'.format(i) for i in range(1000, 1500)]
    for fname in fnames:
        src = os.path.join(dir_original,        fname)
        dst = os.path.join(validation_cats_dir, fname)
        shutil.copyfile(src, dst)

    fnames = ['cat.{}.jpg'.format(i) for i in range(1500, 2000)]
    for fname in fnames:
        src = os.path.join(dir_original,  fname)
        dst = os.path.join(test_cats_dir, fname)
        shutil.copyfile(src, dst)

    fnames = ['dog.{}.jpg'.format(i) for i in range(1000)]
    for fname in fnames:
        src = os.path.join(dir_original,   fname)
        dst = os.path.join(train_dogs_dir, fname)
        shutil.copyfile(src, dst)

    fnames = ['dog.{}.jpg'.format(i) for i in range(1000, 1500)]
    for fname in fnames:
        src = os.path.join(dir_original,        fname)
        dst = os.path.join(validation_dogs_dir, fname)
        shutil.copyfile(src, dst)

    fnames = ['dog.{}.jpg'.format(i) for i in range(1500, 2000)]
    for fname in fnames:
        src = os.path.join(dir_original,  fname)
        dst = os.path.join(test_dogs_dir, fname)
        shutil.copyfile(src, dst)

    return( None )

