
import matplotlib.pyplot as plt
from pandas.plotting import scatter_matrix

def visualizeData(inputDF):

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    outputFILE = 'plot-scatter.png'
    myPlot = inputDF.plot(
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
    # plt.tight_layout()
    plt.savefig(filename = outputFILE, bbox_inches='tight', pad_inches=0.2)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    outputFILE = 'plot-correlations.png'
    corrMatrix = inputDF.corr()
    attributes = ["median_house_value","median_income","total_rooms","housing_median_age"]
    myPlot = scatter_matrix(frame=inputDF[attributes], figsize=(12,8))
    # plt.tight_layout()
    plt.savefig(filename = outputFILE, bbox_inches='tight', pad_inches=0.2)

    print('\ncorrMatrix["median_house_value"].sort_values(ascending=False)')
    print(   corrMatrix["median_house_value"].sort_values(ascending=False) )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    outputFILE = 'plot-medianIncome.png'
    myPlot = inputDF.plot(
        kind    = 'scatter',
        x       = "median_income",
        y       = "median_house_value",
        alpha   = 0.1,
        figsize = (12,8)
        )
    # plt.tight_layout()
    plt.savefig(filename = outputFILE, bbox_inches='tight', pad_inches=0.2)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    outputFILE = 'plot-correlations-02.png'

    inputDF[     "roomsPerHousehold"] = inputDF["total_rooms"]    / inputDF["households"]
    inputDF[  "bedroomsPerHousehold"] = inputDF["total_bedrooms"] / inputDF["households"]
    inputDF["populationPerHousehold"] = inputDF["population"]     / inputDF["households"]

    corrMatrix = inputDF.corr()
    attributes = ["median_house_value","median_income","roomsPerHousehold","bedroomsPerHousehold"]
    myPlot = scatter_matrix(frame=inputDF[attributes], figsize=(12,8))
    # plt.tight_layout()
    plt.savefig(filename = outputFILE, bbox_inches='tight', pad_inches=0.2)

    print('\ncorrMatrix["median_house_value"].sort_values(ascending=False)')
    print(   corrMatrix["median_house_value"].sort_values(ascending=False) )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( 0 )

