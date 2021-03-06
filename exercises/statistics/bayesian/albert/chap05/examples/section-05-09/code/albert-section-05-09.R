
command.arguments <- commandArgs(trailingOnly = TRUE);
output.directory  <- command.arguments[1];
code.directory    <- command.arguments[2];

####################################################################################################
library(LearnBayes);
library(ggplot2);
library(scales);
#library(sn);

setwd(output.directory);

### AUXILIAR FUNCTIONS #############################################################################
beta.binom.conditional <- function(log.K = NULL, data = NULL) {

	theta1 <- -6.818793;
	eta    <- exp(theta1) / (1 + exp(theta1));

	K <- exp(log.K);

	y <- data[,1];
	n <- data[,2];
	N <- length(y);

	logf <- numeric(length = length(log.K));
	for (i in 1:length(log.K)) {
		logf[i] <- sum(
			   lbeta(K[i] * eta + y, K[i] * (1 - eta) + n - y)
			 - lbeta(K[i] * eta,     K[i] * (1 - eta))
			);
		}
	logf <- logf + log.K - 2 * log(1 + K);

	output.value <- exp(logf - max(logf));
	return(output.value);

	}

log.posterior.beta.binomial.tranformed <- function(parameters = NULL, data = NULL) {
        
        eta <- exp(parameters[1]) / (1 + exp(parameters[1]));
        K   <- exp(parameters[2]);

        y <- data[,1];
        n <- data[,2];

        N <- length(y);

        output.value <- lbeta(K * eta + y, K * (1 - eta) + n - y) - lbeta(K * eta, K * (1 - eta));
        output.value <- sum(output.value);
        output.value <- output.value - 2 * log(1 + K) - log(eta) - log(1 - eta);

        return(output.value);

        }

### SECTION 5.9 ####################################################################################
integrate.results <- integrate(
	f     = beta.binom.conditional,
	lower = 2,
	upper = 16,
	data  = cancermortality
	);
integrate.results;

### reproduction of Fig. 5.5, p.104
png("Fig5-05-A.png");
my.levels <- c('beta.binom','gaussian');
x.values <- 0 + (20-0) * seq(0,1,1e-3);
beta.binom.conditional.density <- beta.binom.conditional(
	log.K = x.values,
	data = cancermortality
	)/integrate.results[['value']];
gaussian.density <- dnorm(x = x.values, mean = 8, sd = 2);
DF.beta.binom.conditional <- data.frame(
	x            = x.values,
	density      = beta.binom.conditional.density,
	distribution = factor(rep('beta.binom',length(x.values)), levels=my.levels)
	);
DF.gaussian <- data.frame(
	x            = x.values,
	density      = gaussian.density,
	distribution = factor(rep('gaussian',length(x.values)), levels=my.levels)
	);
DF.temp <- rbind(DF.beta.binom.conditional,DF.gaussian);
qplot(data = DF.temp, x = x, y = density, colour = distribution, geom = "line");
dev.off();

png("Fig5-05-B.png");
DF.temp <- data.frame(
	x      = x.values,
	weight = beta.binom.conditional.density / gaussian.density
	);
qplot(data = DF.temp[x.values < 16,], x = x, y = weight, geom = "line");
dev.off();

png("Fig5-05-C.png");
my.levels <- c('beta.binom','T(8,2,2)');
x.values <- 3 + (16-3) * seq(0,1,1e-3);
scaled.t2.density <- sn::dst(x = x.values, location = 8, scale = 2, df = 2);
DF.beta.binom.conditional <- data.frame(
	x            = x.values,
	density      = beta.binom.conditional.density,
	distribution = factor(rep('beta.binom',length(x.values)), levels=my.levels)
	);
DF.t2 <- data.frame(
	x            = x.values,
	density      = scaled.t2.density,
	distribution = factor(rep('T(8,2,2)',length(x.values)), levels=my.levels)
	);
DF.temp <- rbind(DF.beta.binom.conditional,DF.t2);
qplot(data = DF.temp, x = x, y = density, colour = distribution, geom = "line");
dev.off();

png("Fig5-05-D.png");
DF.temp <- data.frame(
	x      = x.values,
	weight = beta.binom.conditional.density / scaled.t2.density
	);
qplot(data = DF.temp[x.values < 16,], x = x, y = weight, geom = "line");
dev.off();

### perform importance sampling
fit <- laplace(log.posterior.beta.binomial.tranformed, c(-6,7), cancermortality);
fit;

importance.sampling.results <- impsampling(
	logf = log.posterior.beta.binomial.tranformed,
	tpar = tpar.list <- list(m = fit$mode, var = 2 * fit$var, df = 4),
	h    = function(x) {return(x[2]);},
	n    = 1e+4,
	data = cancermortality
	);
str(importance.sampling.results);
summary(importance.sampling.results[['wt']]);

png("histogram-importance-sampling-weights.png");
qplot(x = importance.sampling.results[['wt']], geom = 'histogram', binwidth = 0.01);
dev.off();

