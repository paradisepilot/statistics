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

from Ex128 import ex128
from Ex129 import ex129
from Ex132 import ex132
from Ex133 import ex133
from Ex134 import ex134
from Ex135 import ex135
from Ex136 import ex136
from Ex137 import ex137
from Ex138 import ex138

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
#ex128()
#ex129()
#ex132()
#ex133()
#ex134()
#ex135()
#ex136()
#ex137()
ex138()

#################################################
#################################################
print( "\n\n###############################" )
print( "\n#### system time: " + str(datetime.datetime.now()) + "\n" )
sys.exit(0)

