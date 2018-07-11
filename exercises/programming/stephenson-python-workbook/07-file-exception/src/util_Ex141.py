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
    for i in range(0,10):
        tempLine = f.readline()
        tempLine = re.sub(string = tempLine, pattern = "\n$", repl = "")
        print( "line %2d: " % (i+1) , end = "" )
        print( tempLine )

#################################################
customExit()

