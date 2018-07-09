
'''
dummy comment
'''

import math, numpy


def isPerfect( n ):

    divisors = []
    for i in range(2,n):
        if (0 == (n % i)):
            divisors.append(i)
    sumDivisors = 1 + sum(divisors)
    if (n == sumDivisors):
        is_perfect = True
    else:
        is_perfect = False

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( is_perfect )

def ex110( N ):

    print("\n### ~~~~~ Exercise 110 ~~~~~~~~");

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print( "\nN: " + str(N) )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    for i in range(2,1+N):
        if isPerfect(i):
            print( i )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

