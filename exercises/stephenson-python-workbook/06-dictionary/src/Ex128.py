
'''
dummy comment
'''

def reverseLookup( dictionary, value ):
    output = []
    for k in dictionary.keys():
        if value == dictionary[k]:
            output.append(k)
    return( output )

def ex128():

    print("\n### ~~~~~ Exercise 128 ~~~~~~~~");

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    my_dictionary = {
        'john'    : 1,
        'mary'    : 1,
        'josephy' : 0,
        'anita'   : 0,
        'alan'    : 0,
        'leslie'  : 1,
        'sally'   : 1,
        'mark'    : 1,
        'matthew' : 0,
        'peter'   : 0,
        'paul'    : 1,
        'michael' : 1
        }

    print(  "\nmy_dictionary:" )
    print( str(my_dictionary)  )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    my_keys = reverseLookup( dictionary = my_dictionary, value = 1 )

    print(  "\nmy_keys:" )
    print( str(my_keys)  )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

