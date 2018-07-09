
'''
dummy comment
'''

import numpy

def reformatList( v ):

    output = v[0]
    if len(v) > 1:
        for i in range(1,len(v)-1):
            output = output + ", " + v[i]
        output = output + " and " + v[len(v)-1]

    return( output )

def ex113( list_of_strings ):

    print("\n### ~~~~~ Exercise 113 ~~~~~~~~");

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print( "\nlist_of_strings: " + str(list_of_strings) )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    reformatted_string = reformatList(list_of_strings)

    print( "reformatted string: " + reformatted_string )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

