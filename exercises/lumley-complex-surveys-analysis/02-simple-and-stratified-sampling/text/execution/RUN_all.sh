
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
myRscript=${codeDIR}/runall.R
stdoutFile=${outputDIR}/stdout.R.`basename ${myRscript} .R`
R --no-save --args ${dataDIR} ${codeDIR} ${outputDIR} < ${myRscript} 2>&1 > ${stdoutFile}

