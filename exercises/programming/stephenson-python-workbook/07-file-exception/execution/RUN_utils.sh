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

CAT1=${datDIR}/cat01.txt
CAT2=${datDIR}/cat02.txt
CAT3=${datDIR}/cat03.txt
CAT4=${datDIR}/cat04.txt

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
myPyScript=${srcDIR}/util_Ex143.py
stdoutFile=stdout.py.`basename ${myPyScript} .py`
stderrFile=stderr.py.`basename ${myPyScript} .py`
python3 ${myPyScript} ${inputFILE} ${outDIR} ${CAT1} ${CAT2} ${CAT3} > ${outDIR}/${stdoutFile} 2> ${outDIR}/${stderrFile}
#python3 ${myPyScript} ${inputFILE} ${outDIR} ${CAT1} ${CAT4} ${CAT2} ${CAT3} > ${outDIR}/${stdoutFile} 2> ${outDIR}/${stderrFile}

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
#for i in 141 142
#do
#    myPyScript=${srcDIR}/util_Ex${i}.py
#    stdoutFile=stdout.py.`basename ${myPyScript} .py`
#    stderrFile=stderr.py.`basename ${myPyScript} .py`
#    python3 ${myPyScript} ${inputFILE} ${outDIR} > ${outDIR}/${stdoutFile} 2> ${outDIR}/${stderrFile}
#    #python3 ${myPyScript} ${outDIR} > ${outDIR}/${stdoutFile} 2> ${outDIR}/${stderrFile}
#done

##################################################
exit

