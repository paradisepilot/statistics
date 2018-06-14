
'''
dummy comment
'''

from gensim.models import Word2Vec

###################################################
def testWord2Vec():

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    sentences = [
        ['this', 'is', 'the', 'first', 'sentence', 'for', 'word2vec'],
        ['this', 'is', 'the', 'second', 'sentence'],
        ['yet', 'another', 'sentence'],
        ['one', 'more', 'sentence'],
        ['and', 'the', 'final', 'sentence']
        ]

    # train model
    model = Word2Vec(sentences, min_count = 1)

    # summarize the loaded model
    print( "\n\n### model:" )
    print(model)

    # summarize vocabulary
    words = list(model.wv.vocab)
    print( "\n\n### words:" )
    print(words)

    # access vector for one word
    print( "\n\n### model['sentence']:" )
    print(model['sentence'])

    # save model
    model.save('model.bin')

    # load model
    new_model = Word2Vec.load('model.bin')
    print( "\n\n### new_model:" )
    print(new_model)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

