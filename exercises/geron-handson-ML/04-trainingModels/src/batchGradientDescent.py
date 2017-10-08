
import numpy as np
import matplotlib.pyplot as plt

def batchGradientDescent(X,y,theta0):

    print("\n### ~~~~~~~~~~~~~~~~~~~~ ###")
    print("Batch Gradient Descent")

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    eta   = 0.1
    nIter = 1000
    nobs  = X.shape[0]

    X1 = np.c_[np.ones((nobs,1)),X]

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    # random initialization
    theta      = np.zeros((2,nIter))
    theta[:,0] = theta0

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    for i in range(nIter-1):
        tempTheta    = theta[:,i].reshape((2,1))
        gradient     = (2/nobs) * X1.T.dot(np.matmul(X1,tempTheta) - y)
        theta[:,i+1] = (tempTheta - eta * gradient).reshape((2,))

    print("theta[:,nIter-1]:")
    print( theta[:,nIter-1]  )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    outputFILE = 'plot-batchGradientDescent.png'
    fig, ax = plt.subplots()
    ax.axis([0,2,0,15])
    ax.scatter(X,y)
    ax.plot(X, theta[0,nIter-1] + theta[1,nIter-1] * X, color='red', linewidth=1)
    for i in range(0,200,20):
        ax.plot(X, theta[0,i] + theta[1,i] * X, color='gray', linewidth=0.5, linestyle='dashed')
    plt.savefig(filename = outputFILE, bbox_inches='tight', pad_inches=0.2, dpi = 600)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    outputFILE = 'plot-batchGradientDescent-theta.png'
    fig, ax = plt.subplots()
    fig.set_size_inches(6.0,6.0)
    ax.axis([-1,5,-1,5])
    ax.plot( theta[0,:], theta[1,:], linewidth=1.0 )
    plt.savefig(filename = outputFILE, bbox_inches='tight', pad_inches=0.2, dpi = 600)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

