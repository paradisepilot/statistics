
command.arguments <- commandArgs(trailingOnly = TRUE);
   code.directory <- normalizePath(command.arguments[1]);
package.directory <- normalizePath(command.arguments[2]);
 output.directory <- normalizePath(command.arguments[3]);
       input.file <- normalizePath(command.arguments[4]);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
library(dplyr);
library(ggplot2);
# library(ggmap);
# library(RColorBrewer);
# library(VennDiagram);

# source(paste0(package.directory,'/linkAdjust-logistic.R'));
# source(paste0(package.directory,'/make-synthetic-data.R'));

setwd(output.directory);

###################################################

results.simulation <- read.table(
    file   = input.file,
    header = TRUE,
    sep    = "\t"
    );

str( results.simulation );

###################################################

sessionInfo();

q();
