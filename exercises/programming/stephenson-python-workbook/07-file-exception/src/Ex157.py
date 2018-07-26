
'''
dummy comment
'''

import os, re, pandas

from DownloadFiles import getBabyNames

def getDistinctNames( DF_babyNames , sex ):
    is_included    = ( DF_babyNames['sex'] == sex )
    distinct_names = set( DF_babyNames[is_included]['name'] )
    return( sorted(distinct_names) )

def ex157( datDIR ):

    print("\n### ~~~~~ Exercise 157 ~~~~~~~~");

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    BabyNamesFILE = os.path.join(datDIR,"baby-names.csv")
    getBabyNames( BabyNamesFILE = BabyNamesFILE )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF_babyNames = pandas.read_csv( BabyNamesFILE )
    print( "DF_babyNames.shape: " + str(DF_babyNames.shape) )
    print("DF_babyNames[:10]")
    print( DF_babyNames[:10] )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    sexes = [ 'boy' , 'girl' ]
    for sex in sexes:
        distinctNames = getDistinctNames(
            DF_babyNames = DF_babyNames,
            sex          = sex
            )
        print("\ndistinct names for " + sex + "s:" )
        print(   distinctNames )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

