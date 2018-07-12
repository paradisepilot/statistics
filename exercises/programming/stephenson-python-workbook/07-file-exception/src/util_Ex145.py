#!/usr/bin/env python

import datetime, sys, os, re

#################################################
def customExit():
    print( "\n###############################" )
    print( "\n#### system time: " + str(datetime.datetime.now()) + "\n" )
    sys.exit(0)

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
print( "\n#### system time: " + str(datetime.datetime.now()) )
print( "\n###############################\n" )

len_sys_argv = len(sys.argv)
if len_sys_argv < 4:
    print( "Error: Expecting at least four arguments but instead got " + str(len_sys_argv-1) )
    customExit()

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
thisScript = sys.argv[0]
inputFILE  = sys.argv[1]
outDIR     = sys.argv[2]

# change directory to outDIR
os.chdir(outDIR)

#################################################
if not os.path.isfile( inputFILE ):
    print( "Error: file not found, hence ignored: " + tempFILE )
    customExit()

recordLength  = 0
recordHolders = {}
with open( file = inputFILE , mode = 'r' ) as inF:
    for i, tempLine in enumerate(inF):

        tempLine = tempLine.rstrip()

        tempLine = re.sub( string = tempLine, pattern = "\+-+",   repl = "" )
        tempLine = re.sub( string = tempLine, pattern = "_--_",   repl = " ")
        tempLine = re.sub( string = tempLine, pattern = "--",     repl = " ")
        tempLine = re.sub( string = tempLine, pattern = "\.{3,}", repl = " ")
        tempLine = re.sub( string = tempLine, pattern = 'http://[/0-9a-z\.]+', repl = "")
        tempLine = re.sub( string = tempLine, pattern = 'ftp://[/0-9a-z\.]+',  repl = "")
        tempLine = re.sub( string = tempLine, pattern = 'Hofs-kriegs-wurst-schnapps-Rath', repl = "")

        tempLine = re.sub(
            string  = tempLine,
            pattern = 'house-divided-against-itself',
            repl    = "house divided against itself"
            )

        tempLine = re.sub(
            string  = tempLine,
            pattern = 'dioxydiamido-arseno-benzol',
            repl    = "dioxydiamido arseno benzol"
            )

        tempLine = re.sub(
            string  = tempLine,
            pattern = 'le-trip-ta-la-de-bu-de-ba',
            repl    = "le trip ta la de bu de ba"
            )

        tempLine = re.sub(
            string  = tempLine,
            pattern = '\(_lymphangiectasis_\);',
            repl    = "lymphangiectasis"
            )

        tempLine = re.sub(
            string  = tempLine,
            pattern = '\(www\.gutenberg\.(net|org)\),',
            repl    = ""
            )

        tempLine = re.sub( string = tempLine, pattern = 'EBOOKS\*Ver\.02/11/02\*END\*', repl = "")
        tempLine = re.sub( string = tempLine, pattern = "file\('big\.txt'\)\.read\(\)", repl = "")
        tempLine = re.sub( string = tempLine, pattern = "(@|-|_|/|\.|,|#)", repl = " ")

        tempwords      = tempLine.split(' ')
        recordBreakers = [ tempword for tempword in tempwords if len(tempword) > recordLength ]
        if len(recordBreakers) > 0:
            recordLength  = max( [ len(tempword) for tempword in recordBreakers ] )
            recordHolders = { tempword for tempword in recordBreakers if len(tempword) == recordLength }
        else:
            recordMatchers = { tempword for tempword in tempwords if len(tempword) == recordLength }
            if len(recordMatchers) > 0:
                recordHolders = recordHolders.union( recordMatchers )

recordHolders = list(recordHolders)
recordHolders.sort()

print( "record length: " + str(recordLength) )
print( "record holders:" )
print( recordHolders )

#################################################
customExit()

