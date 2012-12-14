
command.arguments <- commandArgs(trailingOnly = TRUE);
output.directory  <- command.arguments[1];

####################################################################################################
setwd(output.directory);
library(LearnBayes);
library(ggplot2);
library(scales);

### AUXILIARY FUNCTIONS ############################################################################
log.joint.posterior.alpha.lambda <- function(theta = NULL, data = NULL) {
	alpha         <- theta[1];
	lambda        <- theta[2];
	y             <- data[['observed']];
	log.posterior <- sum(dgamma(x = y, shape = alpha, scale = lambda, log = TRUE));
	return(log.posterior);
	}

log.joint.posterior.alpha.beta <- function(theta = NULL, data = NULL) {
	alpha         <- theta[1];
	beta          <- theta[2];
	y             <- data[['observed']];
	log.posterior <- sum(dgamma(x = y, shape = alpha, rate = beta, log = TRUE));
	return(log.posterior);
	}

log.joint.posterior.alpha.mu <- function(theta = NULL, data = NULL) {
	alpha         <- theta[1];
	mu            <- theta[2];
	beta          <- alpha / mu;
	y             <- data[['observed']];
	log.posterior <- sum(dgamma(x = y, shape = alpha, rate = beta, log = TRUE));
	return(log.posterior);
	}

my.simcontour <- function(logf = NULL, limits = NULL, data = NULL, m = NULL) {

	grid.points <- data.frame(
		x = runif(n = m, min = limits[1], max = limits[2]),
		y = runif(n = m, min = limits[3], max = limits[4])
		); 

	log.posterior <- apply(
		X      = grid.points,
		MARGIN = 1,
		FUN    = function(v) {return(logf(theta = v, data = data));}
		);

	posterior <- exp(log.posterior);
	posterior <- posterior / sum(posterior);

	row.sample <- sample(size = m, x = 1:nrow(grid.points), prob = posterior, replace = TRUE);
	DF.temp <- grid.points[row.sample,];
	LIST.output <- list(x = DF.temp[,1], y = DF.temp[,2]);

	return(LIST.output);

	}

### SET-UP #########################################################################################
y.obs   <- c(12.2, 0.9, 0.8, 5.3, 2, 1.2, 1.2, 1, 0.3, 1.8, 3.1, 2.8);
my.data <- list(observed = y.obs);

sample.size <- 1e+6;

### 4.8.7 (a) ######################################################################################
#my.limits   <- 0.01 + (100-0.01) * c(0,1,0,1);
my.limits   <- 0.001 + c(0,5-0.001,0,200-0.001);
posterior.sample <- my.simcontour(
	logf   = log.joint.posterior.alpha.lambda,
	limits = my.limits,
	data   = my.data,
	m      = sample.size
	);
posterior.sample <- as.data.frame(posterior.sample);
colnames(posterior.sample) <- c('alpha','lambda');
str(posterior.sample);
summary(posterior.sample);

png("Fig01_joint-postetrior_alpha-lambda.png");
DF.temp <- data.frame(
	alpha  = posterior.sample[,'alpha'],
	lambda = posterior.sample[,'lambda']
	);
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_point(
	data = DF.temp,
	aes(x = alpha, y = lambda),
	colour = alpha("darkolivegreen",0.2)
	);
my.ggplot;
dev.off();

mu.sample.alpha.lambda <- posterior.sample[,'alpha'] * posterior.sample[,'lambda'];

png("Fig02_mu-histogram_alpha-lambda.png");
qplot(x = mu.sample.alpha.lambda, geom = "histogram", binwidth = 1);
dev.off();

png("Fig03_mu-density_alpha-lambda.png");
qplot(x = mu.sample.alpha.lambda, geom = "density");
dev.off();

quantile(x = mu.sample.alpha.lambda, probs = c(0.05,0.95));

### 4.8.7 (b) ######################################################################################
#my.limits   <- 0.01 + (100-0.01) * c(0,1,0,1);
my.limits   <- 0.001 + c(0,6-0.001,0,6-0.001);
posterior.sample <- my.simcontour(
	logf   = log.joint.posterior.alpha.beta,
	limits = my.limits,
	data   = my.data,
	m      = sample.size
	);
posterior.sample <- as.data.frame(posterior.sample);
colnames(posterior.sample) <- c('alpha','beta');
str(posterior.sample);
summary(posterior.sample);

