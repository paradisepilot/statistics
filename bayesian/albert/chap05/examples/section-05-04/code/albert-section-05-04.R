
command.arguments <- commandArgs(trailingOnly = TRUE);
output.directory  <- command.arguments[1];
code.directory    <- command.arguments[2];

####################################################################################################
library(LearnBayes);
library(ggplot2);
library(scales);

source(paste(code.directory,"my-simcontour.R",sep = "/"));
source(paste(code.directory,"my-contour.R",   sep = "/"));

### AUXILIAR FUNCTIONS #############################################################################
log.posterior.beta.binomial <- function(parameters = NULL, data = NULL) {
	
	eta <- parameters[1];
	K   <- parameters[2];

	y <- data[,1];
	n <- data[,2];

	N <- length(y);

	output.value <- lbeta(K * eta + y, K * (1 - eta) + n - y) - lbeta(K * eta, K * (1 - eta));
	output.value <- sum(output.value);
	output.value <- output.value - 2 * log(1 + K) - log(eta) - log(1 - eta);

	return(output.value);

	}

log.posterior.beta.binomial.tranformed <- function(parameters = NULL, data = NULL) {
	
	eta <- exp(parameters[1]) / (1 + exp(parameters[1]));
	K   <- exp(parameters[2]);

	y <- data[,1];
	n <- data[,2];

	N <- length(y);

	output.value <- lbeta(K * eta + y, K * (1 - eta) + n - y) - lbeta(K * eta, K * (1 - eta));
	output.value <- sum(output.value);
	output.value <- output.value - 2 * log(1 + K) - log(eta) - log(1 - eta);

	return(output.value);

	}

### SECTION 5.4 ####################################################################################
setwd(output.directory);
data(cancermortality);
str(cancermortality);
cancermortality;

png("Fig5-01_contour-eta-vs-K.png");
ggplot.obj <- my.contour(
	f         = log.posterior.beta.binomial,
	limits    = c(0.0001,0.003,1,20000),
	data      = cancermortality,
	grid.size = (1e-2)/2,
	bins      = 50
	);
ggplot.obj;
dev.off();

png("Fig5-02_contour-logit-eta-vs-log-K.png");
ggplot.obj <- my.contour(
	f         = log.posterior.beta.binomial.tranformed,
	limits    = c(-8,-4.5,3,16.5),
	data      = cancermortality,
	grid.size = (1e-2)/2,
	bins      = 70
	);
ggplot.obj;
dev.off();

