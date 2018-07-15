
'''
dummy comment
'''

import os, re, numpy, pandas, nltk
from nltk.tokenize import RegexpTokenizer, TreebankWordTokenizer

def section_02_02( datDIR ):

    print("\n### ~~~~~ Section 02.02 ~~~~~~~~");

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    textfile = os.path.join( datDIR , "the-great-gatsby.txt" )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    with open(file = textfile, mode = 'r') as inF:
        sentences = []
        for i, tempLine in enumerate(inF):
            if i > 100:
                break
            tempLine = tempLine.strip()
            sentences.append(tempLine)
            print( "%5d: %s" % (i,tempLine) )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    mySentence = sentences[20] + " " + sentences[21]
    print("\nmySentence:")
    print(   mySentence  )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    #tokens = mySentence.split("([-\s.,;!?])+")
    tokens = re.split("([-\s.,;!?])+",mySentence)
    temp = list(filter(lambda x: x if x not in '- \t\n.,;!?' else None,tokens))
    print("\ntemp")
    print(   temp )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    myPattern = re.compile("([-\s.,;!?])+")
    tokens = myPattern.split(mySentence)
    print("\ntokens[-10:]")
    print(   tokens[-10:] )

    temp = list(filter(lambda x: x if x not in '- \t\n.,;!?' else None,tokens))
    print("\ntemp")
    print(   temp )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    myRegexpTokenizer = RegexpTokenizer("\w+|$[0-9.]+|\S+")
    print("\nmyRegexpTokenizer.tokenize(mySentence):")
    print(   myRegexpTokenizer.tokenize(mySentence)  )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    myTreebankWordTokenizer = TreebankWordTokenizer()
    print("\nmyTreebankWordTokenizer.tokenize(mySentence):")
    print(   myTreebankWordTokenizer.tokenize(mySentence)  )
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

