
'''
dummy comment
'''

import nltk
from nltk.corpus import gutenberg
from pprint      import pprint

def sentenceTokenization():

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    alice = gutenberg.raw(fileids = 'carroll-alice.txt')

    sample_text = 'We will discuss briefly about the basic syntax, structure and design philosophies. There is a defined hierarchical syntax for Python code which you should remember when writing code! Python is a really powerful programming language!'

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print( "\n### len(alice), number of characters: " + str(len(alice)) )

    print( "\n### First 1000 characters of carroll-alice.txt:\n" )
    print( alice[0:1000] )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

