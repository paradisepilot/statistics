
'''
dummy comment
'''

def ex108(input_list):

    print("\n### ~~~~~ Exercise 108 ~~~~~~~~");

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print( "\ninput_list: " + str(input_list) + "\n" )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    positives = []
    zeros     = []
    negatives = []

    for item in input_list:
        if item > 0:
            positives.append(item)
        elif item == 0:
            zeros.append(item)
        else:
            negatives.append(item)

    return_list = negatives + zeros + positives

    print( "return_list: " + str(return_list) + "\n" )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

