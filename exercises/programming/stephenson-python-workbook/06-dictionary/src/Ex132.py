
'''
dummy comment
'''

def getInfoPostalCode( postal_code ):

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    dict_province = {
        'A' : 'Newfoundland',
        'B' : 'Nova Scotia',
        'C' : 'Prince Edward Island',
        'E' : 'New Brunswick',
        'G' : 'Quebec',
        'H' : 'Quebec',
        'J' : 'Quebec',
        'K' : 'Ontario',
        'L' : 'Ontario',
        'M' : 'Ontario',
        'N' : 'Ontario',
        'P' : 'Ontario',
        'R' : 'Manitoba',
        'S' : 'Saskatchewan',
        'T' : 'Alberta',
        'V' : 'British Columbia',
        'X' : 'Nunavut',
        'X' : 'Northwest Territories',
        'Y' : 'Yukon'
        }

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    dict_classification = {}
    dict_classification[0] = 'rural'
    for i in range(1,10):
        dict_classification[i] = 'urban'

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    char1 = postal_code[0]
    char2 = postal_code[1]

    if char1 in dict_province.keys():
        province = dict_province[char1]
    else:
        province = None
        print( "ERROR: invalid postal code: " + str(postal_code) )

    classification = dict_classification[int(char2)]

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    output = {
        'province'        : province,
        'classificaitaon' : classification
        }

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( output )

def ex132():

    print("\n### ~~~~~ Exercise 132 ~~~~~~~~");

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    my_postal_codes = [
        'K1A 0B1',
        'H0H 0H0',
        'V9A 7N2',
        'A1A 1A1'
        ]

    for temp_postal_code in my_postal_codes:
        infoPostalCode = getInfoPostalCode( postal_code = temp_postal_code )
        print( "\npostal coce: " + str(temp_postal_code) )
        print(    "infoPostalCode:" )
        print( str(infoPostalCode)  )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

