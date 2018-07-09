
from sklearn.linear_model  import ElasticNet
from sklearn.preprocessing import PolynomialFeatures, StandardScaler
import numpy as np
import matplotlib.pyplot as plt

def elasticNet(X,y):

    print("\n### ~~~~~~~~~~~~~~~~~~~~ ###")
    print("Lasso Regression")

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    myDegree = 40
    polynomialFeatures = PolynomialFeatures(degree=myDegree, include_bias=False)
    Xp = polynomialFeatures.fit_transform(X)

    myScaler = StandardScaler()
    scaled_Xp = myScaler.fit_transform(Xp)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    elasticNet = ElasticNet(alpha=1e-7,l1_ratio=0.5)
    elasticNet.fit(scaled_Xp,y)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    dummyX = np.arange(0,2,0.01)
    dummyX = dummyX.reshape((dummyX.shape[0],1))
    dummyXp = polynomialFeatures.fit_transform(dummyX)
    scaled_dummyXp = myScaler.transform(dummyXp)
    dummyY = elasticNet.predict(scaled_dummyXp)

    outputFILE = 'plot-elasticNet.png'
    fig, ax = plt.subplots()
    fig.set_size_inches(h = 6.0, w = 10.0)
    ax.axis([0,2,0,15])
    ax.scatter(X,y,color="black",s=10.0)
    ax.plot(dummyX, dummyY, color='red', linewidth=1.5)
    plt.savefig(filename = outputFILE, bbox_inches='tight', pad_inches=0.2, dpi = 600)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

