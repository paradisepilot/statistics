
command.arguments <- commandArgs(trailingOnly = TRUE);
   RLib.directory <- normalizePath(command.arguments[1]);
   code.directory <- normalizePath(command.arguments[2]);
 output.directory <- normalizePath(command.arguments[3]);

cat(paste0("##### Sys.time(): ",Sys.time(),"\n"));
start.proc.time <- proc.time();

setwd(output.directory);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
library(R6);

source(paste0(code.directory,'/myCART.R'));

###################################################
data(iris);
print( str( iris) );
print( head(iris) );

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
myTree <- myCART$new(
    formula = Species ~ .,
    data    = iris
    );
print( str(myTree) );

###################################################
# print warning messages to log
cat("\n##### warnings()\n")
print(warnings());

# print session info to log
cat("\n##### sessionInfo()\n")
print( sessionInfo() );

# print system time to log
cat(paste0("\n##### Sys.time(): ",Sys.time(),"\n"));

# print elapsed time to log
stop.proc.time <- proc.time();
cat("\n##### start.proc.time() - stop.proc.time()\n");
print( stop.proc.time - start.proc.time );

q();

