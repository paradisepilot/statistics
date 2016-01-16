
dataForGoodDIR=~/Work/github/paradisepilot/statistics/projects/DataForGood
tableDIR=~/Work/data/DataForGood/2016-Youville/

  codeDIR=${dataForGoodDIR}/2016-Youville/code;
outputDIR=../output
   tmpDIR=${outputDIR}/tmp

##################################################
if [ ! -d ${outputDIR} ]; then
	mkdir ${outputDIR}
fi

if [ ! -d ${tmpDIR} ]; then
	mkdir ${tmpDIR}
fi

myRscript=../../code/test_denormalizeData.R
stdoutFile=stdout.R.`basename ${myRscript} .R`
R --no-save --args ${tableDIR} ${codeDIR} ${outputDIR} ${tmpDIR} < ${myRscript} 2>&1 > ${stdoutFile}

