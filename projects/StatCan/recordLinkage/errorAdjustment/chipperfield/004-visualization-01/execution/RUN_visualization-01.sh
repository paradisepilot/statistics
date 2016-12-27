#!/bin/bash

currentDIR=`pwd`
parentDIR="$(dirname "$currentDIR")"
  codeDIR=${parentDIR}/code
outputDIR=${parentDIR//github/gittmp}/output

if [ ! -d ${outputDIR} ]; then
	mkdir -p ${outputDIR}
fi

cp -r ${codeDIR} ${outputDIR}

packageDIR=${parentDIR}
packageDIR="$(dirname "$packageDIR")"
packageDIR=${packageDIR}/001-StatCan-linkAdjust/StatCan.linkAdjust/R

inputDIR=${parentDIR}
inputDIR="$(dirname "$inputDIR")"
inputDIR=${inputDIR//github/gitdat}/003-simulation-01/output-SNAPSHOT-2016-12-26-01
inputFILE=${inputDIR}/results-simulation-nTrials-100.tsv

##################################################
myRscript=${codeDIR}/visualization-01.R
stdoutFile=stdout.R.`basename ${myRscript} .R`
R --no-save --args ${codeDIR} ${packageDIR} ${outputDIR} ${inputFILE} < ${myRscript} 2>&1 > ${stdoutFile}

##################################################
exit

