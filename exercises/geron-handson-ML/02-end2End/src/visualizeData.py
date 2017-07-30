
import matplotlib.pyplot as plt
from pandas.plotting import scatter_matrix

def visualizeData(inputDF):

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    outputFILE = 'plot-scatter.png'
    myGeoPlot = inputDF.plot(
        label    = 'population',
        kind     = 'scatter',
        x        = 'longitude',
        y        = 'latitude',
        s        = inputDF["population"] / 100,
        c        = 'median_house_value',
        cmap     = plt.get_cmap("jet"),
        colorbar = True,
        alpha    = 0.1
        )
    plt.tight_layout()
    plt.savefig(outputFILE)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    outputFILE = 'plot-correlations.png'

    corrMatrix = inputDF.corr()
    attributes = ["median_house_value","median_income","total_rooms","housing_median_age"]
    myScatterPlot = scatter_matrix(frame=inputDF[attributes], figsize=(12,8))

    plt.tight_layout()
    plt.savefig(outputFILE)

    print('\ncorrMatrix["median_house_value"].sort_values(ascending=False)')
    print(   corrMatrix["median_house_value"].sort_values(ascending=False) )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( 0 )

