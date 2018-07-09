
'''
dummy comment
'''

def ex106(input_list, nToRemove):

    print("\n### ~~~~~ Exercise 106 ~~~~~~~~");

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print( "\ninput_list: " + str(input_list) + "\n" )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    sorted_list = input_list;
    sorted_list.sort();
    sorted_list = sorted_list[nToRemove:len(sorted_list)-nToRemove];

    for item in sorted_list:
        print( str(item) )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

