
'''
dummy comment
'''

def ex104(input_list):

    print("\n### ~~~~~ Exercise 104 ~~~~~~~~");

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print( "\ninput_list: " + str(input_list) + "\n" )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    sorted_list = input_list;
    sorted_list.sort();

    for item in sorted_list:
        print( str(item) )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

