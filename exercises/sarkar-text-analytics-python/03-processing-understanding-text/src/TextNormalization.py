
'''
dummy comment
'''

import os, nltk, re, string, collections

from nltk.corpus  import gutenberg, europarl_raw, wordnet
from pprint       import pprint
from contractions import CONTRACTION_MAP
from GetBigTxt    import getBigTxt

###################################################
def textNormalization( datDIR ):

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    corpus = [
        "The brown fox wasn't that quick and he couldn't win the race.",
        "Hey that's a great deal! I just bought a phone for $199.",
        "@@You'll (learn) a **lot** in the book. Python is an amaaaaazing language!@@"
        ]

    print( "\n\n### corpus:" )
    for temp in corpus:
        print( "# ~~~~~~~~~ #" )
        print( temp )
    print( "# ~~~~~~~~~ #\n" )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    token_list = [ tokenize_text(text) for text in corpus ]
    print( "\n\n### tokenization:" )
    for temp in token_list:
        print( "# ~~~~~~~~~ #" )
        print( temp )
    print( "# ~~~~~~~~~ #\n" )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    filteredList01 = [
        [ remove_special_characters_after_tokenization(tokens) for tokens in sentence_tokens ]
        for sentence_tokens in token_list
        ]

    print( "\n\n### tokenization -> removal of special characters:" )
    print( "string.punctuation: " + str(string.punctuation) )
    for temp in filteredList01:
        print( "# ~~~~~~~~~ #" )
        print( temp )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    filteredList01 = [
        list(filter(
            None,
            [ remove_special_characters_after_tokenization(tokens) for tokens in sentence_tokens ]
            ))
        for sentence_tokens in token_list
        ]

    print( "\n\n### tokenization -> removal of special characters -> filter(None,*):" )
    for temp in filteredList01:
        print( "# ~~~~~~~~~ #" )
        print( temp )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    filteredList02 = [ remove_special_characters_before_tokenization(sentence) for sentence in corpus ]

    print( "\n\n### removal of special characters (keep_apostrophes = False):" )
    for temp in filteredList02:
        print( "# ~~~~~~~~~ #" )
        print( temp )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    cleaned_corpus = [
        remove_special_characters_before_tokenization(sentence, keep_apostrophes = True)
        for sentence in corpus
        ]

    print( "\n\n### removal of special characters (keep_apostrophes = True):" )
    for temp in cleaned_corpus:
        print( "# ~~~~~~~~~ #" )
        print( temp )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    expanded_corpus = [
        expand_contractions(sentence, CONTRACTION_MAP)
        for sentence in cleaned_corpus
        ]

    print( "\n")
    print( "### (1) removed special characters," )
    print( "### (2) expanded contractions," )
    for temp in expanded_corpus:
        print( "# ~~~~~~~~~ #" )
        print( temp )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    expanded_corpus_tokens = [ tokenize_text(text) for text in expanded_corpus ]
    filteredList03 = [
        [ remove_stopwords(tokens) for tokens in sentence_tokens ]
        for sentence_tokens in expanded_corpus_tokens
        ]

    print( "\n")
    print( "### (1) removed special characters," )
    print( "### (2) expanded contractions," )
    print( "### (3) removed stop words" )
    for temp in filteredList03:
        print( "# ~~~~~~~~~ #" )
        print( temp )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    filteredList04 = [
        [ remove_repeated_characters(tokens) for tokens in sentence_tokens ]
        for sentence_tokens in filteredList03
        ]

    print( "\n")
    print( "### (1) removed special characters," )
    print( "### (2) expanded contractions," )
    print( "### (3) removed stop words" )
    print( "### (4) corrected repeat characters" )
    for temp in filteredList04:
        print( "# ~~~~~~~~~ #" )
        print( temp )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    BigTxtFILE = os.path.join(datDIR,"big.txt")
    getBigTxt( BigTxtFILE = BigTxtFILE )

    print( "\n")
    print( "###" )
    with open(BigTxtFILE,'r') as f:
        WORDS       = tokens( f.read() )
        WORD_COUNTS = collections.Counter(WORDS)
        print( "WORD_COUNTS.most_common(10):" )
        print(  WORD_COUNTS.most_common(10)   )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    #filteredList05 = [
    #    [ remove_repeated_characters(tokens) for tokens in sentence_tokens ]
    #    for sentence_tokens in filteredList04
    #    ]

    #print( "\n")
    #print( "### (1) removed special characters," )
    #print( "### (2) expanded contractions," )
    #print( "### (3) removed stop words" )
    #print( "### (4) corrected repeat characters" )
    #print( "### (5) corrected repeat characters" )
    #for temp in filteredList04:
    #    print( "# ~~~~~~~~~ #" )
    #    print( temp )

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

###################################################
def remove_stopwords(tokens):
    stopword_list   = nltk.corpus.stopwords.words('english')
    filtered_tokens = [token for token in tokens if token not in stopword_list]
    return( filtered_tokens )

###################################################
def remove_repeated_characters(tokens):

    repeat_pattern      = re.compile(r'(\w*)(\w)\2(\w*)')
    replacement_pattern = r'\1\2\3'

    def replace(old_word):
        if wordnet.synsets(old_word):
            return old_word
        new_word = repeat_pattern.sub(repl = replacement_pattern, string = old_word)
        return replace(new_word) if new_word != old_word else new_word

    correct_tokens = [ replace(word) for word in tokens ]
    return correct_tokens

###################################################
def tokens(text):
    return( re.findall('[a-z]+',text.lower()) )
