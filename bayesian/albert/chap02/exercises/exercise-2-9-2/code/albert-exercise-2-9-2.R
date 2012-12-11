
command.arguments <- commandArgs(trailingOnly = TRUE);
output.directory  <- command.arguments[1];

####################################################################################################
setwd(output.directory);
library(LearnBayes);
library(ggplot2);

####################################################################################################
p.heads <- seq(0,1,0.001);

p.heads.midpoints <- seq(0.05,0.95,0.1);
p.subinterval.priors <- c(1,1,1,2,10,10,2,1,1,1);
# p.subinterval.priors <- rep(1,length(p.heads.midpoints));
p.subinterval.priors <- p.subinterval.priors / sum(p.subinterval.priors);
cbind(p.heads.midpoints,p.subinterval.priors);

p.priors <- histprior(
	p      = p.heads,
	midpts = p.heads.midpoints,
	prob   = p.subinterval.priors
	);

png("Fig1_histogram-prior.png");
qplot(
        data  = data.frame(p.heads = p.heads, prior.density = p.priors),
        x     = p.heads,
        y     = prior.density,
        geom  = c("line")
        );
dev.off();

n.trials    <- 30;
n.successes <- 10;
n.failures  <- n.trials - n.successes;

p.likelihoods <- dbinom(
	x    = n.successes,
	size = n.trials,
	prob = p.heads
	);

p.posteriors <- p.priors * p.likelihoods;
p.posteriors <- p.posteriors / sum(p.posteriors);

png("Fig2_posterior-density.png");
qplot(
        data  = data.frame(p.heads = p.heads, posterior.density = p.posteriors),
        x     = p.heads,
        y     = posterior.density,
        geom  = c("line")
        );
dev.off();

sample.size <- 1e+6;
p.posterior.sample <- sample(
	size    = sample.size,
	x       = p.heads,
	prob    = p.posteriors,
	replace = TRUE
	);
p.posterior.sample <- as.data.frame(table(p.posterior.sample));
print( p.posterior.sample );

png("Fig3_posterior-sample.png");
qplot(
        data  = p.posterior.sample,
        x     = p.posterior.sample,
        y     = Freq,
        geom  = c("point")
        );
dev.off();

####################################################################################################

q();

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

