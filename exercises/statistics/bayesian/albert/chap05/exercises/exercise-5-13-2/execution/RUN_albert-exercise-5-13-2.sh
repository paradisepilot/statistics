
 myRscript=../code/albert-exercise-5-13-2.R
output_dir=../output
  code_dir=../code

##################################################
stdoutFile=stdout.R.`basename ${myRscript} .R`
R --no-save --args ${output_dir} ${code_dir} < ${myRscript} 2>&1 > ${stdoutFile}

