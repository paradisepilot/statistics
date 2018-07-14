
'''
dummy comment
'''

import os, re

from GetBigTxt import getBigTxt

def ex150( inputFILE , outputFILE ):

    print("\n### ~~~~~ Exercise 150 ~~~~~~~~");

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    if not os.path.isfile( inputFILE ):
        print( "Error: file not found: " + inputFILE )
        return( None )

    with open( file = inputFILE , mode = 'r' ) as inF:
        with open( file = outputFILE , mode = 'w' ) as outF:
            for i, tempLine in enumerate(inF):
                tempLine = tempLine.rstrip()
                tempLine = re.sub(string = tempLine, pattern = "#.+", repl = "")
                print( tempLine , file = outF )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

