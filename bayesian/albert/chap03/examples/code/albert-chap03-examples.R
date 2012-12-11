
command.arguments <- commandArgs(trailingOnly = TRUE);
output.directory  <- command.arguments[1];

####################################################################################################
setwd(output.directory);
library(LearnBayes);
library(ggplot2);

### SECTION 3.2 ####################################################################################
data(footballscores);
str(footballscores);

### Fig. 3.1, p.41 
n <- nrow(footballscores);
d <- footballscores[,'favorite'] - footballscores[,'underdog'] - footballscores[,'spread'];
v <- sum(d^2);

sample.size <- 1e+5;
P <- rchisq(n = sample.size, df = n) / v;
s <- sqrt(1/P);

### point and interval estimates for sigma:
quantile(x = s, probs = c(0.025, 0.5, 0.975));

png("Fig3-1_histogram-sampled-standard-deviations.png");
qplot(x = s, geom = c("histogram"), binwidth = 0.05);
dev.off();

### SECTION 3.3 ####################################################################################
alpha       <- 16;
beta        <- 15174;
y           <- seq(0,10,1);
sample.size <- 1e+5;

### Hospital A prior predictive density, p.43
y.observed <- 1;
exposure   <- 66;

lambda.prior.sample.A <- rgamma(n = sample.size, shape = alpha, rate = beta);
temp <- t(sapply(
	X   = y,
	FUN = function(x) { return(dpois(x = x, lambda = exposure * lambda.prior.sample.A)); }
	));
prior.predictive.density <- rowMeans(temp);

### Hospital A posterior predictive density
lambda.posterior.sample.A <- rgamma(
	n     = sample.size,
	shape = alpha + y.observed,
	rate  = beta + exposure
	);
temp <- t(sapply(
	X   = y,
	FUN = function(x) { return(dpois(x = x, lambda = exposure * lambda.posterior.sample.A)); }
	));
posterior.predictive.density <- rowMeans(temp);

sum(prior.predictive.density);
sum(posterior.predictive.density);
cbind(
	y,
	prior.predictive     = round(prior.predictive.density,5),
	posterior.predictive = round(posterior.predictive.density,5)
	);

### Hospital B prior predictive density, p.43
y.observed <- 4;
exposure   <- 1767;

lambda.prior.sample.B <- rgamma(n = sample.size, shape = alpha, rate = beta);
temp <- t(sapply(
	X   = y,
	FUN = function(x) { return(dpois(x = x, lambda = exposure * lambda.prior.sample.B)); }
	));
prior.predictive.density <- rowMeans(temp);

### Hospital B posterior predictive density
lambda.posterior.sample.B <- rgamma(
	n     = sample.size,
	shape = alpha + y.observed,
	rate  = beta + exposure
	);
temp <- t(sapply(
	X   = y,
	FUN = function(x) { return(dpois(x = x, lambda = exposure * lambda.posterior.sample.B)); }
	));
posterior.predictive.density <- rowMeans(temp);

sum(prior.predictive.density);
sum(posterior.predictive.density);
cbind(
	y,
	prior.predictive     = round(prior.predictive.density,5),
	posterior.predictive = round(posterior.predictive.density,5)
	);

### Fig. 3.2, p.45
png("Fig3-2_hospital-A-prior-posterior-densities.png");
DF.prior <- data.frame(
	lambda = lambda.prior.sample.A,
	type = rep("prior",length(lambda.prior.sample.A))
	);
DF.posterior <- data.frame(
	lambda = lambda.posterior.sample.A,
	type = rep("posterior",length(lambda.posterior.sample.A))
	);
DF.temp <- rbind(DF.prior,DF.posterior);
qplot(data = DF.temp, x = lambda, color = type, geom = c("density"));
dev.off();

png("Fig3-2_hospital-B-prior-posterior-densities.png");
DF.prior <- data.frame(
	lambda = lambda.prior.sample.B,
	type = rep("prior",length(lambda.prior.sample.B))
	);
DF.posterior <- data.frame(
	lambda = lambda.posterior.sample.B,
	type = rep("posterior",length(lambda.posterior.sample.B))
	);
DF.temp <- rbind(DF.prior,DF.posterior);
qplot(data = DF.temp, x = lambda, color = type, geom = c("density"));
dev.off();

### SECTION 3.4 ####################################################################################

