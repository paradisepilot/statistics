
'''
dummy comment
'''


import re

from Ex135 import areAnagrams

def areAnagrams1( s0 , s1 ):

    u0 = re.sub(string = s0.upper(), pattern = "[^A-Z]", repl = "")
    u1 = re.sub(string = s1.upper(), pattern = "[^A-Z]", repl = "")

    return( areAnagrams( u0 , u1 ) )

def ex136():

    print("\n### ~~~~~ Exercise 136 ~~~~~~~~");

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    stringPairs = [
        [ 'Hello, World!', 'AA  BBBCCCC '],
        [ "William Shakespeare", "I am a weakish speller" ]
        ]

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    for stringPair in stringPairs:
        s0 = stringPair[0]
        s1 = stringPair[1]
        print( "areAnagrams( '",s0,"' , '",s1,"' ): " + str(areAnagrams1( s0 , s1 )) )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

