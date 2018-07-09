
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics  import accuracy_score

##############################
def randomForest( irisData, X_train, y_train, X_test, y_test, nEstimators, maxLeafNodes ):

    print("\n### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###")
    print("randomForest()\n")

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    myRFClassifier = RandomForestClassifier(
        n_estimators   = nEstimators,
        max_leaf_nodes = maxLeafNodes,
        bootstrap      = True,
        oob_score      = True,
        n_jobs         = -1 # use all available cores
        )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    myRFClassifier.fit(X_train,y_train)
    y_pred = myRFClassifier.predict(X_test)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print( "nEstimators: "      + str(nEstimators)                     )
    print( "maxLeafNodes: "     + str(maxLeafNodes)                    )
    print( "accuracy score: "   + str(accuracy_score(y_test,y_pred))   )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    myRFClassifier.fit(irisData.data,irisData.target)

    print( "\nFeature importances:" )
    for name, score in zip(irisData.feature_names,myRFClassifier.feature_importances_):
        print(name, score)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

##############################

