
'''
dummy comment
'''

import os, re

class Book:

    def __init__( self , txtfile ):
        self.word_counts   = self.getWordCounts( txtfile )
        self.num_words     = sum( self.word_counts.values() )
        self.letter_counts = self.getLetterCounts( self.word_counts )

    def getWordCounts( self, txtfile ):
        word_counts = {}
        with open( file = txtfile , mode = 'r' ) as inF:
            for i, tempLine in enumerate(inF):
                tempLine = tempLine.strip().lower()
                tempLine = re.sub(string = tempLine, pattern = "[^ A-Za-z]", repl = "" )
                tempLine = re.sub(string = tempLine, pattern = " +",         repl = " ")
                tempList = tempLine.split(' ')
                for tempword in tempList:
                    if len(tempword) > 0:
                        if tempword in word_counts.keys():
                            word_counts[tempword] += 1
                        else:
                            word_counts[tempword] = 1
        word_counts = { r:word_counts[r] for r in sorted(word_counts, key=word_counts.get, reverse=True) }
        return( word_counts )

    def getLetterCounts( self , word_counts ):
        letter_counts = {}
        for tempword in word_counts.keys():
            for templetter in list(tempword):
                if templetter in letter_counts.keys():
                    letter_counts[templetter] += word_counts[tempword]
                else:
                    letter_counts[templetter]  = word_counts[tempword]
        letter_counts = { k:letter_counts[k] for k in sorted(letter_counts.keys()) }
        return( letter_counts )

def ex153( datDIR ):

    print("\n### ~~~~~ Exercise 153 ~~~~~~~~");

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    myTxtfile = os.path.join( datDIR, 'the-great-gatsby.txt' )
    myBook    = Book( txtfile = myTxtfile )

    #for tempkey in myBook.word_counts.keys():
    #    print( tempkey + ": " + str(myBook.word_counts[tempkey]) )

    print( "total number of words: " + str(myBook.num_words) )

    for tempkey in myBook.letter_counts.keys():
        tempcount = myBook.letter_counts[tempkey]
        tempprop  = tempcount / myBook.num_words
        print( "%s: %7d, %6.3f" % (tempkey,tempcount,tempprop) )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

