
dataForGoodDIR=~/Work/github/paradisepilot/statistics/projects/DataForGood
#tableDIR=~/Work/data/DataForGood/2014-03-08-CysticFibrosisCanada/Registry_DataForGood;

   unicef=./unicef-data-directories.csv
  dataDIR=~/Work/data/DataForGood/2014-05-10-UNICEF
  codeDIR=${dataForGoodDIR}/2014-05-10/UNICEF/code/R;
outputDIR=../output
   tmpDIR=${output_dir}/tmp

##################################################
if [ ! -d ${outputDIR} ]; then
	mkdir ${outputDIR}
fi

if [ ! -d ${tmpDIR} ]; then
	mkdir ${tmpDIR}
fi

myRscript=../../code/R/test_combine-tables.R
stdoutFile=stdout.R.`basename ${myRscript} .R`
R --no-save --args ${dataDIR} ${codeDIR} ${outputDIR} ${tmpDIR} < ${myRscript} 2>&1 > ${stdoutFile}