png("Fig04_joint-postetrior_alpha-beta.png");
DF.temp <- data.frame(
	alpha = posterior.sample[,'alpha'],
	beta  = posterior.sample[,'beta']
	);
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_point(
	data = DF.temp,
	aes(x = alpha, y = beta),
	colour = alpha("darkolivegreen",0.2)
	);
my.ggplot;
dev.off();

mu.sample.alpha.beta <- posterior.sample[,'alpha'] / posterior.sample[,'beta'];

png("Fig05_mu-histogram_alpha-beta.png");
qplot(x = mu.sample.alpha.beta, geom = "histogram", binwidth = 1);
dev.off();

png("Fig06_mu-density_alpha-beta.png");
qplot(x = mu.sample.alpha.beta, geom = "density");
dev.off();

png("Fig07_mu-densities_both-parametrizations.png");
my.levels <- c('alpha-lambda','alpha-beta');
DF.1 <- data.frame(
	density         = mu.sample.alpha.lambda,
	parametrization = factor(rep('alpha-lambda',length(mu.sample.alpha.lambda)),levels=my.levels)
	);
DF.2 <- data.frame(
	density         = mu.sample.alpha.beta,
	parametrization = factor(rep('alpha-beta',length(mu.sample.alpha.beta)),levels=my.levels)
	);
DF.temp <- rbind(DF.1,DF.2);
qplot(data = DF.temp, x = density, color = parametrization, geom = "density");
dev.off();

quantile(x = mu.sample.alpha.lambda, probs = c(0.05,0.95));
quantile(x = mu.sample.alpha.beta,   probs = c(0.05,0.95));

### 4.8.7 (c) ######################################################################################
#my.limits   <- 0.01 + (100-0.01) * c(0,1,0,1);
my.limits   <- 0.001 + c(0,6-0.001,0,70-0.001);
posterior.sample <- my.simcontour(
	logf   = log.joint.posterior.alpha.mu,
	limits = my.limits,
	data   = my.data,
	m      = sample.size
	);
posterior.sample <- as.data.frame(posterior.sample);
colnames(posterior.sample) <- c('alpha','mu');
str(posterior.sample);
summary(posterior.sample);

png("Fig08_joint-postetrior_alpha-mu.png");
DF.temp <- data.frame(
	alpha = posterior.sample[,'alpha'],
	mu    = posterior.sample[,'mu']
	);
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_point(
	data = DF.temp,
	aes(x = alpha, y = mu),
	colour = alpha("darkolivegreen",0.2)
	);
my.ggplot;
dev.off();

mu.sample.alpha.mu <- posterior.sample[,'mu'];

png("Fig09_mu-histogram_alpha-mu.png");
qplot(x = mu.sample.alpha.mu, geom = "histogram", binwidth = 1);
dev.off();

png("Fig10_mu-density_alpha-beta.png");
qplot(x = mu.sample.alpha.mu, geom = "density");
dev.off();

png("Fig11_mu-densities_all-parametrizations.png");
my.levels <- c('alpha-lambda','alpha-beta','alpha-mu');
DF.1 <- data.frame(
	density         = mu.sample.alpha.lambda,
	parametrization = factor(rep('alpha-lambda',length(mu.sample.alpha.lambda)),levels=my.levels)
	);
DF.2 <- data.frame(
	density         = mu.sample.alpha.beta,
	parametrization = factor(rep('alpha-beta',length(mu.sample.alpha.beta)),levels=my.levels)
	);
DF.3 <- data.frame(
	density         = mu.sample.alpha.mu,
	parametrization = factor(rep('alpha-mu',length(mu.sample.alpha.mu)),levels=my.levels)
	);
DF.temp <- rbind(DF.1,DF.2,DF.3);
qplot(data = DF.temp, x = density, color = parametrization, geom = "density");
dev.off();

quantile(x = mu.sample.alpha.lambda, probs = c(0.05,0.95));
quantile(x = mu.sample.alpha.beta,   probs = c(0.05,0.95));
quantile(x = mu.sample.alpha.mu,     probs = c(0.05,0.95));

### 4.8.7 (d) ######################################################################################
#
#  The (alpha,beta)-parametrization seem to be best.
#
#  It gave the smallest 90% credible interval for mu, and it also resulted in the "tightest"
#  posterior distribution for mu.
#
#  Another clear advantage is that the alpha-beta joint posterior distribution has the fewest
#  "outlying" points, in the sense that its density concentrates the best (around an oval region),
#  where the other two posterior distributions (alpha-lambda, and alpha-mu) has points of
#  non-negligible posterior densities extending rather far along the coordinate axes.  These
#  can be observed in the posterior density scatter plots for the three parametrizations.
#

