#!/bin/bash

currentDIR=`pwd`
 parentDIR="$(dirname "$currentDIR")"
   RLibDIR=~/Work/gittmp/paradisepilot/statistics/projects/miniCRAN/run_installpackages/output/library/3.5.1/library
   codeDIR=${parentDIR}/code
 outputDIR=${parentDIR//github/gittmp}/output

if [ ! -d ${outputDIR} ]; then
	mkdir -p ${outputDIR}
fi

cp -r ${codeDIR} ${outputDIR}
cp    $0         ${outputDIR}/code

##################################################
myRscript=${codeDIR}/MASTER.R
stdoutFile=${outputDIR}/stdout.R.`basename ${myRscript} .R`
stderrFile=${outputDIR}/stderr.R.`basename ${myRscript} .R`
R --no-save --args ${RLibDIR} ${codeDIR} ${outputDIR} < ${myRscript} > ${stdoutFile} 2> ${stderrFile}

##################################################
exit

