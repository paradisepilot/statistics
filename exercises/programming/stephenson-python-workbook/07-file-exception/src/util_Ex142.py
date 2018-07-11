#!/usr/bin/env python

import datetime, sys, os, re

#################################################
nLines = 10

def customExit():
    print( "\n###############################" )
    print( "\n#### system time: " + str(datetime.datetime.now()) + "\n" )
    sys.exit(0)

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
print( "\n#### system time: " + str(datetime.datetime.now()) )
print( "\n###############################\n" )

if len(sys.argv) < 3:
    print( "Error: Expecting two arguments but instead got " + str(len(sys.argv)-1) )
    customExit()

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
thisScript = sys.argv[0]
inputFILE  = sys.argv[1]
outDIR     = sys.argv[2]

# change directory to outDIR
os.chdir(outDIR)

#################################################
if not os.path.isfile( inputFILE ):
    print( "Error: file not found: " + inputFILE )
    customExit()

with open( file = inputFILE , mode = 'r' ) as f:
    lines = []
    for N, tempLine in enumerate(f):
        tempLine = tempLine.rstrip()
        lines.append(tempLine)
        if N > (nLines-1):
            lines.pop(0)

N = N + 1
for i in range(0,len(lines)):
    tempLine = lines[i]
    print( "line %6d: " % (N - nLines + i + 1) , end = "" )
    print( tempLine )

#################################################
customExit()

