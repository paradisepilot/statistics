
'''
dummy comment
'''

import nltk, re, string

from nltk.corpus import gutenberg, europarl_raw
from pprint      import pprint

###################################################
def textNormalization():

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    corpus = [
        "The brown fox wasn't that quick and he couldn't win the race.",
        "Hey that's a great deal! I just bought a phone for $199.",
        "@@You'll (learn) a **lot** in the book. Python is an amazing language!@@"
        ]

    print( "\n### corpus:" )
    for temp in corpus:
        print( "\n# ~~~~~~~~~ #\n" )
        print( temp )
    print( "\n# ~~~~~~~~~ #\n" )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    token_list = [ tokenize_text(text) for text in corpus ]
    print( "\n### token_list:" )
    for temp in token_list:
        print( "\n# ~~~~~~~~~ #\n" )
        print( temp )
    print( "\n# ~~~~~~~~~ #\n" )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

###################################################
###################################################
def tokenize_text(text):

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    sentences  = nltk.sent_tokenize(text)
    wordTokens = [ nltk.word_tokenize(sentence) for sentence in sentences ]

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( wordTokens )

###################################################
def remove_special_characters_before_tokenization(tokens):

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

###################################################
def remove_special_characters_after_tokenization(tokens):

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

