#!/bin/bash

currentDIR=`pwd`
parentDIR="$(dirname "$currentDIR")"
  codeDIR=${parentDIR}/code
outputDIR=${parentDIR//github/gittmp}/output

if [ ! -d ${outputDIR} ]; then
	mkdir -p ${outputDIR}
fi

packageDIR=${parentDIR}
packageDIR="$(dirname "$packageDIR")"
packageDIR=${packageDIR}/001-StatCan-linkAdjust/StatCan.linkAdjust/R

##################################################
myRscript=${codeDIR}/simulation-01.R
stdoutFile=stdout.R.`basename ${myRscript} .R`
R --no-save --args ${codeDIR} ${packageDIR} ${outputDIR} < ${myRscript} 2>&1 > ${stdoutFile}

##################################################
exit

