
from sklearn.linear_model  import LinearRegression
from sklearn.preprocessing import PolynomialFeatures
import numpy as np
import matplotlib.pyplot as plt

def polynomialRegression(X,y):

    print("\n### ~~~~~~~~~~~~~~~~~~~~ ###")
    print("Polynomial Regression")

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    myDegree = 3
    polynomialFeatures = PolynomialFeatures(degree=myDegree, include_bias=False)
    Xn = polynomialFeatures.fit_transform(X)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    # random initialization
    linearModel = LinearRegression()
    linearModel.fit(Xn,y)

    betaHat = np.concatenate((linearModel.intercept_.reshape((1,1)),linearModel.coef_),axis=1)
    betaHat = betaHat.T
    print("betaHat:")
    print( betaHat  )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    dummyX  = np.arange(-3,3,0.1)
    dummyX  = dummyX.reshape((dummyX.shape[0],1))

    polynomialFeatures = PolynomialFeatures(degree=myDegree, include_bias=True)
    dummyM  = polynomialFeatures.fit_transform(dummyX)

    dummyY  = np.matmul(dummyM,betaHat)

    outputFILE = 'plot-polynomialRegression.png'
    fig, ax = plt.subplots()
    fig.set_size_inches(h = 6.0, w = 10.0)
    ax.axis([-3,3,0,10.5])
    ax.scatter(X,y,color="black",s=10.0)
    ax.plot(dummyX, dummyY, color='red', linewidth=1.5)
    plt.savefig(filename = outputFILE, bbox_inches='tight', pad_inches=0.2, dpi = 600)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

