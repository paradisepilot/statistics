
myPythonScript=../code/langtangen-exercise-01-10.py
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

stdoutFile=stdout.py.`basename ${myPythonScript} .py`
python ${myPythonScript} 2>&1 > ${stdoutFile}

