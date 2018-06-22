
'''
dummy comment
'''

def ex105(input_list):

    print("\n### ~~~~~ Exercise 105 ~~~~~~~~");

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print( "\ninput_list: " + str(input_list) + "\n" )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    sorted_list = input_list;
    sorted_list.sort( reverse = True );

    for item in sorted_list:
        print( str(item) )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

