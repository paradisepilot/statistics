
command.arguments <- commandArgs(trailingOnly = TRUE);
   code.directory <- normalizePath(command.arguments[1]);
package.directory <- normalizePath(command.arguments[2]);
 output.directory <- normalizePath(command.arguments[3]);
       input.file <- normalizePath(command.arguments[4]);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
library(dplyr);
library(tidyr);
library(ggplot2);
# library(ggmap);
# library(RColorBrewer);
# library(VennDiagram);

source(paste0(code.directory,'/plotDensityParameters.R'));

setwd(output.directory);

###################################################
results.simulation <- read.table(
    file   = input.file,
    header = TRUE,
    sep    = "\t"
    );

results.simulation <- results.simulation %>%
    unite(myGroup, nobs, errorRate, reviewFraction, sep = '; ', remove = FALSE);

str( results.simulation );
print( head(results.simulation) );

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
plotDensityParameters(
    FILE.ggplot = 'plot-density.png',
    DF.input    = results.simulation    
    );

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###

###################################################

sessionInfo();

q();
