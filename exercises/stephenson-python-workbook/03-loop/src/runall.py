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

from Ex062 import ex062
from Ex069 import ex069
from Ex070 import ex070
from Ex071 import ex071
from Ex074 import ex074
from Ex075 import ex075
from Ex076 import ex076
from Ex077 import ex077
from Ex078 import ex078
from Ex080 import ex080

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
#ex062()
#ex069()
#ex070()
#ex071()
#ex074( n = 10 )
#ex075()
#ex076()
#ex077()
#ex078()
ex080()

#################################################
#################################################
print( "\n\n###############################" )
print( "\n#### system time: " + str(datetime.datetime.now()) + "\n" )
sys.exit(0)

