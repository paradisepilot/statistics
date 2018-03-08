
import numpy as np
# from sklearn.model_selection import train_test_split
# from sklearn.model_selection import StratifiedShuffleSplit

import importlib
from   importlib.util import find_spec
ms_spec = importlib.util.find_spec(name="sklearn.model_selection")
if ms_spec is not None:
    from sklearn.model_selection import train_test_split
    from sklearn.model_selection import StratifiedShuffleSplit
else:
    from sklearn.cross_validation import train_test_split

###################################################
def splitTrainTest(inputDF,random_state):

    ms_spec = importlib.util.find_spec(name="sklearn.model_selection")
    if ms_spec is None:
        trainSet, testSet = train_test_split(inputDF, test_size=0.2, random_state=random_state)
    else:
        inputDF["income_category"] = np.ceil(inputDF["median_income"]/1.5)
        inputDF["income_category"].where( inputDF["income_category"] < 5.0 , 5.0, inplace = True )

        split = StratifiedShuffleSplit(n_splits=1, test_size=0.2,random_state=19)
        for trainIndices, testIndices in split.split(inputDF,inputDF["income_category"]):
            trainSet = inputDF.loc[trainIndices]
            testSet  = inputDF.loc[testIndices]

        print('\nincome category relative sizes (whole data set)')
        print(   inputDF["income_category"].value_counts() / len(inputDF) )

        for set in (trainSet,testSet):
            set.drop(["income_category"],axis=1,inplace=True)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( trainSet , testSet )

