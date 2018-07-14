
'''
dummy comment
'''

import os, re, pandas

from DownloadFiles import getBabyNames

def getGenderNeutralNames( DF_babyNames , year ):
    boy_names  = set(DF_babyNames[(DF_babyNames['year'] == year) & (DF_babyNames['sex'] == 'boy' )]['name'])
    girl_names = set(DF_babyNames[(DF_babyNames['year'] == year) & (DF_babyNames['sex'] == 'girl')]['name'])
    gender_neutral_names = boy_names.intersection( girl_names )
    return( gender_neutral_names )

def ex155( datDIR ):

    print("\n### ~~~~~ Exercise 155 ~~~~~~~~");

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    BabyNamesFILE = os.path.join(datDIR,"baby-names.csv")
    getBabyNames( BabyNamesFILE = BabyNamesFILE )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF_babyNames = pandas.read_csv( BabyNamesFILE )
    print( "DF_babyNames.shape: " + str(DF_babyNames.shape) )
    print("DF_babyNames[:10]")
    print( DF_babyNames[:10] )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    years = [ 1972 , 1973, 2000, 2005 ]
    for year in years:
        tempBabyNames = getGenderNeutralNames( DF_babyNames = DF_babyNames , year = year )
        tempBabyNames = sorted(tempBabyNames)
        #print( "\nyear: " + str(year) + ", names: " + str(tempBabyNames) )
        print( "\nyear: " + str(year) )
        i = 0
        for tempname in tempBabyNames:
            i += 1
            print( "%5d: %15s" % (i,tempname) )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

