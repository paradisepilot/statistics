
'''
dummy comment
'''

import os, re, pandas

from DownloadFiles import getBabyNames

def ex154( datDIR ):

    print("\n### ~~~~~ Exercise 154 ~~~~~~~~");

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    BabyNamesFILE = os.path.join(datDIR,"baby-names.csv")
    getBabyNames( BabyNamesFILE = BabyNamesFILE )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF_babyNames = pandas.read_csv( BabyNamesFILE )
    print( "DF_babyNames.shape: " + str(DF_babyNames.shape) )
    print("DF_babyNames[:10]")
    print( DF_babyNames[:10] )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF_year_sex = DF_babyNames.loc[:,['year','sex']].drop_duplicates()
    DF_year_sex['most_popular_name'] = ""
    DF_year_sex['percent'] = -999.999
    for i in range(DF_year_sex.shape[0]):
        tempRow  = dict( DF_year_sex.iloc[i] )
        tempYear = tempRow['year']
        tempSex  = tempRow['sex']
        DF_temp  = DF_babyNames[(DF_babyNames['year'] == tempYear) & (DF_babyNames['sex'] == tempSex)]
        tempMax  = max( DF_temp['percent'] )
        tempName = DF_temp[DF_temp['percent'] == tempMax]['name'].values[0]
        DF_year_sex['most_popular_name'].values[i] = tempName
        DF_year_sex['percent'].values[i] = tempMax
        print( str(tempYear) + ", " + tempSex + ": " + str(tempName) + ", " + str(tempMax) )

    #print("DF_year_sex")
    #print( DF_year_sex )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

