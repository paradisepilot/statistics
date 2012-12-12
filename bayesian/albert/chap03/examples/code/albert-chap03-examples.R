
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
temp <- normal.select(quantile1 = list(p=0.5,x=100), quantile2 = list(p=0.95,x=120));
mu  <- temp[['mu']];
tau <- temp[['sigma']];
mu;
tau;

### Recall that:
### If   (a)  theta ~ N(mu,tau^2), and
###      (b)  Y.bar | theta ~ N(theta,(sigma^2)/n),
### then
###      theta | Y.bar ~ N( B*mu + (1-B)*Y.bar , (1-B)*(sigma^2)/n ),
### where n = number of observations, and B = ((sigma^2)/n) / ((sigma^2)/n + tau^2).
### See, for example, p.19, Bayesian Methods for Data Analysis, 3rd. ed. (2009),
### by Bradley P. Carlin and Thomas A. Louis, 

sigma <- 15;
n.observations <- 4;
y.bar <- c(110,125,140);

B <- (sigma^2/n.observations) / (sigma^2/n.observations + tau^2);
data.frame(
	y.bar = y.bar,
	mu1   = B*mu + (1-B)*y.bar,
	tau1  = rep(sqrt((1-B)*sigma^2/n.observations),length(y.bar))
	);

### Fig. 3.3, p.48
png("Fig3-3_normal-and-t-distributions.png");
my          <- 100;
sigma       <- 15;
deg.freedom <- 2;
scale       <- 20 / qt(p = 0.95, df = 2);
print(scale);

theta <- seq(mu-50,mu+50,0.001);
DF.Gaussian <- data.frame(
	theta         = theta,
	prior.density = dnorm(x = theta, mean = mu, sd = tau), 
	distribution  = rep("Gaussian",length(theta))
	);
DF.Student.t <- data.frame(
	theta         = theta,
	prior.density = dt(x = (theta-mu)/scale, df = deg.freedom)/scale, 
	distribution  = rep("Student.t",length(theta))
	);
DF.temp <- rbind(DF.Gaussian,DF.Student.t);
qplot(data = DF.temp, x = theta, y = prior.density, color = distribution, geom = c("line"));
dev.off();

### Fig. 3.4, p.50
png("Fig3-4_posteriors-with-normal-and-t-priors.png");
n.observations <- 4;
temp <- normal.select(quantile1 = list(p=0.5,x=100), quantile2 = list(p=0.95,x=120));
mu  <- temp[['mu']];
tau <- temp[['sigma']];
mu;
tau;

sigma          <- 15;
y.bar          <- 140;

deg.freedom <- 2;
scale <- 20 / qt(p = 0.95, df = 2);

theta <- seq(mu-6*sigma,mu+6*sigma,0.001);

B <- (sigma^2/n.observations) / (sigma^2/n.observations + tau^2);
Gaussian.posterior.mean    <- B * mu + (1-B) * y.bar;
Gaussian.posterior.sd      <- sqrt((1-B) * sigma^2);
Gaussian.posterior.density <- dnorm(
	x    = theta,
	mean = Gaussian.posterior.mean,
	sd   = Gaussian.posterior.sd
	); 
Gaussian.posterior.density <- Gaussian.posterior.density / sum(Gaussian.posterior.density); 

t.prior.density     <- dt(x = (theta-mu)/scale, df = deg.freedom); 
t.likelihood        <- dnorm(x = y.bar, mean = theta, sd = sigma/sqrt(n.observations));
t.posterior.density <- t.prior.density * t.likelihood;
t.posterior.density <- t.posterior.density / sum(t.posterior.density);

DF.Gaussian <- data.frame(
	theta             = theta,
	posterior.density = Gaussian.posterior.density,
	prior             = rep("Gaussian",length(theta))
	);
DF.Student.t <- data.frame(
	theta             = theta,
	posterior.density = t.posterior.density, 
	prior             = rep("Student.t",length(theta))
	);
DF.temp <- rbind(DF.Gaussian,DF.Student.t);
qplot(data = DF.temp, x = theta, y = posterior.density, color = prior, geom = c("line"));
dev.off();

#cbind(
#	theta,
#	dnorm(x = y.bar, mean = theta, sd = sigma/sqrt(n.observations)),
#	dnorm(x = theta, mean = y.bar, sd = sigma/sqrt(n.observations))
#	);

### SECTION 3.5 ####################################################################################
mixing.probabilities <- c(0.5,0.5);
beta.par1            <- c(6,14);
beta.par2            <- rev(beta.par1);

temp <- binomial.beta.mix(
	probs   = mixing.probabilities,
	betapar = rbind(beta.par1,beta.par2),
	data    = c(7,3)
	);
print(temp);

p <- seq(0,1,0.001);
prior.density.1     <- dbeta(x = p, shape1 = beta.par1[1], shape2 = beta.par1[2]);
prior.density.2     <- dbeta(x = p, shape1 = beta.par2[1], shape2 = beta.par2[2]);
prior.density       <- mixing.probabilities[1] * prior.density.1 + mixing.probabilities[2] * prior.density.2;
prior.density       <- prior.density / sum(prior.density);

posterior.density.1 <- dbeta(x = p, shape1 = temp[['betapar']][1,1], shape2 = temp[['betapar']][1,2]);
posterior.density.2 <- dbeta(x = p, shape1 = temp[['betapar']][2,1], shape2 = temp[['betapar']][2,2]);
posterior.density   <- temp[['probs']][1] * posterior.density.1 + temp[['probs']][2] * posterior.density.2;

posterior.density       <- posterior.density / sum(posterior.density);

png("Fig3-5_mixture-prior.png");
DF.prior <- data.frame(
	p                = p,
	density          = prior.density,
	type             = rep("prior",length(p)),
	stringsAsFactors = FALSE
	);
DF.posterior <- data.frame(
	p                = p,
	density          = posterior.density,
	type             = rep("posterior",length(p)),
	stringsAsFactors = FALSE
	);
DF.temp <- rbind(DF.prior,DF.posterior);
qplot(data = DF.temp, x = p, y = density, color = type, geom = c("line"));
dev.off();

### SECTION 3.6 ####################################################################################

