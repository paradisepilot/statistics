
'''
dummy comment
'''

import re

def listOfWords( s ):

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    toBeRemoved = "[\,\.\?\'\!:;-]"

    s_cleaned = re.sub(pattern = toBeRemoved + " +", repl = " ", string = s)
    s_cleaned = re.sub(pattern = " +" + toBeRemoved, repl = " ", string = s_cleaned)
    s_cleaned = re.sub(pattern = toBeRemoved + "$",  repl = "",  string = s_cleaned)

    list_of_words = s_cleaned.split(' ')

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( list_of_words )

def ex111( s ):

    print("\n### ~~~~~ Exercise 111 ~~~~~~~~");

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print( "\ns: " + s )
    print( "\nlistOfWords(s):" )
    print( listOfWords(s) )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

