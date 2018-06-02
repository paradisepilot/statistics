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
import nltk

from TextTokenization import sentenceTokenization

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
# install gutenberg corpus if not yet installed
try:
    nltk.data.find('corpora/gutenberg')
except LookupError:
    nltk.download('gutenberg')

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
sentenceTokenization()

#################################################
#################################################
print( "\n\n###############################" )
print( "\n#### system time: " + str(datetime.datetime.now()) + "\n" )
sys.exit(0)

