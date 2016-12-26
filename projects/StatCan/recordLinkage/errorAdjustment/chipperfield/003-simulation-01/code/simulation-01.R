
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

true.beta <- c(-0.5,1.5,2.5,-3.5);

# n.trials        <- 100;
# n.observations  <- c(2000,5000,10000,50000);
# errorRates      <- seq(0,1,0.25);
# reviewFractions <- seq(0,1,0.25);

n.trials        <- 3;
n.observations  <- c(2000,5000);
errorRates      <- seq(0,1,0.5);
reviewFractions <- seq(0.1,0.9,0.4);

n.trials;
n.observations;
errorRates;
reviewFractions;

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###

n.rows <- n.trials * length(n.observations) * length(errorRates) * length(reviewFractions);
results.simulation <- matrix(data = -999, nrow = n.rows, ncol = 3+length(true.beta));

str( results.simulation );

n.rows;

row.index <- 0;
for (n.observation  in n.observations)  {
for (errorRate      in errorRates)      {
for (reviewFraction in reviewFractions) {

	synthetic.data <- make.synthetic.data(
		n.observation  = n.observation,
		beta           = true.beta,
		errorRate      = errorRate,
		reviewFraction = reviewFraction
		);

	for (i in 1:n.trials) {

		row.index <- 1 + row.index;

		print( c(n.observation,errorRate,reviewFraction,i) );

		results.linkAdjust <- linkAdjust.logistic(
			data       = synthetic.data[,c("y.observed","x1","x2","x3","review","match")],
			response   = "y.observed",
			predictors = c("x1","x2","x3"),
			review     = "review",
			match      = "match"
			);

		print("results.linkAdjust[['estimates']]");
		print( results.linkAdjust[['estimates']] );

		temp <- c(
			n.observation,
			errorRate,
			reviewFraction,
			results.linkAdjust[['estimates']]
			);
		print("temp");
		print( temp );

		results.simulation[row.index,] <- c(
			n.observation,
			errorRate,
			reviewFraction,
			results.linkAdjust[['estimates']]
			);

		}

	}}}

str( results.simulation );

###################################################

sessionInfo();

q();

