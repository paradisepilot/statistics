
import pandas as pd
import matplotlib
import matplotlib.pyplot as plt

def visualizeData(data,index,outputFILE):

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    if isinstance(data,pd.DataFrame):
        ncol = data.shape[1]
        retainedColumns = data.columns.tolist()
        retainedColumns.remove('index')
        retainedColumns.remove('label')
        myDigit = data.loc[index,retainedColumns]
        myDigit = myDigit.as_matrix()
    else:
        myDigit = data[index]

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    myDigitImage = myDigit.reshape(28,28)

    # outputFILE = 'myDigit.png'
    plt.imshow(X = myDigitImage, cmap = matplotlib.cm.binary, interpolation="nearest")
    plt.axis("off")
    plt.savefig(filename = outputFILE, bbox_inches='tight', pad_inches=0.2)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

