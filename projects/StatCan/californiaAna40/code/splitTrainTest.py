
import numpy as np
from sklearn.cross_validation import train_test_split, StratifiedShuffleSplit

###################################################
def splitTrainTest(inputDF,random_state):

    inputDF["income_category"] = np.ceil(inputDF["median_income"]/1.5)
    inputDF["income_category"].where( inputDF["income_category"] < 5.0 , 5.0, inplace = True )

    mySplit = StratifiedShuffleSplit(y = inputDF["income_category"], n_iter=1, test_size=0.2,random_state=19)
    for trainIndices, testIndices in mySplit:
        trainSet = inputDF.loc[trainIndices]
        testSet  = inputDF.loc[testIndices]

    print('\nincome category relative sizes (whole data set)')
    print(   inputDF["income_category"].value_counts() / len(inputDF) )

    for set in (trainSet,testSet):
        set.drop(["income_category"],axis=1,inplace=True)

    return( trainSet , testSet )

