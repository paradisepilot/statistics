
  codeDIR=../../code
outputDIR=../output
   tmpDIR=${outputDIR}/tmp

##################################################
if [ ! -d ${outputDIR} ]; then
        mkdir ${outputDIR}
fi

if [ ! -d ${tmpDIR} ]; then
        mkdir ${tmpDIR}
fi

myRscript=../../code/test_gtrendsR.R
stdoutFile=stdout.R.`basename ${myRscript} .R`
R --no-save --args ${codeDIR} ${outputDIR} ${tmpDIR} < ${myRscript} 2>&1 > ${stdoutFile}

