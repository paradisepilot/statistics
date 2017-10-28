
import numpy      as np

from sklearn.metrics          import accuracy_score
from sklearn.preprocessing    import StandardScaler
from tensorflow.contrib.learn import SKCompat, DNNClassifier, infer_real_valued_columns_from_input


def trainMLPviaAPI( mnistTrain, mnistTest ):

    print("\n####################")
    print("trainMLPviaAPI():\n")

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print( "type(mnistTrain): " + str(type(mnistTrain)) )
    print( "mnistTrain.columns: " + str(mnistTrain.columns) )
    print( "mnistTrain.iloc[1:5,:]" )
    print(  mnistTrain.iloc[0:5,:]  )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    myScaler = StandardScaler()

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    X_train = mnistTrain.drop(labels = ['index','label'], axis=1)
    X_train = X_train.astype('float32')

    X_train_scaled = myScaler.fit_transform(X_train)
    X_train_scaled = X_train_scaled.astype('float32')

    y_train = mnistTrain['label'].astype('int')

    print( "type(X_train): " + str(type(X_train)) )
    #print( "X_train.iloc[0:5,:]" )
    #print(  X_train.iloc[0:5,:]  )

    print( "type(X_train_scaled): " + str(type(X_train_scaled)) )
    print( "X_train_scaled.shape: " + str(X_train_scaled.shape) )
    #print( "X_train_scaled[0:5,:]" )
    #print(  X_train_scaled[0:5,:]  )

    print( "type(y_train): " + str(type(y_train)) )
    print( "y_train.shape: " + str(y_train.shape) )
    #print( "y_train[0:5]" )
    #print(  y_train[0:5]  )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    X_test = mnistTest.drop(labels = ['index','label'], axis=1)
    X_test = X_test.astype('float32')

    X_test_scaled = myScaler.transform(X_test)
    X_test_scaled = X_test_scaled.astype('float32')

    y_test = mnistTest['label'].astype('int')

    print( "type(X_test): " + str(type(X_test)) )
    #print( "X_test.iloc[0:5,:]" )
    #print(  X_test.iloc[0:5,:]  )

    print( "type(X_test_scaled): " + str(type(X_test_scaled)) )
    print( "X_test_scaled.shape: " + str(X_test_scaled.shape) )
    #print( "X_test_scaled[0:5,:]" )
    #print(  X_test_scaled[0:5,:]  )

    print( "type(y_test): " + str(type(y_test)) )
    print( "y_test.shape: " + str(y_test.shape) )
    #print( "y_test[0:5]" )
    #print(  y_test[0:5]  )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print("\ntraining begins ...")

    featureColumns = infer_real_valued_columns_from_input(X_train_scaled)

    clfDNN = SKCompat(DNNClassifier(
        hidden_units    = [300,100],
        n_classes       = 10,
        feature_columns = featureColumns
        ))

    clfDNN.fit(x = X_train_scaled, y = y_train, batch_size = 50, steps = 40000)

    print("\ntraining complete.\n")

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    y_predicted = clfDNN.predict(X_test_scaled)
    y_predicted = y_predicted['classes']
    print( "type(y_predicted): " + str(type(y_predicted)) )
    print( "y_predicted:" )
    print(  y_predicted   )
    #print( "y_predicted.shape: " + str(y_predicted.shape) )

    print( "accuracy_score(y_test,y_predicted): " + str(accuracy_score(y_test,y_predicted)) )

    #print("clfDNN.evaluate(X_test_scaled,y_test)")
    #print( clfDNN.evaluate(X_test_scaled,y_test) )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

