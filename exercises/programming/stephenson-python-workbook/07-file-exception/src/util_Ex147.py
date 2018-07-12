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

wordFrequencies = {}
with open( file = inputFILE , mode = 'r' ) as inF:
    for i, tempLine in enumerate(inF):

        tempLine = tempLine.rstrip()
        tempLine = tempLine.lower()

        tempLine = re.sub( string = tempLine, pattern = 'http://[/0-9a-z\.]+\s',         repl = "" )
        tempLine = re.sub( string = tempLine, pattern = 'ftp://[/0-9a-z\.]+\s',          repl = "" )
        tempLine = re.sub( string = tempLine, pattern = 'www\.[/0-9a-z\.]+\.(net|org),', repl = "" )
        tempLine = re.sub( string = tempLine, pattern = 'EBOOKS\*Ver\.02/11/02\*END\*',  repl = "" )
        tempLine = re.sub( string = tempLine, pattern = "file\('big\.txt'\)\.read\(\)",  repl = "" )

        tempLine = re.sub( string = tempLine, pattern = "[^a-z'\s]", repl = "" )
        tempLine = re.sub( string = tempLine, pattern = "( '|' )",   repl = " ")
        tempLine = tempLine.strip()

        if len(tempLine) > 0:
            tempwords = tempLine.split(' ')
            for tempword in tempwords:
                if tempword != "":
                    if tempword in wordFrequencies.keys():
                        wordFrequencies[tempword] += 1
                    else:
                        wordFrequencies[tempword] = 1

#maxFrequency = max( [ tempvalue for tempvalue in wordFrequencies.values() ] )
#sorted_keys  = [ tempkey for tempkey in wordFrequencies.keys() if wordFrequencies[tempkey] == maxFrequency ]
#for tempkey in sorted_keys:
#    print( tempkey + ": " + str(wordFrequencies[tempkey]) )

wordFrequencies = { r:wordFrequencies[r] for r in sorted(wordFrequencies, key=wordFrequencies.get, reverse=True) }
for tempkey in wordFrequencies.keys():
    print( tempkey + ": " + str(wordFrequencies[tempkey]) )

#################################################
customExit()

