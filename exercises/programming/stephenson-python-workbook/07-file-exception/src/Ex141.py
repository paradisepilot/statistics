
'''
dummy comment
'''

import os, re

from GetBigTxt import getBigTxt

def ex141( datDIR ):

    print("\n### ~~~~~ Exercise 141 ~~~~~~~~");

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    BigTxtFILE = os.path.join(datDIR,"big.txt")
    getBigTxt( BigTxtFILE = BigTxtFILE )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    with open( BigTxtFILE ) as f:
        for i in range(0,10):
            tempLine = f.readline()
            tempLine = re.sub(string = tempLine, pattern = "\n$", repl = "")
            print( "line %2d: " % (i+1) , end = "" )
            print( tempLine )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

