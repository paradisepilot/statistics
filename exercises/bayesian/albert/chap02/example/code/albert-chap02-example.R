
command.arguments <- commandArgs(trailingOnly = TRUE);
output.directory  <- command.arguments[1];

####################################################################################################
setwd(output.directory);
library(LearnBayes);
library(ggplot2);

### Fig. 2.1, p.21 #################################################################################
proportions <- seq(0.05,0.95,0.1);
priors      <- c(1,5.2,8,7.2,4.6,2.1,0.7,0.1,0,0);
priors      <- priors/sum(priors);

png("Fig2-1_prior-probability-vs-proportion.png");
DF.temp <- data.frame(proportion = proportions, prior = priors);
print( DF.temp );
qplot(
	data = DF.temp,
	x    = proportion,
	y    = prior,
	geom = c("point","line")
	);
dev.off();


### Fig. 2.2, p.23 #################################################################################
n <- 27;
s <- 11;

likelihoods <- (proportions^s)*(1-proportions)^(n-s);
posteriors  <- priors * likelihoods;
posteriors  <- posteriors / sum(posteriors);

DF.prior <- data.frame(
	proportion       = proportions,
	probability      = priors,
	type             = rep("prior",length(proportions)),
	stringsAsFactors = FALSE
	);

DF.posterior <- data.frame(
	proportion       = proportions,
	probability      = posteriors,
	type             = rep("posterior",length(proportions)),
	stringsAsFactors = FALSE
	);

png("Fig2-2_prior-posterior-vs-proportion.png");
DF.temp <- rbind(DF.prior,DF.posterior);
DF.temp[,'type'] <- factor(DF.temp[,'type'],levels=c('prior','posterior'));
print( DF.temp );
qplot(
	data  = DF.temp,
	x     = proportion,
	y     = probability,
	color = type,
	geom  = c("point","line")
	);
dev.off();


### Fig. 2.3, p.25 #################################################################################
temp <- beta.select(
	quantile1 = list(p=0.9,x=0.5),
	quantile2 = list(p=0.5,x=0.3)
	);
a <- temp[1];
b <- temp[2];
print( a );
print( b );

n <- 27;
s <- 11;
proportions <- seq(0,1,0.01);

priors      <- dbeta(x = proportions, shape1 = a,     shape2 = b);
likelihoods <- dbeta(x = proportions, shape1 = s,     shape2 = n - s);
posteriors  <- dbeta(x = proportions, shape1 = a + s, shape2 = b + n - s);

DF.prior <- data.frame(
	proportion       = proportions,
	value            = priors,
	type             = "prior",
	stringsAsFactors = FALSE
	);

DF.likelihood <- data.frame(
	proportion       = proportions,
	value            = likelihoods,
	type             = "likelihood",
	stringsAsFactors = FALSE
	);

DF.posterior <- data.frame(
	proportion       = proportions,
	value            = posteriors,
	type             = "posterior",
	stringsAsFactors = FALSE
	);

png("Fig2-3_beta-prior.png");
DF.temp <- rbind(DF.prior, DF.likelihood, DF.posterior);
DF.temp[,'type'] <- factor(DF.temp[,'type'],levels=c('prior','likelihood','posterior'));
print( DF.temp );
qplot(
	data  = DF.temp,
	x     = proportion,
	y     = value,
	color = type,
	geom  = c("point","line")
	);
dev.off();

1 - pbeta(0.5, shape1 = a    + s,  shape2 = b    + n - s);
1 - pbeta(0.5, shape1 = 3.26 + 11, shape2 = 7.19 + 16);

posterior.sample <- rbeta(n = 10000, shape1 = a + s, shape2 = b + n - s);
sum(posterior.sample > 0.5) / length(posterior.sample);

qbeta(p = c(0.05,0.95), shape1 = a + s, shape2 = b + n - s);
quantile(x = posterior.sample, probs = c(0.05,0.95));

### Fig. 2.4, p.26 #################################################################################
png("Fig2-4_posterior-sample-histogram.png");
DF.temp <- data.frame(posterior.sample = posterior.sample);
qplot(
	data  = DF.temp,
	x     = posterior.sample,
	geom  = c("histogram")
	);
dev.off();

### Fig. 2.5, p.28 #################################################################################
mid.points <- seq(0.05,0.95,0.1);
priors     <- c(1,5.2,8,7.2,4.6,2.1,0.7,0.1,0,0);
priors     <- priors/sum(priors);

proportions     <- seq(0,1,0.001);
prior.densities <- histprior(p=proportions,midpts=mid.points,prob=priors);

png("Fig2-5_histogram-prior.png");
DF.temp <- data.frame(proportion = proportions, prior.density = prior.densities);
qplot(
	data  = DF.temp,
	x     = proportion,
	y     = prior.density,
	geom  = c("line")
	);
dev.off();

### Fig. 2.6, p.29 #################################################################################
mid.points <- seq(0.05,0.95,0.1);
priors     <- c(1,5.2,8,7.2,4.6,2.1,0.7,0.1,0,0);
priors     <- priors/sum(priors);

proportions     <- seq(0,1,0.001);
prior.densities <- histprior(p=proportions,midpts=mid.points,prob=priors);

n <- 27;
s <- 11;
likelihoods <- dbeta(x = proportions, shape1 = s, shape2 = n - s);

posterior.densities <- prior.densities * likelihoods;
posterior.densities <- posterior.densities / sum(posterior.densities);

png("Fig2-6_posterior-histogram-prior.png");
DF.temp <- data.frame(proportion = proportions, posterior.density = posterior.densities);
qplot(
	data  = DF.temp,
	x     = proportion,
	y     = posterior.density,
	geom  = c("line")
	);
dev.off();

### Fig. 2.7, p.30 #################################################################################
sample.size <- 10000;
posterior.sample <- sample(
	x       = proportions,
	prob    = posterior.densities,
	size    = sample.size,
	replace = TRUE
	);

png("Fig2-7_posterior-sample-histogram-prior.png");
DF.temp <- data.frame(posterior.sample = posterior.sample);
qplot(
	data  = DF.temp,
	x     = posterior.sample,
	geom  = c("histogram")
	);
dev.off();

### Fig. 2.8, p.33 #################################################################################
num.of.trials <- 20;
y <- rbinom(
	n    = length(posterior.sample),
	size = num.of.trials,
	prob = posterior.sample
	);
length(y);
table(y);
as.data.frame(table(y));

png("Fig2-8_prediction.png");
DF.temp <- as.data.frame(table(y));
qplot(
	data  = DF.temp,
	x     = y,
	y     = Freq,
	geom  = c("point")
	);
dev.off();

