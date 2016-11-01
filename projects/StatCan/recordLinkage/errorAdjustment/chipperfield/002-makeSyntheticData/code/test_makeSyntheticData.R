
command.arguments <- commandArgs(trailingOnly = TRUE);
   code.directory <- normalizePath(command.arguments[1]);
package.directory <- normalizePath(command.arguments[2]);
 output.directory <- normalizePath(command.arguments[3]);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
# library(dplyr);
# library(ggmap);
# library(RColorBrewer);
# library(VennDiagram);

source(paste0(package.directory,'/linkAdjust-logistic.R'));
source(paste0(package.directory,'/make-synthetic-data.R'));

setwd(output.directory);

###################################################
synthetic.data <- make.synthetic.data(
	nobs           = 5000,
	beta           = c(-0.5,1.5,2.5,-3.5),
	errorRate      = 0.05,
	reviewFraction = 0.20
	);

synthetic.data[1:5,];

results <- linkAdjust.logistic(
	data       = synthetic.data[,c("y.observed","x1","x2","x3","review","match")],
	response   = "y.observed",
	predictors = c("x1","x2","x3"),
	review     = "review",
	match      = "match"
	);

###################################################

q();

