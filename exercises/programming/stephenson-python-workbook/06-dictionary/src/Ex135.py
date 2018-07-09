
'''
dummy comment
'''

def getCharFrequencies( s ):

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    dictFreq = {}
    for temp_char in list(s):
        if temp_char in dictFreq.keys():
            dictFreq[temp_char] = dictFreq[temp_char] + 1
        else:
            dictFreq[temp_char] = 1

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( dictFreq )

def areAnagrams( s1 , s2 ):
    return( getCharFrequencies(s1) == getCharFrequencies(s2) )

def ex135():

    print("\n### ~~~~~ Exercise 135 ~~~~~~~~");

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    myStrings = [
        'Hello, World!',
        'AA  BBBCCCC '
        ]

    for myString in myStrings:
        print( "getCharFrequencies('" + myString + "'):" )
        print( getCharFrequencies( myString ) )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print( "areAnagrams( 'live' , 'evil' ): " + str(areAnagrams( 'live' , 'evil' )) )
    print( "areAnagrams( 'live' , 'avil' ): " + str(areAnagrams( 'live' , 'avil' )) )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

