
import numpy as np
import matplotlib.pyplot as plt

def stochasticGradientDescent(X,y,theta0):

    print("\n### ~~~~~~~~~~~~~~~~~~~~ ###")
    print("Stochastic Gradient Descent")

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    nEpochs = 50
    t0, t1 = 5, 50 # learning schedule hyperparameters

    def learningSchedule(t):
        return( t0 / (t + t1) )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    nobs  = X.shape[0]
    X1 = np.c_[np.ones((nobs,1)),X]

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    # random initialization
    theta      = np.zeros((2,nEpochs))
    theta[:,0] = theta0

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    for epoch in range(nEpochs-1):
        tempTheta = theta[:,epoch].reshape((2,1))
        for i in range(nobs):
            randomIndex = np.random.randint(nobs)
            xi          = X1[randomIndex:randomIndex+1]
            yi          =  y[randomIndex:randomIndex+1]
            gradient    = 2 * xi.T.dot(np.matmul(xi,tempTheta) - yi)
            eta         = learningSchedule(epoch * nobs + i)
            tempTheta   = tempTheta - eta * gradient
        theta[:,epoch+1] = tempTheta.reshape((2,))

    print("theta[:,nEpochs-1]:")
    print( theta[:,nEpochs-1]  )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    outputFILE = 'plot-stochasticGradientDescent.png'
    fig, ax = plt.subplots()
    ax.axis([0,2,0,15])
    ax.scatter(X,y)
    ax.plot(X, theta[0,nEpochs-1] + theta[1,nEpochs-1] * X, color='red', linewidth=1)
    for i in range(0,nEpochs,5):
        ax.plot(X, theta[0,i] + theta[1,i] * X, color='gray', linewidth=0.5, linestyle='dashed')
    plt.savefig(filename = outputFILE, bbox_inches='tight', pad_inches=0.2, dpi = 600)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    outputFILE = 'plot-stochasticGradientDescent-theta.png'
    fig, ax = plt.subplots()
    fig.set_size_inches(6.0,6.0)
    ax.axis([-1,5,-1,5])
    ax.plot( theta[0,:], theta[1,:], linewidth=1.0 )
    plt.savefig(filename = outputFILE, bbox_inches='tight', pad_inches=0.2, dpi = 600)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

