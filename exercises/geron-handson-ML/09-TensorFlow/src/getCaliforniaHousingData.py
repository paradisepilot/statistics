
import os.path, pickle

def getCaliforniaHousingData(housingFILE):

    print("\ngetCaliforniaHousingData():")

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    if os.path.isfile(path = housingFILE) == False:
        print("downloading California housing data set from Internet ...")
        from sklearn.datasets import fetch_california_housing
        with open(file = housingFILE, mode = 'wb') as myFile:
            pickle.dump(obj = fetch_california_housing(), file = myFile)
    else:
        print("loading California housing data set from drive ...")

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    with open(file = housingFILE, mode = 'rb') as myFile:
        housing = pickle.load(myFile)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    housingData   = housing.data
    housingTarget = housing.target

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( housingData, housingTarget )

