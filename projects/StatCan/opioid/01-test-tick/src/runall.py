#!/usr/bin/env python

import os, stat, sys

thisScript = sys.argv[0]
srcDIR     = os.path.normpath(sys.argv[1])
datDIR     = os.path.normpath(sys.argv[2])
outDIR     = os.path.normpath(sys.argv[3])

# append module path with srcDIR
sys.path.append(srcDIR)

# change directory to outDIR
os.chdir(outDIR)

#################################################
#################################################
# import seaborn (for improved graphics) if available
import importlib
from importlib.util import find_spec
seaborn_spec = importlib.util.find_spec(name="seaborn")
if seaborn_spec is not None:
    import seaborn as sns

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
from testHawkesEM import test_HawkesEM
test_HawkesEM()

#################################################
#################################################
sys.exit(0)

