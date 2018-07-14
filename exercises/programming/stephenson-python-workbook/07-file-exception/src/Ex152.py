
'''
dummy comment
'''

import os, pandas
from random import sample

class ElementOracle:

    def __init__( self , file_chemical_elements ):
        DF_chemical_elements = pandas.read_csv( file_chemical_elements )
        self.dict_Z, self.dict_symbol, self.dict_element = self.getDictionaries( DF_chemical_elements )

    def camelCase( self , inputString ):
        return( ''.join([inputString[0].upper(),inputString[1:].lower()]) )

    def getDictionaries( self, DF_input ):
        dict_Z       = {}
        dict_symbol  = {}
        dict_element = {}
        for i in range(DF_input.shape[0]):
            tempRow     = dict( DF_input.iloc[i] )
            tempZ       = tempRow['Z']
            tempSymbol  = tempRow['Symbol']
            tempElement = tempRow['Element']
            dict_Z[      tempZ      ] = { 'symbol':tempSymbol , 'element':tempElement }
            dict_symbol[ tempSymbol ] = { 'Z':tempZ ,           'element':tempElement }
            dict_element[tempElement] = { 'Z':tempZ,            'symbol' :tempSymbol  }
        return( dict_Z , dict_symbol , dict_element )

    def getElement( self , tempkey ):
        if isinstance(tempkey,int):
            if tempkey in self.dict_Z.keys():
                return( self.dict_Z[tempkey] )
            else:
                return( {} )
        else:
            tempkey = self.camelCase(str(tempkey))
            if   tempkey in self.dict_symbol.keys():
                return( self.dict_symbol[tempkey] )
            elif tempkey in self.dict_element.keys():
                return( self.dict_element[tempkey] )
            else:
                return( {} )

def ex152( datDIR ):

    print("\n### ~~~~~ Exercise 152 ~~~~~~~~");

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    csv_chemical_elements = os.path.join( datDIR, 'chemical-elements.csv' )
    elementOracle = ElementOracle( file_chemical_elements = csv_chemical_elements )

    temp_element = elementOracle.getElement(2)
    print( temp_element )

    temp_element = elementOracle.getElement('Oxygen')
    print( temp_element )

    temp_element = elementOracle.getElement('Cl')
    print( temp_element )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

