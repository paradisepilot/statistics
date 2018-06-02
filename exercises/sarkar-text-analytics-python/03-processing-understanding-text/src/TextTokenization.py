
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
    print( "\n### len(alice), total number of characters: " + str(len(alice)) )

    print( "\n### First 1000 characters of carroll-alice.txt:\n" )
    print( alice[0:1000] )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    mySentenceTokenizer = nltk.sent_tokenize
    sentences_alice     = mySentenceTokenizer(text = alice)
    sentences_sample    = mySentenceTokenizer(text = sample_text)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print( '\nTotal number of sentences in sample_text: ' + str(len(sentences_sample)) )
    print( '\nSample sentences:' )
    print( sentences_sample )

    print( '\nTotal number of sentences in Alice: ' + str(len(sentences_alice)) )
    print( '\nFirst 5 sentences in Alice:' )
    for temp_sentence in sentences_alice[0:5]:
        print( "\n### ~~~~~~~~~~ ###\n" + temp_sentence )
    print( "### ~~~~~~~~~~ ###" )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

