
'''
dummy comment
'''

import nltk, re, string

from nltk.corpus  import gutenberg, europarl_raw
from pprint       import pprint
from contractions import CONTRACTION_MAP

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
    print( "\n### tokenization:" )
    for temp in token_list:
        print( "\n# ~~~~~~~~~ #\n" )
        print( temp )
    print( "\n# ~~~~~~~~~ #\n" )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    filteredList01 = [
        [ remove_special_characters_after_tokenization(tokens) for tokens in sentence_tokens ]
        for sentence_tokens in token_list
        ]

    print( "\n### tokenization -> removal of special characters:" )
    print( "string.punctuation: " + str(string.punctuation) )
    for temp in filteredList01:
        print( "\n# ~~~~~~~~~ #\n" )
        print( temp )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    filteredList01 = [
        list(filter(
            None,
            [ remove_special_characters_after_tokenization(tokens) for tokens in sentence_tokens ]
            ))
        for sentence_tokens in token_list
        ]

    print( "\n### tokenization -> removal of special characters -> filter(None,*):" )
    for temp in filteredList01:
        print( "\n# ~~~~~~~~~ #\n" )
        print( temp )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    filteredList02 = [ remove_special_characters_before_tokenization(sentence) for sentence in corpus ]

    print( "\n### removal of special characters (keep_apostrophes = False):" )
    for temp in filteredList02:
        print( "\n# ~~~~~~~~~ #\n" )
        print( temp )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    cleaned_corpus = [
        remove_special_characters_before_tokenization(sentence, keep_apostrophes = True)
        for sentence in corpus
        ]

    print( "\n### removal of special characters (keep_apostrophes = True):" )
    for temp in cleaned_corpus:
        print( "\n# ~~~~~~~~~ #\n" )
        print( temp )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    expanded_corpus = [
        expand_contractions(sentence, CONTRACTION_MAP)
        for sentence in cleaned_corpus
        ]

    print( "\n### cleaned-then-expanded corpus:" )
    for temp in expanded_corpus:
        print( "\n# ~~~~~~~~~ #\n" )
        print( temp )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

###################################################
###################################################
def tokenize_text(text):
    sentences  = nltk.sent_tokenize(text)
    wordTokens = [ nltk.word_tokenize(sentence) for sentence in sentences ]
    return( wordTokens )

###################################################
def remove_special_characters_before_tokenization(sentence, keep_apostrophes = False):
    sentence = sentence.strip()
    if keep_apostrophes:
        myPattern = '[?|$|&|*|%|@|(|)|~]'
        filtered_sentence = re.sub(myPattern,'',sentence)
    else:
        myPattern = '[^a-zA-Z0-9 ]'
        filtered_sentence = re.sub(myPattern,'',sentence)
    return(  filtered_sentence )

###################################################
def remove_special_characters_after_tokenization(tokens):
    myPattern      = re.compile('[{}]'.format(re.escape(string.punctuation)))
    filteredTokens = list( filter(None,[myPattern.sub('',token) for token in tokens]) )
    return( filteredTokens )

###################################################
def expand_contractions(sentence, contraction_mapping):

    contractions_pattern = re.compile(
        '{}'.format('|'.join(contraction_mapping.keys())),
        flags = re.IGNORECASE|re.DOTALL
        )

    def expand_match(contraction):
        match = contraction.group(0)
        first_char = match[0]
        expanded_contraction = contraction_mapping.get(match) if contraction_mapping.get(match) else contraction_mapping.get(match.lower())
        expanded_contraction = first_char + expanded_contraction[1:]
        return(expanded_contraction)

    expanded_sentence = contractions_pattern.sub(expand_match,sentence)

    return( expanded_sentence )
