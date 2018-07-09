
'''
dummy comment
'''

from random import sample

def createDeck():

    suits  = ['S','H','D','C']
    values = ['2','3','4','5','6','7','8','9','T','J','Q','A']

    deck = []
    for suit in suits:
        for value in values:
            deck.append( suit + value )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( deck )

def shuffleDeck( v ):
    return( sample(population = v, k=len(v)) )

def ex118():

    print("\n### ~~~~~ Exercise 118 ~~~~~~~~");

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    new_deck = createDeck()
    print( "\nnewly created deck:" )
    print( str(new_deck) )

    shuffled_deck = shuffleDeck(new_deck)
    print( "\nshuffled deck:" )
    print( str(shuffled_deck) )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

