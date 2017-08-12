
command.arguments <- commandArgs(trailingOnly = TRUE);
output.directory  <- command.arguments[1];
code.directory    <- command.arguments[2];

####################################################################################################
require(LearnBayes);
require(ggplot2);
require(scales);
require(coda);
#require(sn);

#source(paste(code.directory, "utils-monte-carlo.R", sep = "/"));

setwd(output.directory);

### AUXILIARY FUNCTIONS ############################################################################
log.posterior.pre.density <- function(model.parameters = NULL, prior.and.data = NULL) {
        
	mu    <- prior.and.data[['prior']][['mu']];
	sigma <- prior.and.data[['prior']][['sigma']];

	y <- prior.and.data[['data']][['num.of.heads']];
	n <- prior.and.data[['data']][['num.of.tosses']];

	theta <- model.parameters;

	output.value <- y * theta - n * log(1 + exp(theta)) - (theta - mu)^2 / (2 * sigma^2);

        return(output.value);

        }

### Exercise 6.13.2 ################################################################################
prior.and.data <- list(
	prior = list(mu = 0, sigma = 0.25),
	data  = list(num.of.tosses = 5, num.of.heads = 5)
	);

start.point <- 0;
laplace.results <- laplace(
	logpost = log.posterior.pre.density,
	mode    = start.point,
	prior.and.data
	);
laplace.results;

rwmetrop.proposal.parameters <- list(
	var   = 2 * laplace.results[['var']],
	scale = 2
	);

sample.size <- 1e+6;
rwmetrop.results <- rwmetrop(
	logpost  = log.posterior.pre.density,
	proposal = list(
		var   = 2 * laplace.results[['var']],
		scale = 2
		),
	start    = laplace.results[['mode']],
	m        = sample.size,
	prior.and.data
	);
str(rwmetrop.results);

theta.rwmetrop.sample <- as.numeric(rwmetrop.results[['par']]);
mean(theta.rwmetrop.sample);
sd(theta.rwmetrop.sample);
mean(theta.rwmetrop.sample > 0);

####################################################################################################

q();

