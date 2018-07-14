
'''
dummy comment
'''

import os
from random import sample

def createWordFile( outputFILE ):

    tempwords = [
        'she', 'sells', 'sea', 'shells', 'by', 'the', 'seashore'
        ]

    with open( file = outputFILE , mode = 'w') as outF:
        for tempword in tempwords:
            print( tempword , file = outF )

    return( None )

def ex151():

    print("\n### ~~~~~ Exercise 151 ~~~~~~~~");

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    file_list_of_words = 'list-of-words.txt'
    createWordFile( outputFILE = file_list_of_words )

    list_of_words = []
    with open( file = file_list_of_words , mode = 'r' ) as inF:
        for i, tempLine in enumerate(inF):
            tempLine = tempLine.rstrip()
            list_of_words.append(tempLine)

    password = ''
    while len(password) < 8 or 10 < len(password):
        password = ''.join( sample(population = list_of_words, k = 2) )
        print( password )

    print( "password: " + password )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

