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
lineCount = 0
for i in range(3,len(sys.argv)):
    tempFILE = sys.argv[i]
    if not os.path.isfile( tempFILE ):
        print( "Error: file not found, hence ignored: " + tempFILE )
    else:
        with open( file = tempFILE , mode = 'r' ) as f:
            for N, tempLine in enumerate(f):
                lineCount += 1
                tempLine = tempLine.rstrip()
                print( "line %6d: " % (lineCount) , end = "" )
                print( tempLine )

#################################################
customExit()

