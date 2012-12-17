
command.arguments <- commandArgs(trailingOnly = TRUE);
output.directory  <- command.arguments[1];
code.directory    <- command.arguments[2];

####################################################################################################
setwd(output.directory);
library(LearnBayes);
library(ggplot2);
library(scales);

### AUXILIARY FUNCTIONS ############################################################################
### auxiliary functions for performing rejection sampling and SIR (sample importance resampling):
target.pdf <- function(x) {

	###  compute normalizing constant for the target density
	eta.min            <- -15;
	eta.max            <- +15;
	relative.grid.size <- 1e-5;
	grid.size          <- (eta.max - eta.min) * relative.grid.size;
	eta                <- eta.min + (eta.max - eta.min) * seq(0,1,relative.grid.size);

	theta                <- exp(eta) / (1 + exp(eta));
	posterior.density    <- ((2 + theta)^125) * (theta^35) / ((1 + exp(eta))^39);
	normalizing.constant <- grid.size * sum(posterior.density);

	###  compute output value
	logistic.x   <- 1 / (1 + exp(-x));
	output.value <- ((2 + logistic.x)^125) * (logistic.x ^ 35) / ((1 + exp(x))^39);
	output.value <- output.value / normalizing.constant;

	return(output.value);

	}

proposal.pdf <- function(x, parameters) {
	output.value <- parameters[['enveloping.constant']] * sn::dst(
		x        = x,
		location = parameters[['location']],
		scale    = parameters[['scale']],
		shape    = 0,
		df       = parameters[['df']],
		dp       = NULL,
		log      = FALSE
		);
	return(output.value);
	}

rproposal <- function(sample.size = NULL, parameters) {
	output.value <- sn::rst(
		n        = sample.size,
		location = parameters[['location']],
		scale    = parameters[['scale']],
		shape    = 0,
		df       = parameters[['df']],
		dp       = NULL
		);
	return(output.value);
	}

### function to perform rejection sampling
perform.rejection.sampling <- function(target.pdf = NULL, proposal.pdf = NULL, rproposal = NULL, proposal.parameters = NULL, proposal.sample.size = NULL) {

	unif.sample <- runif(n = proposal.sample.size);

	proposal.sample <- rproposal(
		sample.size = proposal.sample.size,
		parameters  = proposal.parameters
		);

	proposal.density <- proposal.pdf(
		x           = proposal.sample,
		parameters  = proposal.parameters
		);

	target.density <- target.pdf(x = proposal.sample);

	output.sample <- proposal.sample[unif.sample * proposal.density <= target.density];

	return(output.sample);

	}

### 5.13.2(a) ######################################################################################
eta.min            <- -15;
eta.max            <- +15;
relative.grid.size <- 1e-5;
grid.size          <- (eta.max - eta.min) * relative.grid.size;
eta                <- eta.min + (eta.max - eta.min) * seq(0,1,relative.grid.size);

posterior.density <- target.pdf(x = eta);

###  We now generate the approximating Gaussian distribution.
###  We simply take this Gaussian approximation to be the one whose mean equals the mean of our
###  target posterior distribution, and whose standard deviation equals the standard deviation of
###  our target posterior distribution.
posterior.mean <- sum(grid.size * posterior.density * eta);
posterior.sd   <- sqrt(sum(grid.size * posterior.density * (eta - posterior.mean)^2));
posterior.mean;
posterior.sd;
approximating.gaussian.density <- dnorm(x = eta, mean = posterior.mean, sd = posterior.sd);

###  tabular comparison of the posterior density and its Gaussian approximation:
#cbind(eta,posterior.density,approximating.gaussian.density);

###  graphical comparison of the posterior density and its Gaussian approximation:
png("Fig01_posterior-density.png");
my.levels <- c('gaussian','posterior');
DF.gaussian.approximation <- data.frame(
	eta     = eta,
	density = approximating.gaussian.density,
	type    = factor(rep('gaussian',length(eta)),levels=my.levels)
	);
DF.posterior <- data.frame(
	eta     = eta,
	density = posterior.density,
	type    = factor(rep('posterior',length(eta)),levels=my.levels)
	);
DF.temp <- rbind(DF.posterior,DF.gaussian.approximation);
qplot(data = DF.temp, x = eta, y = density, colour = type, geom = "line", xlim = c(-2,2));
dev.off();

###  estimate for 95% probability interval for theta based on estimated posterior density
posterior.cdf <- cumsum(posterior.density/sum(posterior.density));
temp <- c( eta[min(which(posterior.cdf > 0.025))], eta[min(which(posterior.cdf > 0.975))] );
exp(temp) / (1 + exp(temp));

###  estimate for 95% probability interval for theta based on Gaussian approximation to
###  posterior density.
temp <- qnorm(p = c(0.025,0.975), mean = posterior.mean, sd = posterior.sd);
exp(temp) / (1 + exp(temp));

### 5.13.2(b) ######################################################################################
###  graphical comparison of the posterior density and the proposal density (t-distribution):
proposal.parameters <- list(
	location            = posterior.mean,
	scale               = posterior.sd,
	df                  = 5,
	enveloping.constant = 1.2
	);

png("Fig02_proposal-density.png");
my.levels <- c('posterior','proposal');
proposal.density <- proposal.pdf(x = eta, parameters = proposal.parameters);
summary(cbind(proposal.density,posterior.density,proposal.density - posterior.density));
sum(proposal.density - posterior.density < 0);
DF.posterior <- data.frame(
	eta     = eta,
	density = posterior.density,
	type    = factor(rep('posterior',length(eta)),levels=my.levels)
	);
DF.proposal <- data.frame(
	eta     = eta,
	density = proposal.density,
	type    = factor(rep('proposal',length(eta)),levels=my.levels)
	);
DF.temp <- rbind(DF.posterior,DF.proposal);
qplot(data = DF.temp, x = eta, y = density, colour = type, geom = "line", xlim = c(-2,2));
dev.off();

eta.rejection.sample <- perform.rejection.sampling(
	target.pdf           = target.pdf,
	proposal.pdf         = proposal.pdf,
	rproposal            = rproposal,
	proposal.parameters  = proposal.parameters,
	proposal.sample.size = 1e+6
	);
str(eta.rejection.sample);
summary(eta.rejection.sample);
length(eta.rejection.sample);

###  graphical comparison of posterior sample obtained via rejection sampling and
###  posterior density function 
png("Fig03_rejection-sampling-sample-density.png");
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_line(
	data = data.frame(eta = eta, density = posterior.density),
	aes(x = eta, y = density),
	colour = "red"
	);
my.ggplot <- my.ggplot + geom_density(
	data = data.frame(eta = eta.rejection.sample),
	aes(x = eta),
	colour = "black" 
	);
my.ggplot <- my.ggplot + xlim(range(eta.rejection.sample));
my.ggplot;
dev.off();

###  estimate for 95% probability interval for theta based on estimated posterior density
posterior.cdf <- cumsum(posterior.density/sum(posterior.density));
temp <- c( eta[min(which(posterior.cdf > 0.025))], eta[min(which(posterior.cdf > 0.975))] );
1 / (1 + exp(-temp));

###  estimate for 95% probability interval for theta based on Gaussian approximation to
###  posterior density.
temp <- qnorm(p = c(0.025,0.975), mean = posterior.mean, sd = posterior.sd);
1 / (1 + exp(-temp));

###  estimate for 95% probability interval for theta based on rejection sampling sample
temp <- quantile(x = eta.rejection.sample, probs = c(0.025,0.975));
1 / (1 + exp(-temp));

