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
    i = 0
    tempLine = f.readline()
    while i < nLines and tempLine != "":
        i += 1
        # tempLine = re.sub(string = tempLine, pattern = "\n$", repl = "")
        tempLine = tempLine.rstrip()
        print( "line %2d: " % (i) , end = "" )
        print( tempLine )
        tempLine = f.readline()

#################################################
customExit()

