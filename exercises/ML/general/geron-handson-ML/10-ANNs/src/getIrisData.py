
import os.path, pickle
import numpy as np

##############################
def getIrisData( irisFILE ):

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    if os.path.isfile(path = irisFILE) == False :
        print("downloading the Iris data set from Internet ...")
        from sklearn.datasets import load_iris
        with open(file = irisFILE, mode = 'wb') as myFile:
            pickle.dump(obj = load_iris(), file = myFile)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    with open(file = irisFILE, mode = 'rb') as myFile:
        irisData = pickle.load(myFile)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( irisData )

##############################
def examineIrisData( irisData ):

    print("\n### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###")
    print( "examineIrisData()" )
    print( "\ntype(irisData): " + str(type(irisData)) )
    print( "\ndir(irisData): "  + str(dir(irisData )) )

    print( "\nirisData.feature_names: " + str(irisData.feature_names) )
    print( "type(irisData.data): "      + str(type(irisData.data   )) )
    print( "irisData.data.shape: "      + str(irisData.data.shape   ) )

    print( "\nirisData.target_names: " + str(irisData.target_names) )
    print( "type(irisData.target): "   + str(type(irisData.target)) )
    print( "irisData.target.shape: "   + str(irisData.target.shape) )

    print( "\nirisData.DESCR:" )
    print( str(irisData.DESCR) )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print("\nexiting: examineIrisData()")
    print("### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###")
    return( None )

