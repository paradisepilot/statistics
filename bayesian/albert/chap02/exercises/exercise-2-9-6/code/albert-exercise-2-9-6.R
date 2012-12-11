
command.arguments <- commandArgs(trailingOnly = TRUE);
output.directory  <- command.arguments[1];

####################################################################################################
setwd(output.directory);
library(LearnBayes);
library(ggplot2);

### 2.9.6(a) #######################################################################################
lambdas <- seq(0.5,3,0.5);
priors  <- c(10,20,30,20,15,5)/100;

t <- 6;
y <- 12;
likelihoods <- exp(- t * lambdas) * (t * lambdas)^y / factorial(y);
posteriors  <- priors * likelihoods;
posteriors  <- posteriors / sum(posteriors);
DF.temp <- data.frame(
	lambda     = lambdas,
	prior      = priors,
	likelihood = likelihoods,
	posterior  = posteriors
	);
DF.temp;
colSums(DF.temp);

### 2.9.6(b) #######################################################################################
DF.temp <- cbind(
	DF.temp,
	p.week.wo.breakdowns = exp(- 7 * DF.temp[,'lambda'])
	);
DF.temp;

### posterior probability of there being
### no breakdowns in a week is given by:
sum(DF.temp[,'p.week.wo.breakdowns'] * DF.temp[,'posterior']);

