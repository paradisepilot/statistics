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
#  This pipeline contains a single (input) tabular data file in CSV format:
#
#    1)  ./data/housing.csv
#
#        This CSV file contains 20640 non-header rows. Each row contains data
#        for a census block group from the 1990 California census data. This
#        file contains columns with the following headers:
#
#            longitude
#            latitude
#            housing_median_age
#            total_rooms
#            total_bedrooms
#            population
#            households
#            median_income
#            median_house_value
#            ocean_proximity
#
#        The (continuous) variable "median_house_value" will be used as the
#        response variable for the regression exercises performed by this
#        pipeline. The rest of the variables will be used as predictor
#        variables.
#
#  OUTPUT
#  ======
#  Upon execution, MASTER.py first creates the following output directory:
#  ./output.<username>. When execution finishes without errors, the newly
#  created output directory will contain the following:
#
#    1)  ./output.<username>/MASTER.py
#        a copy of ./MASTER.py (for reproducibility)
#
#    2)  ./output.<username>/code
#        a copy of the code directory ./code (for reproducibility)
#
#    3)  ./output.<username>/log.debug
#        debugging log file (should be empty)
#
#    4)  ./output.<username>/log.stderr
#        standard error log file (should be empty)
#
#    5)  ./output.<username>/log.stdout
#        main output text file of the pipeline.
#        It starts with summary and exploratory statistics of the input file,
#        followed by model-fitting performance metrics of the aforementioned
#        implemented machine learnign techniques.
#
#    6)  ./output.<username>/plot-histograms.png
#        histograms of the nine continuous variables
#
#    7)  ./output.<username>/plot-scatter.png
#        bubble heat map illustrating census block group population sizes and
#        median house values according to geocoordinates
#
#    8)  ./output.<username>/plot-correlations.png
#        correlation matrix for four continuous variables
#
#    9)  ./output.<username>/plot-medianIncome.png
#        scatter plot of median_house_value vs median_income
#
#   10)  ./output.<username>/plot-correlations-02.png
#        correlation matrix involving two existing variables and derived
#        variables
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
# import seaborn (for improved graphics) if available
import importlib
from importlib.util import find_spec
seaborn_spec = importlib.util.find_spec(name="seaborn")
if seaborn_spec is not None:
    import seaborn as sns

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
import numpy  as np
import pandas as pd
import random

from sklearn import tree

# import custom-built Python modules
from treeKLDavenport import *

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
my_data = [
    ['slashdot' ,'USA'        ,'yes',18,'None'   ],
    ['google'   ,'France'     ,'yes',23,'Premium'],
    ['reddit'   ,'USA'        ,'yes',24,'Basic'  ],
    ['kiwitobes','France'     ,'yes',23,'Basic'  ],
    ['google'   ,'UK'         ,'no' ,21,'Premium'],
    ['(direct)' ,'New Zealand','no' ,12,'None'   ],
    ['(direct)' ,'UK'         ,'no' ,21,'Basic'  ],
    ['google'   ,'USA'        ,'no' ,24,'Premium'],
    ['slashdot' ,'France'     ,'yes',19,'None'   ],
    ['reddit'   ,'USA'        ,'no' ,18,'None'   ],
    ['google'   ,'UK'         ,'no' ,18,'None'   ],
    ['kiwitobes','UK'         ,'no' ,19,'None'   ],
    ['reddit'   ,'New Zealand','yes',12,'Basic'  ],
    ['slashdot' ,'UK'         ,'no' ,21,'None'   ],
    ['google'   ,'UK'         ,'yes',18,'Basic'  ],
    ['kiwitobes','France'     ,'yes',19,'Basic'  ]
    ]

my_data2 = [
    ['slashdot' ,'USA'        ,'yes',18,'None' ],
    ['google'   ,'France'     ,'yes',23,'None' ],
    ['reddit'   ,'USA'        ,'yes',24,'Basic'],
    ['kiwitobes','France'     ,'yes',23,'Basic'],
    ['google'   ,'UK'         ,'no' ,21,'None' ],
    ['(direct)' ,'New Zealand','no' ,12,'None' ],
    ['(direct)' ,'UK'         ,'no' ,21,'Basic']
    ]

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
printtree( buildtree(my_data) )

##################################################
print("\n####################\n")
myTime = "system time: " + datetime.datetime.now().strftime("%c")
print( myTime + "\n" )

