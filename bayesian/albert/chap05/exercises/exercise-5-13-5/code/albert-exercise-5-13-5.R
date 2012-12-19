
command.arguments <- commandArgs(trailingOnly = TRUE);
output.directory  <- command.arguments[1];
code.directory    <- command.arguments[2];

####################################################################################################
setwd(output.directory);
library(LearnBayes);
library(ggplot2);
library(scales);

source(paste(code.directory,"utils-1D-monte-carlo.R",sep="/"));

### SPECIFIC AUXILIARY FUNCTIONS ###################################################################
my.log.posterior.pre.density <- function(theta = NULL, parameters = NULL) {

	n0 <- parameters[['n0']];
	n1 <- parameters[['n1']];
	n2 <- parameters[['n2']];
	n3 <- parameters[['n3']];

	lambda <- theta;

	term1 <- - lambda * (n0 + n1 + n2);
	term2 <- (n1 + 2*n2 - 1) * log(lambda);
	term3 <- n3 * (1 - exp(-lambda) * (1 + lambda + lambda^2/2));

	log.pre.density <- term1 + term2 + term3;

	return(log.pre.density);

	}

Gaussian.pdf <- function(x = NULL, parameters = NULL) {
	output.value <- dnorm(
		x    = as.matrix(x),
		mean = parameters[['mean']],
		sd   = parameters[['sd']],
		log  = parameters[['log']]
		);
	return(output.value);
	}

r.Gaussian <- function(sample.size = NULL, parameters = NULL) {
	output.value <- rnorm(
		n    = sample.size,
		mean = parameters[['mean']],
		sd   = parameters[['sd']]
		);
	return(output.value);
	}

t.pdf <- function(x, parameters) {
        output.value <- parameters[['enveloping.constant']] * LearnBayes::dmt(
                x    = as.matrix(x),
                mean = parameters[['mean']],
                S    = parameters[['S']],
                df   = parameters[['df']],
                log  = parameters[['log']]
                );
        return(output.value);
        }

r.t <- function(sample.size = NULL, parameters) {
        output.value <- LearnBayes::rmt(
                n    = sample.size,
                mean = parameters[['mean']],
                S    = parameters[['S']],
                df   = parameters[['df']]
                );
        return(output.value);
        }

### 5.13.5(a) ######################################################################################
#
#  See definition of my.log.posterior.pre.density().
#

### 5.13.5(b) ######################################################################################
posterior.parameters <- list(n0 = 11, n1 = 37, n2 = 64, n3 = 128);

grid.parameters <- list(xlimits = c(1e-3,5), relative.grid.size = 1e-3);
lambda.grid <- generate.grid(
	xlimits            = grid.parameters[['xlimits']],
	relative.grid.size = grid.parameters[['relative.grid.size']]
	);

DF.lambda.posterior.density <- data.frame(
	lambda    = lambda.grid,
	posterior = target.pdf(
		log.pre.density        = my.log.posterior.pre.density,
		theta                  = lambda.grid,
		pre.density.parameters = posterior.parameters,
		grid.parameters        = grid.parameters
		)
	);
str(DF.lambda.posterior.density);
summary(DF.lambda.posterior.density);

png("Fig01_posterior-density.png");
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_line(
	data     = DF.lambda.posterior.density,
	aes(x = lambda, y = posterior)
	);
my.ggplot <- my.ggplot + xlim(0,5);
my.ggplot;
dev.off();

laplace.results <- laplace(
	logpost = my.log.posterior.pre.density,
	mode    = 2,
	posterior.parameters
	);
laplace.results;

gaussian.parameters <- list(
	enveloping.constant = 1,
	mean = laplace.results[['mode']],
	sd   = sqrt(laplace.results[['var']]),
	log  = FALSE
	);

t.parameters <- list(
	enveloping.constant = 1,
	mean = laplace.results[['mode']],
	S    = laplace.results[['var']],
	df   = 1,
	log  = FALSE
	);

DF.lambda <- cbind(
	DF.lambda.posterior.density,
	gaussian = Gaussian.pdf(x = lambda.grid, parameters = gaussian.parameters),
	t        = t.pdf(x = lambda.grid, parameters = t.parameters)
	);
str(DF.lambda);
summary(DF.lambda);

png("Fig02_posterior-gaussian-t-densities.png");
my.levels <- c('posterior','gaussian','t');
DF.temp.posterior <- data.frame(
	lambda  = DF.lambda[,'lambda'],
	density = DF.lambda[,'posterior'],
	distribution = factor(rep('posterior'),levels=my.levels)
	);
DF.temp.gaussian <- data.frame(
	lambda  = DF.lambda[,'lambda'],
	density = DF.lambda[,'gaussian'],
	distribution = factor(rep('gaussian'),levels=my.levels)
	);
DF.temp.t <- data.frame(
	lambda  = DF.lambda[,'lambda'],
	density = DF.lambda[,'t'],
	distribution = factor(rep('t'),levels=my.levels)
	);
DF.temp <- rbind(DF.temp.posterior,DF.temp.gaussian,DF.temp.t);
qplot(data = DF.temp, x = lambda, y = density, colour = distribution, geom = "line");
dev.off();

### 5.13.5(c) ######################################################################################
lambda.SIR.sample <- perform.SIR(
	log.pre.density        = my.log.posterior.pre.density,
	target.pdf             = target.pdf,
	pre.density.parameters = posterior.parameters,
	grid.parameters        = grid.parameters,
	proposal.pdf           = t.pdf,
	rproposal              = r.t,
	proposal.parameters    = t.parameters,
	proposal.sample.size   = 1e+6,
	SIR.sample.size        = 1e+6
	);
lambda.SIR.sample <- as.data.frame(lambda.SIR.sample);
colnames(lambda.SIR.sample) <- c('lambda');
summary(lambda.SIR.sample);

lambda.bootstrap.sample <- generate.bootstrap.sample(
	sample.size = 1e+6,
	logf        = my.log.posterior.pre.density,
	xlimits     = grid.parameters[['xlimits']],
	parameters  = posterior.parameters
	);
lambda.bootstrap.sample <- as.data.frame(lambda.bootstrap.sample);
colnames(lambda.bootstrap.sample) <- c('lambda');
summary(lambda.bootstrap.sample);

### posterior estimates of mean and standard deviation for lambda based on SIR sample:
mean(lambda.SIR.sample[,'lambda']);
sd(lambda.SIR.sample[,'lambda']);

### posterior estimates of mean and standard deviation for lambda based on weighted bootstrap:
mean(lambda.bootstrap.sample[,'lambda']);
sd(lambda.bootstrap.sample[,'lambda']);

