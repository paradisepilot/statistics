
 myRscript=../code/albert-section-06-09.R
  code_dir=../code
output_dir=../output

##################################################
stdoutFile=stdout.R.`basename ${myRscript} .R`
R --no-save --args ${output_dir} ${code_dir} < ${myRscript} 2>&1 > ${stdoutFile}

