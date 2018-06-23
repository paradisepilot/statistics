
'''
dummy comment
'''

import numpy

def average( v ):

    if len(v) > 0:
        output = sum(v) / len(v)
    else:
        output = numpy.nan

    return( output )

def ex112( list_of_numbers ):

    print("\n### ~~~~~ Exercise 112 ~~~~~~~~");

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print( "\nlist_of_numbers: " + str(list_of_numbers) )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    my_average = average(list_of_numbers)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    below_average = []
    equal_average = []
    above_average = []
    for x in list_of_numbers:
        if x < my_average:
            below_average.append(x)
        elif x > my_average:
            above_average.append(x)
        else:
            equal_average.append(x)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    below_average.sort()
    equal_average.sort()
    above_average.sort()

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print( "average: " + str(my_average) )
    print( "below average: " + str(below_average) )
    print( "equal average: " + str(equal_average) )
    print( "above average: " + str(above_average) )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

