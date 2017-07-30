
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
    plt.savefig(filename = outputFILE, bbox_inches='tight', pad_inches=0.2)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    outputFILE = 'plot-correlations.png'
    corrMatrix = inputDF.corr()
    attributes = ["median_house_value","median_income","total_rooms","housing_median_age"]
    myPlot = scatter_matrix(frame=inputDF[attributes], figsize=(12,8))
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
    plt.savefig(filename = outputFILE, bbox_inches='tight', pad_inches=0.2)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    outputFILE = 'plot-correlations-02.png'

    tempDF = inputDF.copy()

    tempDF[     "roomsPerHousehold"] = tempDF["total_rooms"]    / tempDF["households"]
    tempDF["populationPerHousehold"] = tempDF["population"]     / tempDF["households"]
    tempDF[       "bedroomsPerRoom"] = tempDF["total_bedrooms"] / tempDF["total_rooms"]

    corrMatrix = tempDF.corr()
    print('\ncorrMatrix["median_house_value"].sort_values(ascending=False)')
    print(   corrMatrix["median_house_value"].sort_values(ascending=False) )

    attributes = ["median_house_value","median_income","roomsPerHousehold","bedroomsPerRoom"]
    myPlot = scatter_matrix(frame=tempDF[attributes], figsize=(12,8))
    plt.savefig(filename = outputFILE, bbox_inches='tight', pad_inches=0.2)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( 0 )

