
'''
dummy comment
'''

import os
from random import sample

def createWordFile( outputFILE ):
    tempwords = [ 'she', 'sells', 'sea', 'shells', 'by', 'the', 'seashore' ]
    with open( file = outputFILE , mode = 'w') as outF:
        for tempword in tempwords:
            print( tempword , file = outF )
    return( None )

def isSufficient( wordpair ):
    w0 = wordpair[0]
    w1 = wordpair[1]

    if 2 < len(w0) and 2 < len(w1):
        if 7 < len(w0) + len(w1) and len(w0) + len(w1) < 11:
            return( True )

    return( False )

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

    wordpair = ['','']
    while not isSufficient( wordpair = wordpair ):
        wordpair = sample(population = list_of_words, k = 2)
        print( wordpair )

    w0 = wordpair[0]
    w1 = wordpair[1]
    w0 = ''.join([w0[0].upper(),w0[1:].lower()])
    w1 = ''.join([w1[0].upper(),w1[1:].lower()])

    password = ''.join( [ w0, w1 ] )
    print( "password: " + password )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

