
from sklearn.ensemble     import RandomForestClassifier, VotingClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.svm          import SVC
from sklearn.metrics      import accuracy_score

##############################
def votingClassifier( X_train, y_train, X_test, y_test ):

    print("\n### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###")
    print("votingClassifier()\n")

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    clsLG = LogisticRegression()
    clsRF = RandomForestClassifier()
    clsSV = SVC()

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    clsVT = VotingClassifier(
        estimators = [
            ('logistic',     clsLG),
            ('random forest',clsRF),
            ('SVC',          clsSV)
            ],
        voting = "hard"
        )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    for cls in (clsLG, clsRF, clsSV, clsVT):
        cls.fit(X_train,y_train)
        y_pred = cls.predict(X_test)
        print( cls.__class__.__name__, ": ", accuracy_score(y_test,y_pred) )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

##############################

