
command.arguments <- commandArgs(trailingOnly = TRUE);
output.directory  <- command.arguments[1];

####################################################################################################
setwd(output.directory);
library(LearnBayes);
library(ggplot2);
library(scales);

####################################################################################################
### 5.13.1(a) ######################################################################################
eta.min          <- -15;
eta.max          <- +15;
relative.grid.size <- 1e-5;
grid.size          <- (eta.max - eta.min) * relative.grid.size;
eta                <- eta.min + (eta.max - eta.min) * seq(0,1,relative.grid.size);

theta             <- exp(eta) / (1 + exp(eta));
posterior.density <- ((2 + theta)^125) * (theta^35) / ((1 + exp(eta))^39);
posterior.density <- posterior.density / (grid.size * sum(posterior.density));

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
DF.gaussian.approximation <- NULL;
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

####################################################################################################

q();

####################################################################################################
### AUXILIARY FUNCTIONS ############################################################################
### auxiliary functions for performing rejection sampling and SIR (sample importance resampling):
target.pdf <- function(x) {
	mu.0    <- 0;
	sigma.0 <- 0.25;
	n       <- 5;
	y       <- 5;

	theta.min          <- -9.5;
	theta.max          <- +9.5;
	relative.grid.size <- 1e-3;

	grid.size <- (theta.max - theta.min) * relative.grid.size;
	theta     <- theta.min + (theta.max - theta.min) * seq(0,1,relative.grid.size);

	posterior.density    <- dnorm(x = theta, mean = mu.0, sd = sigma.0);
	posterior.density    <- posterior.density * exp(y * theta) / ((1 + exp(theta))^n);
	normalizing.constant <- grid.size * sum(posterior.density);

	output.value <- dnorm(x=x, mean=mu.0, sd=sigma.0) * exp(y*x) / ((1+exp(x))^n);
	output.value <- output.value / normalizing.constant;

	return(output.value);
	}

proposal.pdf <- function(x) {
	mu.0                <- 0;
	sigma.0             <- 0.25;
	enveloping.constant <- 28;
	return( enveloping.constant * dnorm(x = x, mean = mu.0, sd = sigma.0) );
	}

rproposal <- function(sample.size = NULL) {
	mu.0                <- 0;
	sigma.0             <- 0.25;
	return(rnorm(n = sample.size, mean = mu.0, sd = sigma.0));
	}

### SET-UP #########################################################################################
mu.0    <- 0;
sigma.0 <- 0.25;
n       <- 5;
y       <- 5;

### 5.13.1(a) ######################################################################################
theta.min          <- -9.5;
theta.max          <- +9.5;
relative.grid.size <- 1e-4;
grid.size          <- (theta.max - theta.min) * relative.grid.size;
theta              <- theta.min + (theta.max - theta.min) * seq(0,1,relative.grid.size);

posterior.density <- dnorm(x=theta, mean=mu.0, sd=sigma.0) * exp(y*theta) / ((1+exp(theta))^n);
posterior.density <- posterior.density / (grid.size * sum(posterior.density));
	###  We explain why "grid.size" is necessary in the above.
	###  Simply put, the "grid.size" is needed above so that the resulting
	###  numeric vector "posterior.density" is an accurate approximation of the
	###  actual posterior density function (as opposed to just some multiple of it
	###  by an unknown factor).
	###
	###  Note that the quantity "grid.size * sum(posterior.density)" is simply the
	###  Riemann sum with respect to the partition defined by the entries in the
	###  numeric vector "theta".  Thus, as "length(theta)" becomes large,
	###  "grid.size * sum(posterior.density)" well approximates the integral of
	###  the function defined by:
	###
	###      dnorm(x=theta, mean=mu.0, sd=sigma.0) * exp(y*theta) / ((1+exp(theta))^n); 
	###
	###  Without "grid.size", then "posterior.density" would only be proportional
	###  to the actual posterior density, but not equal to it.
	###
	###  This might be sufficient we were to use the numeric vector "posterior.density"
	###  simply as a vector of sampling weights.  However, since we need to make
	###  comparison of the posterior density with a number of other entities, including
	###  its approximating Gaussian density, the rejection-sampling proposal density,
	###  the sampling-importance-resampling proposal density, and the densities
	###  generated based on rejection-sampling and sampling-importance-resampling samples. 
	###  To facilitate these comparisons, we need to know the actual values of the
	###  posterior density function, not just some multiple of it by an unknown factor.

###  sanity check:
summary(posterior.density);
sum(grid.size * posterior.density);

