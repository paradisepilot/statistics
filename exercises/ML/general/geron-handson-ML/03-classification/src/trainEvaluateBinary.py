
import numpy as np
import matplotlib.pyplot as plt
from NeverFiveClassifier     import NeverFiveClassifier
from sklearn.ensemble        import RandomForestClassifier
from sklearn.metrics         import confusion_matrix
from sklearn.metrics         import precision_recall_curve, roc_curve
from sklearn.metrics         import precision_score, recall_score, f1_score, roc_auc_score
from sklearn.model_selection import cross_val_score, cross_val_predict

###################################################
def plotROC(modelName,fpr,tpr):
    outputFILE = "ROC-" + modelName + ".png"
    plt.figure(figsize=(8,8))
    plt.plot(fpr, tpr, label=None)
    plt.plot([0,1],[0,1],'k--')
    plt.axis([0,1,0,1])
    plt.xlim([-0.1,1.1])
    plt.ylim([-0.1,1.1])
    plt.xlabel("False Positive Rate")
    plt.ylabel( "True Positive Rate")
    plt.savefig(filename = outputFILE, bbox_inches='tight', pad_inches=0.2)
    return( None )

def plotPrecisionRecallCurves(modelName,precision,recall,threshold):
    outputFILE = "precision-recall-vs-thresholds-" + modelName + ".png"
    plt.figure(figsize=(8,8))
    plt.plot(threshold, precision[:-1], "b--", label='Precision')
    plt.plot(threshold,    recall[:-1], "g-",  label='Recall'   )
    plt.xlabel("Threshold")
    plt.legend(loc = 'upper left')
    plt.ylim([0,1])
    plt.savefig(filename = outputFILE, bbox_inches='tight', pad_inches=0.2)
    return( None )

def trainEvaluateBinary(trainData, testData, myModel, modelName):

    trainData['isFive'] = (trainData.loc[:,'label'] == 5)
    featureColumns = trainData.columns.tolist()
    featureColumns.remove('index')
    featureColumns.remove('label')
    featureColumns.remove('isFive')

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    myModel.fit(
        X = trainData.loc[:,featureColumns],
        y = trainData.loc[:,'isFive']
        )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    nFold = 10
    myCVAccuracy = cross_val_score(
        estimator = myModel,
        X         = trainData.loc[:,featureColumns],
        y         = trainData.loc[:,"isFive"],
        scoring   = "accuracy",
        cv        = nFold
        )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    myPredictions = cross_val_predict(
        estimator = myModel,
        X         = trainData.loc[:,featureColumns],
        y         = trainData.loc[:,"isFive"],
        cv        = nFold
        )

    myConfusionMatrix = confusion_matrix(
        y_true = trainData.loc[:,"isFive"],
        y_pred = myPredictions
        )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    if (isinstance(myModel,NeverFiveClassifier)):
        myPrecision = None
        myRecall    = None
        myF1        = None
        myROCAUC    = None
    else:
        myPrecision = precision_score(
            y_true = trainData.loc[:,"isFive"],
            y_pred = myPredictions
            )

        myRecall = recall_score(
            y_true = trainData.loc[:,"isFive"],
            y_pred = myPredictions
            )

        myF1 = f1_score(
            y_true = trainData.loc[:,"isFive"],
            y_pred = myPredictions
            )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    if (not isinstance(myModel,NeverFiveClassifier)):

        # construct precision/recall vs threshold curves
        precisionCurve, recallCurve, thresholds = precision_recall_curve(
            y_true      = trainData.loc[:,"isFive"],
            probas_pred = myPredictions
            )

        plotPrecisionRecallCurves(
            modelName = modelName,
            precision = precisionCurve,
            recall    = recallCurve,
            threshold = thresholds
            )

        # construct ROC curve
        if (isinstance(myModel,RandomForestClassifier)):
            myScores = cross_val_predict(
                estimator = myModel,
                X         = trainData.loc[:,featureColumns],
                y         = trainData.loc[:,"isFive"],
                cv        = nFold,
                method    = 'predict_proba'
                )
            myScores = myScores[:,1]
        else:
            myMethod = 'decision_function'
            myScores = cross_val_predict(
                estimator = myModel,
                X         = trainData.loc[:,featureColumns],
                y         = trainData.loc[:,"isFive"],
                cv        = nFold,
                method    = 'decision_function'
                )

        myROCAUC = roc_auc_score(
            y_true  = trainData.loc[:,"isFive"],
            y_score = myScores
            )

        fpr, tpr, thresholds = roc_curve(
            y_true  = trainData.loc[:,"isFive"],
            y_score = myScores
            )

        plotROC(
            modelName = modelName,
            fpr       = fpr,
            tpr       = tpr
            )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print("\n### ~~~~~~~~~~~~~~~~~~~~ ###")
    print('type(myModel)')
    print( type(myModel) )

    print("\nCV Accuracy (" + str(nFold) + "-fold):")
    print(myCVAccuracy)

    print("\nConfusion Matrix:")
    print(myConfusionMatrix)

    print("\nPrecision:")
    print(myPrecision)

    print("\nRecall:")
    print(myRecall)

    print("\nF1 Score:")
    print(myF1)

    print("\nROC AUC Socre:")
    print(myROCAUC)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

