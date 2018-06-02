
'''
dummy comment
'''

import nltk

from nltk.corpus import gutenberg, europarl_raw
from pprint      import pprint

###################################################
def wordTokenization():

    mySentence = "The brown fox isn't that quick and he couldn't win the race."
    print("\n### mySentence:")
    print( mySentence )

    myWordTokenizer = nltk.word_tokenize
    myWords = myWordTokenizer(mySentence)
    print("\n### tokenized with nltk.word_tokenize:")
    print( myWords )

    myWords = nltk.TreebankWordTokenizer().tokenize(text = mySentence)
    print("\n### tokenized with nltk.TreebankWordTokenizer().tokenize:")
    print( myWords )

    myPattern = '\w+'
    regexpTokenizer = nltk.RegexpTokenizer(pattern = myPattern, gaps = False)
    myWords = regexpTokenizer.tokenize(text = mySentence)
    print("\n### tokenized with nltk.RegexpTokenizer(pattern = '\w+', gaps = False).tokenize:")
    print( myWords )

    myPattern = '\s+'
    regexpTokenizer = nltk.RegexpTokenizer(pattern = myPattern, gaps = True)
    myWords = regexpTokenizer.tokenize(text = mySentence)
    print("\n### tokenized with nltk.RegexpTokenizer(pattern = '\s+', gaps = True).tokenize:")
    print( myWords )

    wordIndices = list( regexpTokenizer.span_tokenize(text = mySentence) )
    print("\n### tokenized with nltk.RegexpTokenizer(pattern = '\s+', gaps = True).span_tokenize:")
    print( wordIndices )
    print( [ mySentence[start:end] for start, end in wordIndices ] )

###################################################
def sentenceTokenization():

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    mySentenceTokenizer = nltk.sent_tokenize

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    sample_text = 'We will discuss briefly about the basic syntax, structure and design philosophies. There is a defined hierarchical syntax for Python code which you should remember when writing code! Python is a really powerful programming language!'

    sentences_sample = mySentenceTokenizer(text = sample_text)

    print( '\nTotal number of sentences in sample_text: ' + str(len(sentences_sample)) )
    print( '\nSample sentences:' )
    print( sentences_sample )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    alice = gutenberg.raw(fileids = 'carroll-alice.txt')
    print( "\n### len(alice), total number of characters: " + str(len(alice)) )
    print( "\n### First 1000 characters of carroll-alice.txt:\n" )
    print( alice[0:1000] )

    sentences_alice  = mySentenceTokenizer(text = alice)
    print( '\nTotal number of sentences in Alice: ' + str(len(sentences_alice)) )
    print( '\nFirst 5 sentences in Alice:' )
    for temp_sentence in sentences_alice[0:5]:
        print( "\n### ~~~~~~~~~~ ###\n" + temp_sentence )
    print( "\n### ~~~~~~~~~~ ###" )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    text_german = europarl_raw.german.raw(fileids = "ep-00-01-17.de")
    print( "\n### len(German text), total number of characters: " + str(len(text_german)) )
    print( "\n### First 1000 characters of ep-00-01-17.de (German text):\n" )
    print( text_german[0:1000] )

    sentences_german = mySentenceTokenizer(text = text_german, language = "german")
    print( '\nTotal number of sentences in German text: ' + str(len(sentences_german)) )
    print( '\nFirst 5 sentences in German text:' )
    for temp_sentence in sentences_german[0:5]:
        print( "\n### ~~~~~~~~~~ ###\n" + temp_sentence )
    print( "\n### ~~~~~~~~~~ ###" )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

