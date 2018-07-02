
'''
dummy comment
'''

def binary2Decimal( x ):

    reverselist_x = list(x)
    reverselist_x.reverse()
    reverselist_x = list(map(int,reverselist_x))

    length_x = len(reverselist_x)

    decimal = 0
    for i in range(0,length_x):
        decimal += reverselist_x[i] * (2**i)

    output = { 'input': x, 'decimal':decimal }

    return( output )

def ex077():

    print("\n### ~~~~~ Exercise 077 ~~~~~~~~");

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    myBinaryIntegers = [
         '1100110',
         '1101011',
        '10001011'
        ]

    for myBinaryInteger in myBinaryIntegers:
        results = binary2Decimal( x = myBinaryInteger )
        print( results )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

