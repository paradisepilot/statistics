
'''
dummy comment
'''

import re

from nltk.corpus import wordnet

###################################################
def correctRepeatCharacters():

    old_word = 'finalllyyy'

    repeat_pattern = re.compile( r"(\w*)(\w)\2(\w*)" )
    # Group 1: (\w*) = zero or more word character, followed by
    # Group 2: (\w)  = single word character 
    #          \2    = a repeated occurence of Group 2, in this
    #                  case, the single word character matched
    #                  in Group 2, followed by
    # Group 3: (\w*) = zero or more word charater

    replacement_pattern = r"\1\2\3"
    # replacement pattern
    # Technically: Group 1, followed by Group 2, followed by
    # Group 3, where Groups 1,2,3 are the groups of
    # characters matched above. Recall that Group 2 must
    # appear two or more times. Thus, a replacement pattern
    # of "\1\2\3" essentially removes one repeated occurence
    # of Group 2.

    step = 1
    while True:

        # if old_word has correct spelling, break out of loop
        if wordnet.synsets(old_word):
            print( "Final correct word: " + old_word )
            break

        # remove one repeated character
        new_word = repeat_pattern.sub(repl = replacement_pattern, string = old_word)
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