###  We now generate the approximating Gaussian distribution.
###  We simply take this Gaussian approximation to be the one whose mean equals the mean of our
###  target posterior distribution, and whose standard deviation equals the standard deviation of
###  our target posterior distribution.
posterior.mean <- sum(grid.size * posterior.density * theta);
posterior.sd   <- sqrt(sum(grid.size * posterior.density * (theta - posterior.mean)^2));
posterior.mean;
posterior.sd;
approximating.gaussian.density <- dnorm(x = theta, mean = posterior.mean, sd = posterior.sd);

###  tabular comparison of the posterior density and its Gaussian approximation:
cbind(theta,posterior.density,approximating.gaussian.density);

###  graphical comparison of the posterior density and its Gaussian approximation:
png("Fig01_posterior-density.png");
my.levels <- c('gaussian','posterior');
DF.gaussian.approximation <- NULL;
DF.gaussian.approximation <- data.frame(
	theta   = theta,
	density = approximating.gaussian.density,
	type    = factor(rep('gaussian',length(theta)),levels=my.levels)
	);
DF.posterior <- data.frame(
	theta   = theta,
	density = posterior.density,
	type    = factor(rep('posterior',length(theta)),levels=my.levels)
	);
DF.temp <- rbind(DF.posterior,DF.gaussian.approximation);
qplot(data = DF.temp, x = theta, y = density, colour = type, geom = "line");
#my.ggplot <- ggplot(data = NULL);
#my.ggplot <- my.ggplot + geom_line(
#	data = DF.posterior,
#	aes(x = theta, y = density),
#	colour = "red"
#	);
#my.ggplot <- my.ggplot + geom_line(
#	data = DF.gaussian.approximation,
#	aes(x = theta, y = density),
#	colour = "black"
#	);
#my.ggplot;
dev.off();

###  estimate of posterior probability P(theta > 0 | data) that theta is positive
###  (i.e. the coin is biased towards heads)
sum(grid.size * posterior.density[theta > 0]);

###  estimate of posterior probability P(theta > 0 | data) that theta is positive
###  (i.e. the coin is biased towards heads) based on the approximating Gaussian distribution
pnorm(q = 0, mean = posterior.mean, sd = posterior.sd, lower.tail = FALSE);

### 5.13.1(b) ######################################################################################
prior.density               <- dnorm(x=theta, mean=mu.0, sd=sigma.0);
proposal.density            <- 28 * prior.density;
posterior.to.proposal.ratio <- posterior.density / proposal.density;

### tabular comparison of posterior density, proposal density, and their ratio:
cbind(theta,posterior.density,proposal.density,posterior.to.proposal.ratio);

png("Fig02_rejection-sampling-proposal-density.png");
my.levels <- c('posterior','proposal');
DF.posterior <- data.frame(
	theta   = theta,
	density = posterior.density,
	type    = factor(rep('posterior',length(theta)),levels=my.levels)
	);
DF.proposal <- data.frame(
	theta   = theta,
	density = proposal.density,
	type    = factor(rep('proposal',length(theta)),levels=my.levels)
	);
DF.temp <- rbind(DF.posterior,DF.proposal);
qplot(data = DF.temp, x = theta, y = density, colour = type, geom = "line");
dev.off();

png("Fig03_rejection-sampling-posterior-to-proposal-ratio.png");
qplot(
	data = data.frame(
		theta = theta,
		ratio = posterior.to.proposal.ratio
		),
	x    = theta,
	y    = ratio,
	geom = "line"
	);
dev.off();

### function to perform rejection sampling
perform.rejection.sampling <- function(target.pdf = NULL, proposal.pdf = NULL, rproposal = NULL, proposal.sample.size = NULL) {

	unif.sample     <- runif(n = proposal.sample.size);
	proposal.sample <- rproposal(sample.size = proposal.sample.size);

	target.density   <- target.pdf(proposal.sample);
	proposal.density <- proposal.pdf(proposal.sample);

	output.sample <- proposal.sample[unif.sample * proposal.density <= target.density];

	return(output.sample);

	}

### generate sample from posterior distribution via rejection sampling
proposal.sample.size <- 4 * (1e+6);
my.rejection.sample <- perform.rejection.sampling(
	target.pdf           = target.pdf,
	proposal.pdf         = proposal.pdf,
	rproposal            = rproposal,
	proposal.sample.size = proposal.sample.size
	);
str(my.rejection.sample);
summary(my.rejection.sample);
length(my.rejection.sample);

###  graphical comparison of posterior sample obtained via rejection sampling and
###  posterior density function 
png("Fig04_rejection-sampling-sample-density.png");
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_line(
	data = data.frame(
		theta   = theta,
		density = posterior.density
		),
	aes(x = theta, y = density),
	colour = "red"
	);
