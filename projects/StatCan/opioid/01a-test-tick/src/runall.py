#!/usr/bin/env python

import os, stat, sys

thisScript = sys.argv[0]
srcDIR     = os.path.normpath(sys.argv[1])
outDIR     = os.path.normpath(sys.argv[2])

# append module path with srcDIR
sys.path.append(srcDIR)

# change directory to outDIR
os.chdir(outDIR)

#################################################
#################################################

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
from testHawkesEM import test_HawkesEM
test_HawkesEM()

#################################################
#################################################
sys.exit(0)

