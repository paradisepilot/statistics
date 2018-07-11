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
#inputFILE=${datDIR}/big1.txt
inputFILE=${datDIR}/big.txt

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
for i in 141 142
do
    myPyScript=${srcDIR}/util_Ex${i}.py
    stdoutFile=stdout.py.`basename ${myPyScript} .py`
    stderrFile=stderr.py.`basename ${myPyScript} .py`
    python3 ${myPyScript} ${inputFILE} ${outDIR} > ${outDIR}/${stdoutFile} 2> ${outDIR}/${stderrFile}
    #python3 ${myPyScript} ${outDIR} > ${outDIR}/${stdoutFile} 2> ${outDIR}/${stderrFile}
done

##################################################
exit

