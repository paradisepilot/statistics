
command.arguments <- commandArgs(trailingOnly = TRUE);
output.directory  <- command.arguments[1];

####################################################################################################
setwd(output.directory);
library(LearnBayes);
library(ggplot2);
library(scales);

### SECTION 4.3 ####################################################################################

### Fig. 4.2, p.67
sample.size            <- 1e+5;
alpha.parameters       <- c(728,584,138);
theta.posterior.sample <- rdirichlet(n = sample.size, par = alpha.parameters);
colnames(theta.posterior.sample) <- c('theta1','theta2','theta3');
str(theta.posterior.sample);

png("Fig4-2_histogram-theta1-minus-theta2.png");
qplot(
	x        = theta.posterior.sample[,'theta1'] - theta.posterior.sample[,'theta2'],
	geom     = "histogram",
	binwidth = 0.005
	);
dev.off();

### Fig. 4.3, p.69
data(election.2008);
election.2008[,'other'] <- 100 - election.2008[,'M.pct'] - election.2008[,'O.pct'];

str(election.2008);
summary(election.2008);

# Estimate the statewise posterior probability that the proportion of Obama
# voters is higher than that of McCain voters in a given state, via sampling
# from the joint posterior distribution of (theta_M_j, theta_O_j, theta_other_j).
statewise.probability.Obama.win <- function(i) {
	alpha.parameters <- 1 + 5 * election.2008[i,c('M.pct','O.pct','other')];
	p <- rdirichlet(n = sample.size, par = as.numeric(alpha.parameters));
	return( mean(p[,2] > p[,1]) );
	}

Obama.win.statewise.probabilities <- sapply(1:51,statewise.probability.Obama.win);
str(Obama.win.statewise.probabilities);
summary(Obama.win.statewise.probabilities);

sum(Obama.win.statewise.probabilities * election.2008[,'EV']);

simulate.election <- function() {
	winner = rbinom(n = 51, size = 1, prob = Obama.win.statewise.probabilities);
	return( sum(winner * election.2008[,'EV']) );
	}
simulate.election.results <- replicate(10000,simulate.election());
str(simulate.election.results);
summary(simulate.election.results);

png("Fig4-3_histogram-election-2008.png");
qplot(x = simulate.election.results, geom = "histogram", binwidth = 1);
dev.off()

