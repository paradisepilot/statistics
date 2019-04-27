#!/bin/bash

currentDIR=`pwd`
    srcDIR=${currentDIR}/src
    outDIR=${currentDIR}/output

if [ ! -d ${outDIR} ]; then
	mkdir -p ${outDIR}
fi

cp $0 ${outDIR}
cp -r ${srcDIR} ${outDIR}

##################################################
myPyScript=${srcDIR}/runall.py
stdoutFile=stdout.py.`basename ${myPyScript} .py`
stderrFile=stderr.py.`basename ${myPyScript} .py`
python ${myPyScript} ${srcDIR} ${outDIR} > ${outDIR}/${stdoutFile} 2> ${outDIR}/${stderrFile}

##################################################
exit

