
mainDIR=..

  codeDIR=${mainDIR}/code
outputDIR=${mainDIR}/output
   tmpDIR=${outputDIR}/tmp

##################################################
if [ ! -d ${outputDIR} ]; then
	mkdir ${outputDIR}
fi

if [ ! -d ${tmpDIR} ]; then
	mkdir ${tmpDIR}
fi

myRscript=${codeDIR}/rare-events-count-data.R
stdoutFile=stdout.R.`basename ${myRscript} .R`
R --no-save --args ${codeDIR} ${outputDIR} ${tmpDIR} < ${myRscript} 2>&1 > ${stdoutFile}

