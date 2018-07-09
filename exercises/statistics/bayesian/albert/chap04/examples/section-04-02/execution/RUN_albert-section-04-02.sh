
myRscript=../code/albert-section-04-02.R
output_dir=../output

##################################################
stdoutFile=stdout.R.`basename ${myRscript} .R`
R --no-save --args ${output_dir} < ${myRscript} 2>&1 > ${stdoutFile}

