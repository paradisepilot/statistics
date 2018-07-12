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

letterFrequencies = {}
with open( file = inputFILE , mode = 'r' ) as inF:
    for i, tempLine in enumerate(inF):

        tempLine = tempLine.rstrip().lower()
        tempLine = re.sub( string = tempLine, pattern = '[^a-z]', repl = "")

        tempchars = list(tempLine)
        if len(tempchars) > 0:
            for tempchar in tempchars:
                if tempchar in letterFrequencies.keys():
                    letterFrequencies[tempchar] += 1
                else:
                    letterFrequencies[tempchar] = 1

maxLength = max([ len(str(tempvalue)) for tempvalue in letterFrequencies.values() ])
nLetters  = sum([         tempvalue   for tempvalue in letterFrequencies.values() ])

print( "letter frequencies:" )
#print( letterFrequencies )
sorted_keys = list(letterFrequencies.keys())
sorted_keys.sort()
for tempkey in sorted_keys:
    formatString = "%2s: %"+str(maxLength)+"d, %6.4f"
    tempvalue = letterFrequencies[tempkey]
    print( formatString % (tempkey,tempvalue,tempvalue/nLetters) )

#################################################
customExit()

