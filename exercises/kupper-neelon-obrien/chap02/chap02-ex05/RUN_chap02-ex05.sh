
myRscript=chap02-ex05.R
R --no-save < ${myRscript} 2&>1 > stdout.R.`basename ${myRscript} .R`

