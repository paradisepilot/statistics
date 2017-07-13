import matplotlib.pyplot as plt
import numpy as np
from   matplotlib.colors import ListedColormap

def plotDecisionRegions(X, y, classifier, outFILE, title, xlabel, ylabel, test_idx = None, resolution = 0.02):

    markers = ('s','x','o','^','v')
    colors  = ('red','blue','lightgreen','gray','cyan')

    cmap = ListedColormap(colors[:len(np.unique(y))])

    x1_min = X[:,0].min() - 1
    x1_max = X[:,0].max() + 1
    x2_min = X[:,1].min() - 1
    x2_max = X[:,1].max() + 1

    xx1, xx2 = np.meshgrid(
        np.arange(x1_min,x1_max,resolution),
        np.arange(x2_min,x2_max,resolution),
        )

    Z = classifier.predict(np.array([xx1.ravel(),xx2.ravel()]).T)
    Z = Z.reshape(xx1.shape)

    fig, ax = plt.subplots(1, 1)
    print('type(fig)')
    print( type(fig) )
    ax.contourf(xx1,xx2,Z,alpha=0.4,cmap=cmap)
    ax.set_xlim(xx1.min(),xx1.max())
    ax.set_ylim(xx2.min(),xx2.max())
    for idx, cl in enumerate(np.unique(y)):
        ax.scatter(
            x      = X[y == cl, 0], 
            y      = X[y == cl, 1], 
            alpha  = 0.8,
            c      = cmap(idx),
            marker = markers[idx],
            label  = cl
            )

    if test_idx:
        X_test, y_test = X[test_idx,:], y[test_idx]
        ax.scatter(
            x          = X_test[:,0],
            y          = X_test[:,1],
            c          = '',
            edgecolors = 'black',
            alpha      = 1.0,
            linewidth  = 1,
            marker     = 'o',
            s          = 55,
            label      = 'test set'
            )

    ax.set_title(title)
    ax.set_xlabel(xlabel)
    ax.set_ylabel(ylabel)
    ax.legend(loc = 'upper left')

    return( fig.savefig(outFILE) )

