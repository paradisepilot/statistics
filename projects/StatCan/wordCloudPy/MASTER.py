#!/usr/bin/env python

import os, sys, shutil, getpass
import stat

thisScript = sys.argv[0]
dir_MASTER = os.path.dirname(os.path.realpath(sys.argv[0]))
dir_code   = os.path.join(dir_MASTER, "code")
dir_output = os.path.join(dir_MASTER, "output." + getpass.getuser())

if not os.path.exists(dir_output):
    os.makedirs(dir_output)

shutil.copy( os.path.join(dir_MASTER,thisScript), dir_output )

#srcDIR     = sys.argv[1]
#datDIR     = sys.argv[2]
#outDIR     = sys.argv[3]

print('\nthisScript')
print(   thisScript )

print('\ndir_code')
print(   dir_code )

print('\ndir_output')
print(   dir_output )
