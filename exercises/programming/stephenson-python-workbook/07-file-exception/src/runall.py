#!/usr/bin/env python

import os, stat, sys

thisScript = sys.argv[0]
srcDIR     = sys.argv[1]
datDIR     = sys.argv[2]
outDIR     = sys.argv[3]

import datetime
print( "\n#### system time: " + str(datetime.datetime.now()) )
print( "\n###############################\n" )

# append module path with srcDIR
sys.path.append(srcDIR)

# change directory to outDIR
os.chdir(outDIR)

#################################################
#################################################
import seaborn as sns

from Ex141 import ex141
from Ex150 import ex150
from Ex151 import ex151
from Ex152 import ex152

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
#ex141( datDIR = datDIR )
#ex150(
#     inputFILE = os.path.join(outDIR,'src','runall.py'),
#    outputFILE = "runall-nocomments.py"
#    )
#ex151()
ex152( datDIR = datDIR )

#################################################
#################################################
print( "\n\n###############################" )
print( "\n#### system time: " + str(datetime.datetime.now()) + "\n" )
sys.exit(0)

