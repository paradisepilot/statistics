
from sklearn.linear_model  import LinearRegression
from sklearn.preprocessing import PolynomialFeatures
import numpy as np
import matplotlib.pyplot as plt

def polynomialRegression(X,y):

    print("\n### ~~~~~~~~~~~~~~~~~~~~ ###")
    print("Polynomial Regression")

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    quadraticFeatures = PolynomialFeatures(degree=2, include_bias=False)
    X2 = quadraticFeatures.fit_transform(X)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    # random initialization
    linearModel = LinearRegression()
    linearModel.fit(X2,y)

    b0 = linearModel.intercept_[0]
    b1 = linearModel.coef_[0][0]
    b2 = linearModel.coef_[0][1]

    print("b0 = " + str(b0))
    print("b1 = " + str(b1))
    print("b2 = " + str(b2))

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    dummyX = np.arange(-3,3,0.1)

    outputFILE = 'plot-polynomialRegression.png'
    fig, ax = plt.subplots()
    fig.set_size_inches(h = 6.0, w = 10.0)
    ax.axis([-3,3,0,10.5])
    ax.scatter(X,y,color="black",s=10.0)
    ax.plot(dummyX, b0 + b1 * dummyX + b2*(dummyX**2), color='red', linewidth=1.5)
    plt.savefig(filename = outputFILE, bbox_inches='tight', pad_inches=0.2, dpi = 600)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

