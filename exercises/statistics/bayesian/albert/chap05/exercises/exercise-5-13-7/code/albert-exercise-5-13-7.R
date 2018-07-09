
command.arguments <- commandArgs(trailingOnly = TRUE);
output.directory  <- command.arguments[1];
code.directory    <- command.arguments[2];

####################################################################################################
setwd(output.directory);
library(LearnBayes);
library(ggplot2);
library(scales);

### AUXILIARY FUNCTIONS ############################################################################
my.log.posterior.pre.density <- function(theta = NULL, parameters = NULL) {

	
	observations <- parameters[['observations']];

	Y <- apply(X = observations, MARGIN = 1, FUN = mean);
	n <- ncol(observations);
	S <- apply(X = observations, MARGIN = 1, FUN = var ) * (n - 1);

	log.pre.density <- NULL;
	if (is.null(dim(theta))) {

		mu      <- theta[1];
		sigma.y <- exp(theta[2]);
		sigma.b <- exp(theta[3]);

		log.pre.density <- theta[2] + theta[3] + sum(
			  dnorm(x = Y, mean = mu, sd = sqrt(sigma.y^2/n+sigma.b^2), log = TRUE)
			+ dgamma(x = S, shape = (n-1)/2, rate = 1/(2*sigma.y^2), log = TRUE)
			);

		} else {

		mu      <- theta[,1];
		sigma.y <- exp(theta[,2]);
		sigma.b <- exp(theta[,3]);

		log.pre.density <- numeric(length(theta));
		for (i in 1:length(log.pre.density)) {
		log.pre.density[i] <- theta[i,2] + theta[i,3] + sum(
			  dnorm(x = Y, mean = mu[i], sd = sqrt(sigma.y[i]^2/n+sigma.b[i]^2), log = TRUE)
			+ dgamma(x = S, shape = (n-1)/2, rate = 1/(2*sigma.y[i]^2), log = TRUE)
			);
			}
		}

	return(log.pre.density);

	}

### 5.13.7(a) ######################################################################################
posterior.parameters <- list(
	observations = matrix(
		nrow  = 6,
		ncol  = 5,
		byrow = TRUE,
		data  = c(
			1545, 1440, 1440, 1520, 1580,
			1540, 1555, 1490, 1560, 1495,
			1595, 1550, 1605, 1510, 1560,
			1445, 1440, 1595, 1465, 1545,
			1595, 1630, 1515, 1635, 1625,
			1520, 1455, 1450, 1480, 1445
			)
		)
	);
posterior.parameters;

laplace.results <- laplace(
	logpost = my.log.posterior.pre.density,
	mode    = c(1500,3,3),
	posterior.parameters
	);
laplace.results;

laplace.results <- laplace(
	logpost = my.log.posterior.pre.density,
	mode    = c(1500,1,1),
	posterior.parameters
	);
laplace.results;

laplace.results <- laplace(
	logpost = my.log.posterior.pre.density,
	mode    = c(1500,10,10),
	posterior.parameters
	);
laplace.results;

### 5.13.7(b) ######################################################################################
mean.log.sigmas <- laplace.results[['mode']][2:3];
var.log.sigmas  <- diag(laplace.results[['var']])[2:3];
sd.log.sigmas   <- sqrt(var.log.sigmas);

mean.log.sigmas;
var.log.sigmas;
sd.log.sigmas;

std.norm.90ci <- qnorm(p = c(0.05,0.95), mean = 0, sd = 1);
std.norm.90ci;

log.sigma.y.90ci <- mean.log.sigmas[1] + sd.log.sigmas[1] * std.norm.90ci;
log.sigma.b.90ci <- mean.log.sigmas[2] + sd.log.sigmas[2] * std.norm.90ci;
log.sigma.y.90ci;
log.sigma.b.90ci;

### 5.13.7(c) ######################################################################################
exp(log.sigma.y.90ci)^2;

exp(log.sigma.b.90ci)^2;

