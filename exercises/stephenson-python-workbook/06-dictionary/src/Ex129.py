
'''
dummy comment
'''

from random import sample

def sumTwoDieRolls():
    roll1 = sample(population = [1,2,3,4,5,6], k = 1)[0]
    roll2 = sample(population = [1,2,3,4,5,6], k = 1)[0]
    return( roll1 + roll2 )

def ex129():

    print("\n### ~~~~~ Exercise 129 ~~~~~~~~");

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    results = {}
    for k in range(2,13):
        results[k] = 0

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    nRolls = 1000
    for i in range(0,nRolls):
        temp_result = sumTwoDieRolls()
        results[temp_result] = results[temp_result] + 1

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    for k in results.keys():
        print( str(k) + ": " + str(results[k]) + ", " + str(100*results[k]/nRolls) )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

