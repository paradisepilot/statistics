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
outputFILE = sys.argv[3]

# change directory to outDIR
os.chdir(outDIR)

#################################################
if not os.path.isfile( inputFILE ):
    print( "Error: file not found: " + inputFILE )
else:
    lineCount = 0
    with open( file = inputFILE , mode = 'r' ) as inF:
        with open( file = outputFILE , mode = 'w' ) as outF:
            for N, tempLine in enumerate(inF):
                lineCount += 1
                tempLine = tempLine.rstrip()
                print( "line %6d: " % (lineCount), file = outF, end = "" )
                print( tempLine, file = outF )

#################################################
customExit()

