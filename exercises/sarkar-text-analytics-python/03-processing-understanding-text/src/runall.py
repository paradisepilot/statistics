#!/usr/bin/env python

import os, stat, sys

thisScript = sys.argv[0]
srcDIR     = sys.argv[1]
datDIR     = sys.argv[2]
outDIR     = sys.argv[3]

import datetime
print( "\n\n#### system time: " + str(datetime.datetime.now()) )
print( "\n###############################\n" )

# append module path with srcDIR
sys.path.append(srcDIR)

# change directory to outDIR
os.chdir(outDIR)

#################################################
#################################################
import seaborn as sns

from InstallNLTKResources import installNLTKResources
from TextTokenization     import sentenceTokenization, wordTokenization
from TextNormalization    import textNormalization

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
installNLTKResources()

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
### Text Tokenization
# sentenceTokenization()
# wordTokenization()

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
### Text Normalization
textNormalization()

#################################################
#################################################
print( "\n\n###############################" )
print( "\n#### system time: " + str(datetime.datetime.now()) + "\n" )
sys.exit(0)

