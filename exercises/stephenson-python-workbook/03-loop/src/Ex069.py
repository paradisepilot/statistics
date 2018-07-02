
'''
dummy comment
'''

def getPiSequence( maxOrder ):
    output = { 0:3 }
    for i in range(1,maxOrder+1):
        output[i] = ((-1)**(i+1)) * 4 / ( (2*i) * (2*i+1) * (2*i+2) )
    return( output )

def showCumulativeSums( sequence ):

    sorted_keys = list(sequence.keys())
    sorted_keys.sort()

    format_header = "%5s %15s %15s"
    format_body   = "%5s %15.10f %15.10f"

    cumulativeSum = 0
    print( format_header % ('order','term','cumulative') )
    for order in sorted_keys:
        currentTerm    = sequence[order]
        cumulativeSum += currentTerm
        print( format_body % (order,currentTerm,cumulativeSum) )

    return( None )

def ex069():

    print("\n### ~~~~~ Exercise 069 ~~~~~~~~");

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    maxOrder   = 100
    piSequence = getPiSequence(maxOrder = maxOrder)
    #print( piSequence )

    showCumulativeSums( sequence = piSequence )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

