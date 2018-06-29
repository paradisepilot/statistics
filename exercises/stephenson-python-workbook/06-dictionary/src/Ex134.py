
'''
dummy comment
'''

def countUniqueChars( s ):

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    my_dict = {}
    for temp_char in list(s):
        my_dict[temp_char] = temp_char

    list(my_dict.keys())

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( len( list(my_dict.keys()) ) )

def ex134():

    print("\n### ~~~~~ Exercise 134 ~~~~~~~~");

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    myStrings = [
        'Hello, World!',
        'AA  BBBCCCC '
        ]

    for myString in myStrings:
        print( "countUniqueChars('" + myString + "'): " + str(countUniqueChars( myString )) )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