my.ggplot <- my.ggplot + geom_density(
	data = data.frame(
		theta = my.rejection.sample
		),
	aes(x = theta),
	colour = "black" 
	);
my.ggplot <- my.ggplot + xlim(range(my.rejection.sample));
my.ggplot;
dev.off();

###  estimate of posterior probability P(theta > 0 | data) that theta is positive
###  (i.e. the coin is biased towards heads) based on estimated posterior density on a grid:
sum(grid.size * posterior.density[theta > 0]);

###  estimate of P(theta > 0 | data) based on the approximating Gaussian distribution:
pnorm(q = 0, mean = posterior.mean, sd = posterior.sd, lower.tail = FALSE);

### estimate of P(theta > 0 | data) based on rejection sampling:
mean(my.rejection.sample > 0);

### 5.13.1(c) ######################################################################################
prior.density               <- dnorm(x=theta, mean=mu.0, sd=sigma.0);
proposal.density            <- prior.density;
posterior.to.proposal.ratio <- posterior.density / proposal.density;

### tabular comparison of posterior density, proposal density, and their ratio:
cbind(theta,posterior.density,proposal.density,posterior.to.proposal.ratio);

png("Fig05_SIR-proposal-density.png");
my.levels <- c('posterior','SIR proposal');
DF.posterior <- data.frame(
	theta   = theta,
	density = posterior.density,
	type    = factor(rep('posterior',length(theta)),levels=my.levels)
	);
DF.proposal <- data.frame(
	theta   = theta,
	density = proposal.density,
	type    = factor(rep('SIR proposal',length(theta)),levels=my.levels)
	);
DF.temp <- rbind(DF.posterior,DF.proposal);
qplot(data = DF.temp, x = theta, y = density, colour = type, geom = "line");
dev.off();

png("Fig06_SIR-posterior-to-proposal-ratio.png");
qplot(
	data = data.frame(
		theta = theta,
		ratio = posterior.to.proposal.ratio
		),
	x = theta,
	y = ratio,
	geom = "line"
	);
dev.off();

### function to perform rejection SIR (sample importance resampling)
perform.SIR <- function(target.pdf = NULL, proposal.pdf = NULL, rproposal = NULL, proposal.sample.size = NULL, SIR.sample.size = NULL) {

	proposal.sample <- rproposal(sample.size = proposal.sample.size);

	target.density   <- target.pdf(proposal.sample);
	proposal.density <- proposal.pdf(proposal.sample);

	SIR.density <- target.density / proposal.density;
	SIR.density <- SIR.density / sum(SIR.density);

	SIR.sample <- sample(
		size    = SIR.sample.size,
		x       = proposal.sample,
		prob    = SIR.density,
		replace = TRUE
		);

	return(SIR.sample);

	}

### generate sample from posterior distribution via SIR
proposal.sample.size <- 4 * (1e+6);
SIR.sample.size      <- 5 * (1e+5);
my.SIR.sample <- perform.SIR(
	target.pdf           = target.pdf,
	proposal.pdf         = proposal.pdf,
	rproposal            = rproposal,
	proposal.sample.size = proposal.sample.size,
	SIR.sample.size      = SIR.sample.size
	);
str(my.SIR.sample);
summary(my.SIR.sample);
length(my.SIR.sample);

###  graphical comparison of posterior sample obtained via SIR and the posterior density function 
png("Fig07_SIR-sample-density.png");
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_line(
	data = data.frame(
		theta   = theta,
		density = posterior.density
		),
	aes(x = theta, y = density),
	colour = "red"
	);
my.ggplot <- my.ggplot + geom_density(
	data = data.frame(
		theta = my.SIR.sample
		),
	aes(x = theta),
	colour = "black" 
	);
my.ggplot <- my.ggplot + xlim(range(my.SIR.sample));
my.ggplot;
dev.off();

###  estimate of posterior probability P(theta > 0 | data) that theta is positive
###  (i.e. the coin is biased towards heads) based on estimated posterior density on a grid:
sum(grid.size * posterior.density[theta > 0]);

###  estimate of P(theta > 0 | data) based on the approximating Gaussian distribution:
pnorm(q = 0, mean = posterior.mean, sd = posterior.sd, lower.tail = FALSE);

### estimate of P(theta > 0 | data) based on rejection sampling:
mean(my.rejection.sample > 0);

### estimate of P(theta > 0 | data) based on SIR (sample importance resampling):
mean(my.SIR.sample > 0);

