
'''
dummy comment
'''

import os, re, numpy, pandas, nltk
from nltk.util import ngrams

def section_02_03( datDIR ):

    print("\n### ~~~~~ Section 02.03 ~~~~~~~~");

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
    s01 = sentences[20] + " " + sentences[21]
    s02 = sentences[23] + " " + sentences[24] + " " + sentences[25]
    s03 = sentences[27] + " " + sentences[28] + " " + sentences[29]

    sentences = [ s01, s02, s03 ]

    print("\nsentences:")
    print(   sentences  )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    #myPattern = re.compile("([- \s.,;!?])+")
    s01       = re.sub(string = s01, pattern = "(\.|,|;|:|\?) ", repl = " ")
    s01       = re.sub(string = s01, pattern = "(\.|,|;|:|\?)$", repl = "" )
    myPattern = re.compile(" +")
    myTokens  = myPattern.split(s01)

    myNgrams  = list(ngrams(myTokens,2))
    print("\nmyNgrams:")
    print(   myNgrams  )

    myNgrams  = list(ngrams(myTokens,3))
    print("\nmyNgrams:")
    print(   myNgrams  )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    myNgrams = [ ' '.join(tempNgrams) for tempNgrams in myNgrams ]
    print("\nmyNgrams:")
    print(   myNgrams  )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    stopwords_EN = nltk.corpus.stopwords.words('english')
    stopwords_FR = nltk.corpus.stopwords.words('french')

    print("")
    print( "len(stopwords_EN): " + str(len(stopwords_EN)) )
    print( "len(stopwords_FR): " + str(len(stopwords_FR)) )

    print("")
    print("stopwords_EN")
    print( stopwords_EN )

    print("")
    print("stopwords_FR")
    print( stopwords_FR )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

