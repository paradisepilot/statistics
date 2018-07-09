
'''
dummy comment
'''

def getSqrtNewton( x , tolerance = 1e-12 , max_iterations = 500 ):

    i        = 1
    estimate = x / 2
    error    = abs(x - estimate**2)

    while (error > tolerance) and (i <= max_iterations):
        i        += 1
        estimate  = (estimate + x / estimate) / 2
        error     = abs(x - estimate**2)

    output = {
        'input'       : x,
        'estimate'    : estimate,
        'error'       : error,
        'nIterations' : i
        }

    return( output )

def ex071():

    print("\n### ~~~~~ Exercise 071 ~~~~~~~~");

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    myNumbers = [ 25, 49, 50, 51, 101, 1234567 ]

    for myNumber in myNumbers:
        results = getSqrtNewton(x = myNumber)
        print( results  )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

