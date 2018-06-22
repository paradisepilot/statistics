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

from Ex104 import ex104
from Ex105 import ex105
from Ex106 import ex106
from Ex107 import ex107
from Ex108 import ex108

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
ex104(input_list = [10,9,8,7,6,5,4,3,2,1])
ex105(input_list = [3,9,6,8,1,10,2,7,4,5])
ex106(input_list = [3,9,6,8,1,10,2,7,4,5], nToRemove = 3)

ex107(
    input_list = [
        'first','second','first','third','second'
        ]
    )

ex108(input_list = [3, -4, 1, 0, -1, 0, -2])

#################################################
#################################################
print( "\n\n###############################" )
print( "\n#### system time: " + str(datetime.datetime.now()) + "\n" )
sys.exit(0)

