
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

#n.trials        <- 100;
#n.observations  <- c(2000,3000,4000,5000);
#errorRates      <- c(0,0.05,0.1);
#reviewFractions <- c(0.1,0.2,0.9,1);
#predictors      <- c("x1","x2","x3");

n.trials        <- 100;
n.observations  <- c(2000,3000,4000,5000);
errorRates      <- c(0,0.05,0.1);
reviewFractions <- c(0.1,0.2,0.9,1);
predictors      <- c("x1","x2","x3");

n.trials;
n.observations;
errorRates;
reviewFractions;

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###

n.rows <- n.trials * length(n.observations) * length(errorRates) * length(reviewFractions);
results.simulation <- matrix(data = -999, nrow = n.rows, ncol = 3+3*(1+length(true.beta)));
colnames(results.simulation) <- c(
    "nobs","errorRate","reviewFraction",
    "err.all","err.reviewedTrue","err.chipperfield", 
    paste("all",c("Intercept",predictors),sep="."),
    paste("reviewedTrue",c("Intercept",predictors),sep="."),
    paste("chipperfield",c("Intercept",predictors),sep=".")
    );

str( results.simulation );

n.rows;

row.index <- 0;
for (n.observation  in n.observations)  {
for (errorRate      in errorRates)      {
for (reviewFraction in reviewFractions) {

	for (i in 1:n.trials) {

	    row.index <- 1 + row.index;
	    print( paste0("#####  row.index = ",row.index," of ",n.rows) );

		### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
		synthetic.data <- make.synthetic.data(
			n.observation  = n.observation,
			beta           = true.beta,
			errorRate      = errorRate,
			reviewFraction = reviewFraction
			);

		### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
		temp.formula = paste0("y.observed"," ~ ",paste(predictors,collapse=" + "));
		temp.formula = as.formula(temp.formula);

		results.glm.all <- coefficients(glm(
		    formula = temp.formula,
		    data    = as.data.frame(synthetic.data[,c("y.observed",predictors)]),
		    family  = binomial(link="logit")
		    ));
		# print("results.glm.all");
		# print( results.glm.all );

		selected.indices <- (synthetic.data[,"review"] == TRUE) & (synthetic.data[,"match"] == TRUE);
		results.glm.reviewedTrue <- coefficients(glm(
		    formula = temp.formula,
		    data    = as.data.frame(synthetic.data[selected.indices,c("y.observed",predictors)]),
		    family  = binomial(link="logit")
            ));
		#print("results.glm.reviewedTrue");
		#print( results.glm.reviewedTrue );

		### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
		results.linkAdjust <- linkAdjust.logistic(
			data       = synthetic.data[,c("y.observed","x1","x2","x3","review","match")],
			response   = "y.observed",
			predictors = predictors,
			review     = "review",
			match      = "match"
			);

		# print("results.linkAdjust[['estimates']]");
		# print( results.linkAdjust[['estimates']] );

		### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
		err.all          <- sqrt( sum((results.glm.all                   - true.beta)^2) );
		err.reviewedTrue <- sqrt( sum((results.glm.reviewedTrue          - true.beta)^2) );
		err.linkAdjust   <- sqrt( sum((results.linkAdjust[['estimates']] - true.beta)^2) );
		
		### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
		results.simulation[row.index,] <- c(
			n.observation, errorRate, reviewFraction,
			err.all, err.reviewedTrue, err.linkAdjust,
			results.glm.all,
			results.glm.reviewedTrue,
			results.linkAdjust[['estimates']]
			);

		}

	}}}

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###

str( results.simulation );
results.simulation;

write.table(
    x         = results.simulation,
    file      = "results-simulation.tsv",
    sep       = "\t",
    row.names = FALSE
    );

###################################################

sessionInfo();

q();
