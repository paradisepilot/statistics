
'''
dummy comment
'''

def ex074( n ):

    print("\n### ~~~~~ Exercise 074 ~~~~~~~~");

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print( "     |" , end = "" )
    for j in range(1,n+1):
        print( "%4d" % (j) , end = "" )
    print("")

    print( "------" , end = "" )
    for j in range(1,n+1):
        print( "%4s" % ('----') , end = "" )
    print("")

    for i in range(1,n+1):
        print( "%4d |" % i , end = "" )
        for j in range(1,n+1):
            print( "%4d" % (i * j) , end= "" )
        print("")

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

