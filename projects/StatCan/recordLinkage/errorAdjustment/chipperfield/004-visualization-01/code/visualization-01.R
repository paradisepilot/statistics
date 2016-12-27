
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

results.simulation[,"myGroup"] <- as.factor(results.simulation[,"errorRate"]);

str( results.simulation );
print( head(results.simulation) );

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
methodologies <- c("all","reviewedTrue","chipperfield");

DF.parameters <- data.frame(
    parameter =  c("Intercept","x1","x2","x3"),
    true.value = c(-0.5,1.5,2.5,-3.5)
    );

for (methodology in methodologies) {
for (i in 1:nrow(DF.parameters))   {
    plotDensityParameters(
        DF.input    = results.simulation,
        methodology = methodology,
        parameter   = DF.parameters[i,"parameter"],
        true.value  = DF.parameters[i,"true.value"]
        );
    }}

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###

###################################################

sessionInfo();

q();
