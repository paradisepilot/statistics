
'''
dummy comment
'''

import os, re, pandas

from DownloadFiles import getBabyNames

def getIncludedNames( DF_babyNames , start_year , end_year , sex ):
    is_included = (start_year <= DF_babyNames['year']) & (DF_babyNames['year'] <= end_year) & (DF_babyNames['sex'] == sex )
    DF_temp     = DF_babyNames[is_included]
    #print("DF_temp[:10]")
    #print( DF_temp[:10] )
    max_percent = max(DF_temp['percent'])
    is_max      = (DF_temp['percent'] == max_percent)
    DF_output   = DF_temp[is_max]
    return( DF_output )

def ex156( datDIR , start_year , end_year ):

    print("\n### ~~~~~ Exercise 156 ~~~~~~~~");

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    BabyNamesFILE = os.path.join(datDIR,"baby-names.csv")
    getBabyNames( BabyNamesFILE = BabyNamesFILE )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF_babyNames = pandas.read_csv( BabyNamesFILE )
    #print( "DF_babyNames.shape: " + str(DF_babyNames.shape) )
    #print("DF_babyNames[:10]")
    #print( DF_babyNames[:10] )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    sexes = [ 'boy' , 'girl' ]
    for sex in sexes:
        tempBabyNames = getIncludedNames(
            DF_babyNames = DF_babyNames,
            start_year   = start_year,
            end_year     = end_year ,
            sex          = sex
            )
        print("\nmost popular name for " + sex + "s:" )
        print(   tempBabyNames )
        #print( "\nyear: " + str(year) + ", names: " + str(tempBabyNames) )
        #print( "\nyear: " + str(year) )
        #i = 0
        #for tempname in tempBabyNames:
        #    i += 1
        #    print( "%5d: %15s" % (i,tempname) )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

