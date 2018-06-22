
'''
dummy comment
'''

def ex107(input_list):

    print("\n### ~~~~~ Exercise 107 ~~~~~~~~");

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print( "\ninput_list: " + str(input_list) + "\n" )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    myDictionary = {}
    return_list = [ myDictionary.setdefault(x,x) for x in input_list if x not in myDictionary ]

    print( "return_list: " + str(return_list) + "\n" )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

