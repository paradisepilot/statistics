
'''
dummy comment
'''

import os, re, numpy, pandas

def section_02_01( datDIR ):

    print("\n### ~~~~~ Section 02.01 ~~~~~~~~");

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
    listOfWords  = mySentence.split(' ')
    myVocabulary = sorted(set( listOfWords ))
    onehotwords  = numpy.zeros( (len(listOfWords),len(myVocabulary)) , int )
    for i, word in enumerate(listOfWords):
        onehotwords[i,myVocabulary.index(word)] = 1

    print("\nmyVocabulary")
    print(   myVocabulary )

    print("\nonehotwords")
    print(   onehotwords )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    sentenceBoW = {}
    for token in mySentence.split(' '):
        sentenceBoW[ token ] = 1

    print("\nsentenceBoW.items()")
    print(   sentenceBoW.items() )

    print("\nsorted(sentenceBoW.items())")
    print(   sorted(sentenceBoW.items()) )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    s01 = sentences[20] + " " + sentences[21]
    s02 = sentences[23] + " " + sentences[24] + " " + sentences[25]
    s03 = sentences[27] + " " + sentences[28] + " " + sentences[29]

    sentences = [ s01, s02, s03 ]

    corpus = {}
    for i, tempLine in enumerate(sentences):
        corpus['s{}'.format(i)] = dict( (token,1) for token in tempLine.split(' ') )

    DF_onehot = pandas.DataFrame.from_records(corpus).fillna(0).astype(int).T
    print("\nDF_onehot[DF_onehot.columns[:7]]")
    print(   DF_onehot[DF_onehot.columns[:15]] )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF_onehot = DF_onehot.T
    print("")
    print( (DF_onehot.s0 & DF_onehot.s2)         )
    print( (DF_onehot.s0 & DF_onehot.s2).items() )
    print( [(k, v) for (k, v) in (DF_onehot.s0 & DF_onehot.s2).items() if v > 0] )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

