
'''
dummy comment
'''

def ex115( list_of_points ):

    print("\n### ~~~~~ Exercise 115 ~~~~~~~~");

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print( "list of points: " + str(list_of_points) )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    n = len(list_of_points)

    x = []
    y = []
    for i in range(0,n):
        print( str(i) + ": " + str(list_of_points[i]) )
        x.append( list_of_points[i][0] )
        y.append( list_of_points[i][1] )

    print( "x: " + str(x) )
    print( "y: " + str(y) )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    sumXY = 0
    sumX2 = 0
    for i in range(0,n):
        sumXY = sumXY + x[i] * y[i]
        sumX2 = sumX2 + x[i] * x[i]

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    slope     = ( sumXY - sum(x)*sum(y)/n ) / ( sumX2 - (sum(x)**2)/n )
    intercept = (sum(y)/n) - slope * (sum(x)/n)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print( "line of best fit: " + str(slope) + " * x + " + str(intercept) )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

