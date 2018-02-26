#!/bin/bash

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
currentDIR=`pwd`
parentDIR="$(dirname "$currentDIR")"
  codeDIR=${parentDIR}/code
  dataDIR=${parentDIR//github/gitdat}
outputDIR=${parentDIR//github/gittmp}/output

if [ ! -d ${outputDIR} ]; then
	mkdir -p ${outputDIR}
fi

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
csvPortfolio=${dataDIR}/portfolio-2018-0225.csv

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
cp -r ${codeDIR}   ${outputDIR}
cp ${csvPortfolio} ${outputDIR}

##################################################
myRscript=${codeDIR}/rebalance-portfolio.R
stdoutFile=${outputDIR}/stdout.R.`basename ${myRscript} .R`
R --no-save --args ${codeDIR} ${outputDIR} ${csvPortfolio} < ${myRscript} 2>&1 > ${stdoutFile}

##################################################
exit

