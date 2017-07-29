
import matplotlib.pyplot as plt
#import numpy as np
#from   matplotlib.colors import ListedColormap

def examineData(inputDF):

    print('\ninputDF.info()')
    print(   inputDF.info() )

    print('\ninputDF.head()')
    print(   inputDF.head() )

    print('\ninputDF["ocean_proximity"].value_counts()')
    print(   inputDF["ocean_proximity"].value_counts() )

    print('\ninputDF.describe()')
    print(   inputDF.describe() )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    outputFILE = 'histograms.png'
    fig, ax = plt.subplots(nrows = 3, ncols = 3, figsize = (8,4))
    inputDF.hist(ax=ax,bins=50)
    fig.savefig(outputFILE)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( 0 )

