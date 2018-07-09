
import numpy as np

def getDataLinear(nobs,seed):

    print("\n### ~~~~~~~~~~~~~~~~~~~~ ###")
    print("Generate linear synthetic data")

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    np.random.seed(seed=seed)
    X = 2 * np.random.rand(nobs,1)
    y = 4 + 3 * X + np.random.randn(nobs,1)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( X, y )

def getDataQuadratic(nobs,seed):

    print("\n### ~~~~~~~~~~~~~~~~~~~~ ###")
    print("Generate quadratic synthetic data")

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    np.random.seed(seed=seed)
    X = 6 * np.random.rand(nobs,1) - 3
    y = (0.5 * X**2) + X + 2 + np.random.randn(nobs,1)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( X, y )

