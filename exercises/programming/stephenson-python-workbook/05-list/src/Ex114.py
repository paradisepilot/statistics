
'''
dummy comment
'''

import numpy

def ex114():

    print("\n### ~~~~~ Exercise 114 ~~~~~~~~");

    drawn_numbers = numpy.random.choice(a = 49, size=6, replace=False, p=None).tolist()
    drawn_numbers.sort()

    print( "drawn numbers: " + str(drawn_numbers) )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

