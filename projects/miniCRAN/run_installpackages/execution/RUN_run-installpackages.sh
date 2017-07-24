#!/bin/bash

currentDIR=`pwd`
parentDIR="$(dirname "$currentDIR")"
  codeDIR=${parentDIR}/code
outputDIR=${parentDIR//github/gittmp}/output

if [ ! -d ${outputDIR} ]; then
	mkdir -p ${outputDIR}
fi

cp -r ${codeDIR} ${outputDIR}

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
rpackagesFILE=Rpackages-desired.txt

##################################################
myRscript=${codeDIR}/run_installpackages.R
stdoutFile=${outputDIR}/stdout.R.`basename ${myRscript} .R`
R --no-save --args ${codeDIR} ${outputDIR} ${rpackagesFILE} < ${myRscript} 2>&1 > ${stdoutFile}

##################################################
exit

