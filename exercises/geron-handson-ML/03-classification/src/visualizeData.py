
import matplotlib
import matplotlib.pyplot as plt

def visualizeData(data):

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print('\ndata')
    print(   data )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    myDigit = data[36000]
    myDigitImage = myDigit.reshape(28,28)

    outputFILE = 'myDigit.png'
    plt.imshow(X = myDigitImage, cmap = matplotlib.cm.binary, interpolation="nearest")
    plt.axis("off")
    plt.savefig(filename = outputFILE, bbox_inches='tight', pad_inches=0.2)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

