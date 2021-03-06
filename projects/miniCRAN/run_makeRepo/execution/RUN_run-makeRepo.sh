#!/bin/bash

currentDIR=`pwd`
parentDIR="$(dirname "$currentDIR")"
  codeDIR=${parentDIR}/code
outputDIR=${parentDIR//github/gittmp}/output

if [ ! -d ${outputDIR} ]; then
	mkdir -p ${outputDIR}
fi

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
rpackagesFILE=Rpackages.yml

##################################################
myRscript=${codeDIR}/run_makeRepo.R
stdoutFile=stdout.R.`basename ${myRscript} .R`
R --no-save --args ${codeDIR} ${outputDIR} ${rpackagesFILE} < ${myRscript} 2>&1 > ${stdoutFile}

##################################################
exit

