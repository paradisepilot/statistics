
from sklearn.ensemble import AdaBoostClassifier
from sklearn.tree     import DecisionTreeClassifier
from sklearn.metrics  import accuracy_score

##############################
def adaBoost( X_train, y_train, X_test, y_test, nEstimators, learningRate ):

    print("\n### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###")
    print("adaBoost()\n")

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    myAdaBoostClassifier = AdaBoostClassifier(
        base_estimator = DecisionTreeClassifier(),
        algorithm      = "SAMME.R",
        n_estimators   = nEstimators,
        learning_rate  = learningRate
        )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    myAdaBoostClassifier.fit(X_train,y_train)
    y_pred = myAdaBoostClassifier.predict(X_test)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print( "nEstimators: "    + str(nEstimators)                   )
    print( "learningRate: "   + str(learningRate)                  )
    print( "accuracy score: " + str(accuracy_score(y_test,y_pred)) )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

##############################

