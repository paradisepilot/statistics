
'''
dummy comment
'''

from collections import deque
from Ex118       import createDeck, shuffleDeck

def deal( deck, nHands, nCards ):

    if nHands * nCards > len(deck):
        remaining_deck = deck
        hands          = []

    else:
        remaining_deck = deque(deck)
        hands = []
        for h in range(0,nHands):
            hands.append([])

        for i in range(0,nCards):
            for h in range(0,nHands):
                hands[h].append(remaining_deck.popleft())

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    output_dictionary = {
        'deck'  : list(remaining_deck),
        'hands' : hands
        }

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( output_dictionary  )

def ex119( nHands, nCards ):

    print("\n### ~~~~~ Exercise 119 ~~~~~~~~");

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    new_deck = createDeck()
    print( "\nnewly created deck:" )
    print( str(new_deck) )

    shuffled_deck = shuffleDeck(new_deck)
    print( "\nshuffled deck:" )
    print( str(shuffled_deck) )

    results = deal( deck = shuffled_deck, nHands = nHands, nCards = nCards )

    print("\nstr(results['deck']):")
    print(   str(results['deck'])    )

    print("\nstr(results['hands']):")
    if len(results['hands']) == 0:
        print( str(results['hands']) )
    else:
        for i in range(0,len(results['hands'])):
            print(str( results['hands'][i] ))

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

