
import numpy as np

def getData(nrow,seed):

    print("\n### ~~~~~~~~~~~~~~~~~~~~ ###")
    print("Generate synthetic data")

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    np.random.seed(seed=seed)
    X = 2 * np.random.rand(nrow,1)
    y = 4 + 3 * X + np.random.randn(nrow,1)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( X, y )

