
### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
currentDIR=`pwd`
parentDIR="$(dirname "$currentDIR")"
  codeDIR=${parentDIR}/code
  dataDIR=${parentDIR//github/gitdat}
outputDIR=${parentDIR//github/gittmp}/output

if [ ! -d ${outputDIR} ]; then
    mkdir -p ${outputDIR}
fi

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
cp -r ${codeDIR}    ${outputDIR}

##################################################
myRLib=~/Work/gittmp/paradisepilot/statistics/projects/miniCRAN/run_installpackages/output.SNAPSHOT.2018-03-19.01/library/3.4.3/library
myRscript=${codeDIR}/runall.R
stdoutFile=${outputDIR}/stdout.R.`basename ${myRscript} .R`
R --no-save --args ${myRLib} ${dataDIR} ${codeDIR} ${outputDIR} < ${myRscript} 2>&1 > ${stdoutFile}

