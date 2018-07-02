
'''
dummy comment
'''

from random import sample

def simulateCoinFlips( stateSpace = ['H','T'] , requiredLength = 3 ):

    coinFlips = []
    for i in range(0,requiredLength):
        coinFlips.append( sample(population=stateSpace,k=1)[0] )

    while len(set(coinFlips[len(coinFlips)-requiredLength:])) > 1:
        coinFlips.append( sample(population=stateSpace,k=1)[0] )

    output = {
        'required_length' : requiredLength,
        'num_of_flips'    : len(coinFlips),
        'coin_flips'      : coinFlips
        }

    return( output )

def ex080():

    print("\n### ~~~~~ Exercise 080 ~~~~~~~~");

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    for i in range(0,10):
        results = simulateCoinFlips( stateSpace = ['A','B','C'], requiredLength = 3 )
        print( results )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

