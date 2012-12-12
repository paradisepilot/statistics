
command.arguments <- commandArgs(trailingOnly = TRUE);
output.directory  <- command.arguments[1];

####################################################################################################
setwd(output.directory);
library(LearnBayes);
library(ggplot2);

####################################################################################################
### 3.9.4(a)
sample.size <- 1e+6;

p <- seq(0,1,1e-4);
prior1.density <- dbeta(x = p,           shape1 = 100, shape2 = 100);
prior1.sample  <- rbeta(n = sample.size, shape1 = 100, shape2 = 100);

prior2.density <- 0.9 * dbeta(x=p,shape1=500,shape2=500) + 0.1 * dbeta(x=p,shape1=1,shape2=1);
prior2.density <- prior2.density / sum(prior2.density);
prior2.sample  <- sample(size = sample.size, x = p, prob = prior2.density, replace =TRUE);

sum(0.44 < prior1.sample & prior1.sample < 0.56) / length(prior1.sample);
sum(0.44 < prior2.sample & prior2.sample < 0.56) / length(prior2.sample);

png("Fig1_the-two-priors.png");
DF.prior1 <- data.frame(
	value            = prior1.sample,
	prior            = rep("prior 1",length(prior1.sample)),
	stringsAsFactors = FALSE
	);
DF.prior2 <- data.frame(
	value          = prior2.sample,
	prior            = rep("prior 2",length(prior2.sample)),
	stringsAsFactors = FALSE
	);
DF.temp <- rbind(DF.prior1,DF.prior2);
qplot(data = DF.temp, x = value, color = prior, geom = "density");
dev.off();

### 3.9.4(b)
n.obs       <- 100;
n.successes <- 45;
n.failures  <- n.obs - n.successes;

likelihoods <- (p^n.successes) * (1-p)^(n.failures);
posterior1.density <- prior1.density * likelihoods;
posterior1.density <- posterior1.density / sum(posterior1.density);
posterior2.density <- prior2.density * likelihoods;
posterior2.density <- posterior2.density / sum(posterior2.density);

posterior1.sample  <- sample(size = sample.size, x = p, prob = posterior1.density, replace =TRUE);
posterior2.sample  <- sample(size = sample.size, x = p, prob = posterior2.density, replace =TRUE);

quantile(x = posterior1.sample, probs = c(0.05,0.95));
quantile(x = posterior2.sample, probs = c(0.05,0.95));

png("Fig2_posteriors-45-out-of-100.png");
DF.posterior1 <- data.frame(
	value            = posterior1.sample,
	prior            = rep("posterior 1",length(posterior1.sample)),
	stringsAsFactors = FALSE
	);
DF.posterior2 <- data.frame(
	value          = posterior2.sample,
	prior            = rep("posterior 2",length(posterior2.sample)),
	stringsAsFactors = FALSE
	);
DF.temp <- rbind(DF.posterior1,DF.posterior2);
qplot(data = DF.temp, x = value, color = prior, geom = "density");
dev.off();

### 3.9.4(c)
n.obs       <- 100;
n.successes <- 30;
n.failures  <- n.obs - n.successes;

likelihoods <- (p^n.successes) * (1-p)^(n.failures);
posterior1.density <- prior1.density * likelihoods;
posterior1.density <- posterior1.density / sum(posterior1.density);
posterior2.density <- prior2.density * likelihoods;
posterior2.density <- posterior2.density / sum(posterior2.density);

posterior1.sample  <- sample(size = sample.size, x = p, prob = posterior1.density, replace =TRUE);
posterior2.sample  <- sample(size = sample.size, x = p, prob = posterior2.density, replace =TRUE);

quantile(x = posterior1.sample, probs = c(0.05,0.95));
quantile(x = posterior2.sample, probs = c(0.05,0.95));

png("Fig3_posteriors-30-out-of-100.png");
DF.posterior1 <- data.frame(
	value            = posterior1.sample,
	prior            = rep("posterior 1",length(posterior1.sample)),
	stringsAsFactors = FALSE
	);
DF.posterior2 <- data.frame(
	value          = posterior2.sample,
	prior            = rep("posterior 2",length(posterior2.sample)),
	stringsAsFactors = FALSE
	);
DF.temp <- rbind(DF.posterior1,DF.posterior2);
qplot(data = DF.temp, x = value, color = prior, geom = "density");
dev.off();

### 3.9.4(d)
#
#  In 3.9.4(b), the inference seems more robust, in the sense that the 90% credible
#  intervals obtained via the two prior distributions agree quite well.
#  They are (0.4360, 0.5308) and (0.4684, 0.5204), respectively.
#  Also, an examination of the graphs of the two posterior densities shows that the
#  two posterior distributions moderately agree.
#
#  In 3.9.4(c), the inference seems non-robust, in the sense that the 90% credible
#  intervales obtained via the two prior distributions do NOT agree well.
#  They are (0.3866, 0.4806) and (0.2323, 0.4131), respectively.
#  Also, an examination of the graphs of the two posterior densities shows that the
#  two posterior distributions differ non-trivially.
#  Most notably, Posterior 1 remains unimodal, while Posterior 2 is bimodal.
#

