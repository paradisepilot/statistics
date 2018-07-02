
'''
dummy comment
'''

def decimal2Binary( x ):

    binary   = ''
    quotient = x

    while quotient > 0:
        binary   = str( quotient % 2 ) + binary
        quotient = quotient // 2

    output = { 'input':x , 'binary':binary }

    return( output )

def ex078():

    print("\n### ~~~~~ Exercise 078 ~~~~~~~~");

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    myIntegers = [ 19, 53, 139 ]

    for myInteger in myIntegers:
        results = decimal2Binary( x = myInteger )
        print( results )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

