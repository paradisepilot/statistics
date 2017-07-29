
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
    outputFILE = 'histograms.png'
    fig, ax = plt.subplots(nrows = 3, ncols = 3, figsize = (24,12))
    inputDF.hist(ax=ax,bins=50)
    fig.tight_layout()
    fig.savefig(outputFILE)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( 0 )

