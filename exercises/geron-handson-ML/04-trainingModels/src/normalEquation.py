
import numpy as np
import matplotlib.pyplot as plt

def normalEquation(X,y):

    print("\n### ~~~~~~~~~~~~~~~~~~~~ ###")
    print("The Normal Equation")

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    X1 = np.c_[np.ones((X.shape[0],1)),X]
    theta_best = np.linalg.inv(X1.T.dot(X1)).dot(X1.T).dot(y)
    print("theta_best:")
    print( theta_best )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    b0 = theta_best[0][0]
    b1 = theta_best[1][0]

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    outputFILE = 'normal-equation.png'
    # myPlot = plt.scatter(X,y)
    fig, ax = plt.subplots()
    ax.scatter(X,y)
    ax.plot(X, b0 + b1 * X, color='red')
    ax.axis([0,2,0,15])
    plt.savefig(filename = outputFILE, bbox_inches='tight', pad_inches=0.2)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

