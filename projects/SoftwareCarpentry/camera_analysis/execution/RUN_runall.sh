#!/bin/bash

currentDIR=`pwd`
parentDIR="$(dirname "$currentDIR")"
   srcDIR=${parentDIR}/src
   datDIR=${parentDIR//github/gitdat}
   outDIR=${parentDIR//github/gittmp}/output

if [ ! -d ${outDIR} ]; then
	mkdir -p ${outDIR}
fi

cp -r ${srcDIR} ${outDIR}

##################################################
myPyScript=${srcDIR}/runall.py
stdoutFile=stdout.py.`basename ${myPyScript} .py`
stderrFile=stderr.py.`basename ${myPyScript} .py`
python3 ${myPyScript} ${srcDIR} ${datDIR} ${outDIR} > ${outDIR}/${stdoutFile} 2> ${outDIR}/${stderrFile}

##################################################
exit

