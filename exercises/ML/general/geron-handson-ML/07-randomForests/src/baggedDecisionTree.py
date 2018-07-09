
from sklearn.ensemble import BaggingClassifier
from sklearn.tree     import DecisionTreeClassifier
from sklearn.metrics  import accuracy_score

##############################
def baggedDecisionTree( X_train, y_train, X_test, y_test, nEstimators ):

    print("\n### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###")
    print("baggedDecisionTree()\n")

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    myBaggedDecisionTree = BaggingClassifier(
        base_estimator = DecisionTreeClassifier(),
        n_estimators   = nEstimators,
        # max_samples    = X_train.shape[0],
        bootstrap      = True,
        oob_score      = True,
        n_jobs         = -1 # use all available cores
        )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    myBaggedDecisionTree.fit(X_train,y_train)
    y_pred = myBaggedDecisionTree.predict(X_test)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print( "nEstimators: "      + str(nEstimators)                     )
    print( "out-of-bag score: " + str(myBaggedDecisionTree.oob_score_) )
    print( "accuracy score: "   + str(accuracy_score(y_test,y_pred))   )
    print( "out-of-bag decision function:" )
    print( str(myBaggedDecisionTree.oob_decision_function_) )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

##############################

