
import matplotlib.pyplot as plt

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
    outputFILE = 'plot-histograms.png'
    myHistogram = inputDF.hist(bins = 50, figsize = (12,6))
    plt.savefig(filename = outputFILE, bbox_inches='tight', pad_inches=0.2)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( 0 )

