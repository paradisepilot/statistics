
 myRscript=../code/albert-section-11-01.R
  code_dir=../code
output_dir=../output
   tmp_dir=${output_dir}/tmp

##################################################
if [ ! -d ${output_dir} ]; then
	mkdir ${output_dir}
fi

if [ ! -d ${tmp_dir} ]; then
	mkdir ${tmp_dir}
fi

stdoutFile=stdout.R.`basename ${myRscript} .R`
R --no-save --args ${output_dir} ${code_dir} ${tmp_dir} < ${myRscript} 2>&1 > ${stdoutFile}

exit

##################################################
myRscript=../code/bugs-example.R
R --no-save < ${myRscript} 2>&1 > stdout.R.`basename ${myRscript} .R`

exit

##################################################

