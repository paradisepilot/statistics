
'''
dummy comment
'''

import nltk, re, string

from nltk.corpus  import gutenberg, europarl_raw
from pprint       import pprint
from contractions import CONTRACTION_MAP

###################################################
def correctRepeatCharacters():

    old_word = 'finalllyyy'
    repeat_pattern = re.compile(r'(\w*)(\w)\2(\w*)')
    match_substitution = r'\1\2\3'

    step = 1
    while True:
        # remove one repeated character
        new_word = repeat_pattern.sub(match_substitution,old_word)
        if new_word != old_word:
            print( 'Step: {}, Word: {}'.format(step,new_word) )
            step += 1 # update step
            # update old word to last substituted state
            old_word = new_word
            continue
        else:
            print( "Final word: " + new_word )
            break

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

###################################################
###################################################

