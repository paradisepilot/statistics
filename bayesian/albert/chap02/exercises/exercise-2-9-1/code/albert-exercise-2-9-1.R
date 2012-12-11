
command.arguments <- commandArgs(trailingOnly = TRUE);
output.directory  <- command.arguments[1];

####################################################################################################
setwd(output.directory);
library(LearnBayes);
library(ggplot2);

####################################################################################################
p <- seq(0,1,0.125);
priors <- c(0.001,0.001,0.95,rep(0.08,6));
priors <- priors / sum(priors);

num.of.trials    <- 10;
num.of.successes <- 6;

### compute posterior probabilities using LearnBayes::pdisc
pdisc.output <- pdisc(
	p     = p,
	prior = priors,
	data  = c(num.of.successes,num.of.trials-num.of.successes)
	);

### compute posterior probabilities from first principle
likelihoods <- dbinom(
	x    = num.of.successes,
	size = num.of.trials,
	prob = p
	);

posteriors <- priors * likelihoods;
posteriors <- posteriors / sum(posteriors);

DF.temp <- data.frame(
	p          = p,
	prior      = priors,
	likelihood = likelihoods,
	posterior  = posteriors,
	pdisc      = pdisc.output
	);
print( DF.temp );

colSums(DF.temp);

### the posterior probability that Bob does NOT have
### ESP (extrasensory perception) is given by:
sum(DF.temp[DF.temp[,'p']>0.25,'posterior']);

