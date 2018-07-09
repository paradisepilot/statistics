
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
    results      = {}
    expectations = {}
    for k in range(2,13):
        results[k]      = 0
        expectations[k] = 0

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    expectations[ 2] = 1/36
    expectations[12] = 1/36

    expectations[ 3] = 2/36
    expectations[11] = 2/36

    expectations[ 4] = 3/36
    expectations[10] = 3/36

    expectations[ 5] = 4/36
    expectations[ 9] = 4/36

    expectations[ 6] = 5/36
    expectations[ 8] = 5/36

    expectations[ 7] = 6/36

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    nRolls = 1000000
    for i in range(0,nRolls):
        temp_result = sumTwoDieRolls()
        results[temp_result] = results[temp_result] + 1

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print( "%6s %7s %8s %8s" % ('rolled','count','observed','expected') )
    print( "%6s %7s %8s %8s" % ( 'total',''     ,' percent',' percent') )
    for k in results.keys():
        print( "%6d %7d %8.3f %8.3f" % (k,results[k],100*results[k]/nRolls,100*expectations[k]) )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

