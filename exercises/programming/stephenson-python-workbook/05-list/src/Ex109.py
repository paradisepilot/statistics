
'''
dummy comment
'''

import math, numpy

def ex109( n ):

    print("\n### ~~~~~ Exercise 109 ~~~~~~~~");

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print( "\nn: " + str(n) )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    primes = []
    for i in range(2,math.ceil(math.sqrt(n))):
        if all((i % k) != 0 for k in range(2,1+math.floor(math.sqrt(i)))):
            primes.append(i)

    print( "\nlen(primes): " + str(len(primes)) )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    prime_divisors = []
    for i in range(2,math.ceil(math.sqrt(n))):
        if all((i % k) != 0 for k in range(2,1+math.floor(math.sqrt(i)))):
            if 0 == (n % i):
                prime_divisors.append(i)

    print( "\nprime_divisors: " + str(prime_divisors) )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

