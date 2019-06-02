
command.arguments <- commandArgs(trailingOnly = TRUE);
   code.directory <- normalizePath(command.arguments[1]);
 output.directory <- normalizePath(command.arguments[2]);

cat(paste0("##### Sys.time(): ",Sys.time(),"\n"));
start.proc.time <- proc.time();

setwd(output.directory);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
require(ggplot2);

source(paste0(code.directory,'/test-fda.R'));

###################################################
###################################################
test.fda();

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###

###################################################
###################################################
# print warning messages to log
cat("\n##### warnings():\n");
print(       warnings()    );

# print systems info to log
cat("\n##### Sys.info():\n");
print(       Sys.info()    );

# print session info to log
cat("\n##### sessionInfo():\n");
print(       sessionInfo()    );

# print system time to log
cat(paste0("\n##### Sys.time(): ",Sys.time(),"\n"));

# print elapsed time to log
stop.proc.time <- proc.time();
cat("\n##### start.proc.time() - stop.proc.time()\n");
print( stop.proc.time - start.proc.time );

quit();

