
'''
dummy comment
'''

def showTable_discountedPrices( productPrices , discount ):

    sorted_keys = list(productPrices.keys())
    sorted_keys.sort()

    maxLength_productName = max(10,max([ len(key) for key in productPrices.keys() ]))
    format_header         = "%"+ str(maxLength_productName+2) +"s %10s %10s"
    format_body           = "%"+ str(maxLength_productName+2) +"s %10.2f %10.2f"

    print( format_header % ('product', 'original', 'discounted') )
    for key in sorted_keys:
        price_original   = productPrices[key]
        price_discounted = price_original * (1 - discount)
        print( format_body % (key,price_original,price_discounted) )

    return( None )

def ex062():

    print("\n### ~~~~~ Exercise 062 ~~~~~~~~");

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    productPrices = {
        'oranges' :  9.95,
        'bananas' : 14.95,
        'melos'   : 19.95,
        'berries' : 24.95,
        'apples'  :  4.95
        }

    showTable_discountedPrices(
        productPrices = productPrices,
        discount      = 0.6
        )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

