
command.arguments <- commandArgs(trailingOnly = TRUE);
output.directory  <- command.arguments[1];

####################################################################################################
setwd(output.directory);
library(LearnBayes);
library(ggplot2);

####################################################################################################
### 3.9.7(a)
lambda <- 0.03 * seq(0,1,1e-3);
prior.density <- 0.5 * dgamma(x = lambda, shape = 1.5, rate = 1000) + 0.5 * dgamma(x = lambda, shape = 7,   rate = 1000);
prior.density <- prior.density / sum(prior.density);

png("Fig1_prior-density.png");
qplot(
	data = data.frame(lambda = lambda, prior.density = prior.density),
	x    = lambda,
	y    = prior.density,
	geom = "line"
	);
dev.off();

### 3.9.7(b)
y.obs    <- 4;
exposure <- 1767;

likelihood        <- dpois(x = y.obs, lambda = exposure * lambda);
posterior.density <- prior.density * likelihood;
posterior.density <- posterior.density / sum(posterior.density);

temp <- poisson.gamma.mix(
	probs    = c(0.5,0.5),
	gammapar = rbind(c(1.5,1000),c(7,1000)),
	data     = list(y = y.obs, t = exposure)
	);
str(temp);
component1 <- dgamma(x = lambda, shape = temp[['gammapar']][1,1], rate = temp[['gammapar']][1,2]);
component2 <- dgamma(x = lambda, shape = temp[['gammapar']][2,1], rate = temp[['gammapar']][2,2]);
posterior.albert <- temp[['probs']][1] * component1 + temp[['probs']][2] * component2;
posterior.albert <- posterior.albert / sum(posterior.albert);

all.equal(posterior.density, posterior.albert);
# cbind(posterior.density, posterior.albert);

png("Fig2_posterior-density.png");
qplot(
	data = data.frame(lambda = lambda, posterior.density = posterior.density),
	x    = lambda,
	y    = posterior.density,
	geom = "line"
	);
dev.off();

### 3.9.7(c)
png("Fig3_prior-posterior.png");
DF.prior <- data.frame(
	lambda           = lambda,
	density          = prior.density,
	type             = rep("prior",length(lambda)),
	stringsAsFactors = FALSE
	);
DF.posterior <- data.frame(
	lambda           = lambda,
	density          = posterior.density,
	type             = rep("posterior",length(lambda)),
	stringsAsFactors = FALSE
	);
DF.temp <- rbind(DF.prior,DF.posterior);
DF.temp[,'type'] <- factor(DF.temp[,'type'],levels=c('prior','posterior'));
qplot(
	data  = DF.temp,
	x     = lambda,
	y     = density,
	color = type,
	geom  = "line"
	);
dev.off();

### 3.9.7(d)
sum(posterior.density[lambda > 0.005]);

### 3.9.7(e)
png("Fig4_prior-components.png");
DF.component1 <- data.frame(
	lambda           = lambda,
	density          = dgamma(x = lambda, shape = 1.5, rate = 1000),
	type             = rep("beta(1.5,1000)",length(lambda)),
	stringsAsFactors = FALSE
	);
DF.component2 <- data.frame(
	lambda           = lambda,
	density          = dgamma(x = lambda, shape = 7, rate = 1000),
	type             = rep("beta(7,1000)",length(lambda)),
	stringsAsFactors = FALSE
	);
DF.temp <- rbind(DF.component1,DF.component2);
DF.temp[,'type'] <- factor(DF.temp[,'type'],levels=c('beta(1.5,1000)','beta(7,1000)'));
qplot(
	data  = DF.temp,
	x     = lambda,
	y     = density,
	color = type,
	geom  = "line"
	);
dev.off();

#
#  The data appear to be more consistent with the beliefs of the first expert,
#  namely, the data appear to be more consistent with the beta(1.5,1000) component
#  of the prior than they are with the beta(7,1000) component.
#
#  This comment is made based on the observation that the posterior density
#  resembles the beta(1.5,1000) component more than it does the beta(7,1000) component.
#
