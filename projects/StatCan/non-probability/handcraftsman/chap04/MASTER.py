#!/usr/bin/env python

################################################################################
################################################################################
#
#  SYNOPSIS
#  ========
#
#  AUTHOR
#  ======
#  Kenneth Chu, ICMIC, Statistics Canada (kenneth.chu@canada.ca)
#
#  RELEASE DATE
#  ============
#  July 1, 2019
#
#  EXECUTION INSTRUCTIONS
#  ======================
#  For how to execute this pipeline (MASTER.py), follow the instructions in
#  the README file, namely:
#
#      ./README.md
#
#  INPUT
#  =====
#
#
#  OUTPUT
#  ======
#
#
################################################################################
################################################################################

import os, sys, shutil, getpass
import pprint, logging, datetime
import stat

# dynamically determine the absolute path of this Python program, and then
# relatively to it, those of the code, data and output folders
thisScript = os.path.realpath(sys.argv[0])
dir_MASTER = os.path.dirname(thisScript)
dir_code   = os.path.join(dir_MASTER, "code")
dir_data   = os.path.join(dir_MASTER, "data")
dir_output = os.path.join(dir_MASTER, "output." + getpass.getuser())

# create the output directory if not already exists
if not os.path.exists(dir_output):
    os.makedirs(dir_output)

# change directory to the output directory
os.chdir(dir_output)

# redirect output and error messages to file
sys.stdout = open('log.stdout','w')
sys.stderr = open('log.stderr','w')

# print system time to output file
myTime = "system time: " + datetime.datetime.now().strftime("%c")
print( "\n" + myTime + "\n" )
print("####################")

logging.basicConfig(filename='log.debug',level=logging.DEBUG)

# create a copy this program (MASTER.py) in output directory (for reproducibility)
shutil.copy2( src = thisScript, dst = dir_output )

# create a copy of code directory in output directory (for reproducibility)
shutil.copytree(src = dir_code, dst = os.path.join(dir_output,"code"))

# append code directory to list of library paths
# (to enable use of Python modules therein)
sys.path.append(dir_code)

##################################################
import seaborn as sns
import numpy   as np

from sklearn import tree
from pprint  import pprint

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
# import custom-built Python modules
import dtree

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
data = dtree.read_csv( os.path.join(dir_data,'census.csv') )
data = dtree.prepare_data(data,['Age'])

outcomeLabel = 'Born'

tree = dtree.build(data, outcomeLabel, validationPercentage=6)
print(tree)

testData = ['Elizabeth', 'female', 'Married', 19, 'Daughter']
predicted = tree.get_prediction(testData)
print("predicted: {}".format(predicted))

##################################################
print("\n####################\n")
myTime = "system time: " + datetime.datetime.now().strftime("%c")
print( myTime + "\n" )

