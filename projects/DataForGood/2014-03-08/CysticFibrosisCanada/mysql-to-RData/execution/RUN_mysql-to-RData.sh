
dataForGoodDIR=~/Work/github/paradisepilot/statistics/projects/DataForGood
tableDIR=~/Work/data/DataForGood/2014-03-08-CysticFibrosisCanada/Registry_DataForGood;

  codeDIR=${dataForGoodDIR}/2014-03-08/CysticFibrosisCanada/code/R;
outputDIR=../output
   tmpDIR=${output_dir}/tmp

##################################################
if [ ! -d ${outputDIR} ]; then
	mkdir ${outputDIR}
fi

if [ ! -d ${tmpDIR} ]; then
	mkdir ${tmpDIR}
fi

myRscript=../../code/R/test_mysql-to-RData.R
stdoutFile=stdout.R.`basename ${myRscript} .R`
R --no-save --args ${tableDIR} ${codeDIR} ${outputDIR} ${tmpDIR} < ${myRscript} 2>&1 > ${stdoutFile}

