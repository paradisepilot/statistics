
import numpy as np
import matplotlib.pyplot as plt

from sklearn.linear_model    import LinearRegression
from sklearn.metrics         import mean_squared_error
from sklearn.model_selection import train_test_split
from sklearn.pipeline        import Pipeline
from sklearn.preprocessing   import PolynomialFeatures

def plotLearningCurves(model,X,y,outputFILE):
    X_train, X_valid, y_train, y_valid = train_test_split(X,y,test_size=0.2)
    train_errors, valid_errors = [], []
    for m in range(1,len(X_train)):
        model.fit(X_train[:m],y_train[:m])
        y_train_predictions = model.predict(X_train[:m])
        y_valid_predictions = model.predict(X_valid    )
        train_errors.append(mean_squared_error(y_train_predictions,y_train[:m]))
        valid_errors.append(mean_squared_error(y_valid_predictions,y_valid    ))
    fig, ax = plt.subplots()
    fig.set_size_inches(h = 6.0, w = 10.0)
    ax.axis([0,80,0,3])
    ax.plot(np.sqrt(train_errors), "r-+", linewidth=2, label="train")
    ax.plot(np.sqrt(valid_errors), "b-",  linewidth=3, label="valid")
    plt.savefig(filename = outputFILE, bbox_inches='tight', pad_inches=0.2, dpi = 600)

def learningCurves(X,y):

    print("\n### ~~~~~~~~~~~~~~~~~~~~ ###")
    print("Learning Curves")

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    linearRegression = LinearRegression()
    plotLearningCurves(
        model = linearRegression,
        X     = X,
        y     = y,
        outputFILE = "plot-learningCurves-linearRegression.png"
        )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    myDegree = 10
    polynomialRegression = Pipeline((
        ("polynomialFeatures",PolynomialFeatures(degree=myDegree, include_bias=False)),
        ("SGDRegression",     LinearRegression())
        ))
    plotLearningCurves(
        model = polynomialRegression,
        X     = X,
        y     = y,
        outputFILE = "plot-learningCurves-polynomialRegression.png"
        )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

