
'''
dummy comment
'''

import os, re, numpy, pandas, nltk
from nltk.util import ngrams
from nltk.stem.porter import PorterStemmer
from nltk.stem import WordNetLemmatizer
from nltk.tokenize import casual_tokenize
from collections import Counter
from sklearn.naive_bayes import MultinomialNB

def section_02_04( datDIR ):

    print("\n### ~~~~~ Section 02.04 ~~~~~~~~");

    pandas.set_option('display.width', 160)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    textfile = os.path.join( datDIR , "sentiment-labelled-sentences" , "imdb_labelled.txt" )
    DF_imdb  = pandas.read_csv( textfile , sep = '\t' , quoting = 3, header = None , names = ['sentence','score'] )

    print("\nDF_imdb.shape:")
    print(   DF_imdb.shape  )

    print("\nDF_imdb.head():")
    print(   DF_imdb.head()  )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    bags_of_words = []
    for sentence in DF_imdb['sentence']:
        sentence = re.sub(string = sentence, pattern = '"', repl = '')
        sentence = sentence.strip()
        # print( "###: " + sentence )
        bags_of_words.append(Counter(casual_tokenize(sentence)))

    DF_bows = pandas.DataFrame.from_records(bags_of_words)
    DF_bows = DF_bows.fillna(0).astype(int)
    print( "\nDF_bows.shape: " + str(DF_bows.shape) )
    print("Df_bows.head():")
    print( DF_bows.head()  )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    mnomNB = MultinomialNB()
    mnomNB = mnomNB.fit(X = DF_bows, y = (DF_imdb['score'] > 0))

    DF_imdb['predicted'] = mnomNB.predict(DF_bows) * 1
    print("\nDF_imdb.head(10):")
    print(   DF_imdb.head(10)  )

    print("\nDF_imdb[DF_imdb['score'] != DF_imdb['predicted']]:")
    print(   DF_imdb[DF_imdb['score'] != DF_imdb['predicted']]  )

    print("\n(DF_imdb[DF_imdb['score'] == DF_imdb['predicted']]).shape[0]:")
    print(   (DF_imdb[DF_imdb['score'] == DF_imdb['predicted']]).shape[0]  )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    textfile = os.path.join( datDIR , "sentiment-labelled-sentences" , "yelp_labelled.txt" )
    DF_yelp  = pandas.read_csv( textfile , sep = '\t' , quoting = 3, header = None , names = ['sentence','score'] )

    print("\nDF_yelp.shape:")
    print(   DF_yelp.shape  )

    print("\nDF_yelp.head():")
    print(   DF_yelp.head()  )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    #bags_of_words = []
    for sentence in DF_yelp['sentence']:
        sentence = re.sub(string = sentence, pattern = '"', repl = '')
        sentence = sentence.strip()
        # print( "###: " + sentence )
        bags_of_words.append(Counter(casual_tokenize(sentence)))

    DF_bows_all = pandas.DataFrame.from_records(bags_of_words)
    DF_bows_all = DF_bows_all.fillna(0).astype(int)
    print( "\nDF_bows_all.shape: " + str(DF_bows_all.shape) )
    print("DF_bows_all.head():")
    print( DF_bows_all.head()  )

    DF_bows_yelp = DF_bows_all.iloc[len(DF_bows):][DF_bows.columns]
    print( "\nDF_bows_yelp.shape: " + str(DF_bows_yelp.shape) )
    print("DF_bows_yelp.head():")
    print( DF_bows_yelp.head()  )

    DF_yelp['predicted'] = mnomNB.predict(DF_bows_yelp) * 1
    print("\nDF_yelp.head(10):")
    print(   DF_yelp.head(10)  )

    print("\nDF_yelp[DF_yelp['score'] != DF_yelp['predicted']]:")
    print(   DF_yelp[DF_yelp['score'] != DF_yelp['predicted']]  )

    print("\n(DF_yelp[DF_yelp['score'] == DF_yelp['predicted']]).shape[0]:")
    print(   (DF_yelp[DF_yelp['score'] == DF_yelp['predicted']]).shape[0]  )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

