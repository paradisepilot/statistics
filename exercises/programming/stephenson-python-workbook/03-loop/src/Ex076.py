
'''
dummy comment
'''

def getPrimeFactors( n ):

    dividend = n
    factor   = 2

    primeFactors = []
    while factor <= dividend:
        if (dividend % factor) == 0:
            primeFactors.append(factor)
            dividend = dividend // factor
        else:
            factor += 1

    output = { 'n': n, 'prime_factors':primeFactors }

    return( output )

def ex076():

    print("\n### ~~~~~ Exercise 076 ~~~~~~~~");

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    myIntegers = [
        (2**2)*(3**3)*(5**3),
        (2**3)*(3**4)*(7**2)
        ]

    for myInteger in myIntegers:
        results = getPrimeFactors( n = myInteger )
        print( results )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

