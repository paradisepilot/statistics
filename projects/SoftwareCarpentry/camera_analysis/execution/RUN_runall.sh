#!/bin/bash

currentDIR=`pwd`
parentDIR="$(dirname "$currentDIR")"
   srcDIR=${parentDIR}/src
   datDIR=${parentDIR//github/gitdat}
   outDIR=${parentDIR//github/gittmp}/output

echo ${srcDIR}
echo ${datDIR}
echo ${outDIR}

if [ ! -d ${outDIR} ]; then
	mkdir -p ${outDIR}
fi

cp -r ${srcDIR} ${outDIR}

##################################################
myPyScript=${srcDIR}/runall.py
stdoutFile=stdout.py.`basename ${myPyScript} .py`
stderrFile=stderr.py.`basename ${myPyScript} .py`
python3 ${myPyScript} ${srcDIR} ${datDIR} ${outDIR} > ${outDIR}/${stdoutFile} 2> ${outDIR}/${stderrFile}

# python3 ${myPyScript} ${srcDIR} ${outDIR} 2>&1 > ${stdoutFile}
# python3 ../src/runall.py > stdout.runall-py 2> stderr.runall-py

##################################################
exit

