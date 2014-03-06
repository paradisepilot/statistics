
#dataForGoodDIR=~/Work/github/paradisepilot/statistics/projects/DataForGood/2014-03-08/CysticFibrosisCanada
dataForGoodDIR=../../
CFCRegistry=${dataForGoodDIR}/mysql-to-RData/output.SNAPSHOT.2014-03-02.01/CFC-Registry.RData

  codeDIR=${dataForGoodDIR}/code/R;
outputDIR=../output
   tmpDIR=${output_dir}/tmp

##################################################
if [ ! -d ${outputDIR} ]; then
	mkdir ${outputDIR}
fi

if [ ! -d ${tmpDIR} ]; then
	mkdir ${tmpDIR}
fi

myRscript=../../code/R/test_get-transplant-life-table.R
stdoutFile=stdout.R.`basename ${myRscript} .R`
R --no-save --args ${CFCRegistry} ${codeDIR} ${outputDIR} ${tmpDIR} < ${myRscript} 2>&1 > ${stdoutFile}

