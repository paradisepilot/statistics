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
# from section5pt1 import section5pt1
# section5pt1()

dir_chollet  = os.path.dirname(datDIR)
dir_original = os.path.join(dir_chollet,"10-raw",    "dogs-vs-cats","train")
dir_derived  = os.path.join(dir_chollet,"20-derived","dogs-vs-cats")

from section5pt2 import section5pt2
section5pt2(
    dir_original = dir_original,
    dir_derived  = dir_derived
    )

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###

#################################################
#################################################
sys.exit(0)

