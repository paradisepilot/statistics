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
from Ex153 import ex153
from Ex154 import ex154
from Ex155 import ex155
from Ex156 import ex156

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
#ex141( datDIR = datDIR )
#ex150(
#     inputFILE = os.path.join(outDIR,'src','runall.py'),
#    outputFILE = "runall-nocomments.py"
#    )
#ex151()
#ex152( datDIR = datDIR )
#ex153( datDIR = datDIR )
#ex154( datDIR = datDIR )
#ex155( datDIR = datDIR )
ex156( datDIR = datDIR , start_year = 1972 , end_year = 1989 )

#################################################
#################################################
print( "\n\n###############################" )
print( "\n#### system time: " + str(datetime.datetime.now()) + "\n" )
sys.exit(0)

