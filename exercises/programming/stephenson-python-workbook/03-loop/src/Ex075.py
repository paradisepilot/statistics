
'''
dummy comment
'''

def getGCD( m , n ):

    if m == n:
        output = { 'm':m , 'n':n , 'gcd':m }
        return( output )

    d = min(m,n)
    while ((m % d) != 0) or ((n % d) != 0):
        d -= 1

    output = { 'm': m, 'n': n, 'gcd':d }

    return( output )

def ex075():

    print("\n### ~~~~~ Exercise 075 ~~~~~~~~");

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    myPairs = [
        [ 25,  49],
        [ 50,  51],
        [ 25,  50],
        [ 25,  15],
        [(2**3)*(3**4)*(7**2),(2**2)*(3**3)*(5**3)]
        ]

    for myPair in myPairs:
        results = getGCD( m = myPair[0] , n = myPair[1] )
        print( results )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

