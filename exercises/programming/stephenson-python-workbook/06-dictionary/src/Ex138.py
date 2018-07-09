
'''
dummy comment
'''

from random import sample
import re

def makeBingoCard():
    dict_bingo_card = {
        'B' : sample( population = list(range( 1,16)) , k = 5 ),
        'I' : sample( population = list(range(16,31)) , k = 5 ),
        'N' : sample( population = list(range(31,46)) , k = 5 ),
        'G' : sample( population = list(range(46,61)) , k = 5 ),
        'O' : sample( population = list(range(61,76)) , k = 5 )
        }
    return( dict_bingo_card )

def showBingoCard( bingoCard ):

    format_string = "%2s  %2s  %2s  %2s  %2s  "

    print( format_string % ( 'B', 'I', 'N', 'G', 'O') )
    print( format_string % ('==','==','==','==','==') )
    for i in range(0,len(bingoCard['B'])):
        print( format_string % (bingoCard['B'][i],bingoCard['I'][i],bingoCard['N'][i],bingoCard['G'][i],bingoCard['O'][i]) )

    return( None )

def ex138():

    print("\n### ~~~~~ Exercise 138 ~~~~~~~~");

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    myBingoCard = makeBingoCard()
    showBingoCard( bingoCard = myBingoCard )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

