
command.arguments <- commandArgs(trailingOnly = TRUE);
output.directory  <- command.arguments[1];
code.directory    <- command.arguments[2];

####################################################################################################
require(LearnBayes);
require(ggplot2);
require(scales);
require(coda);
#require(sn);

source(paste(code.directory, "utils-monte-carlo.R", sep = "/"));

setwd(output.directory);

### AUXILIAR FUNCTIONS #############################################################################
log.posterior.pre.density <- function(model.parameters = NULL, prior.and.data = NULL) {
        
	z0 <- prior.and.data[['hyperparameters']][['z0']];
	e  <- prior.and.data[['data']][,'e'];
	y  <- prior.and.data[['data']][,'y'];

	output.value <- NULL;
	if (is.null(dim(model.parameters))) {

		alpha <- exp(model.parameters[1]);
		mu    <- exp(model.parameters[2]);
		beta  <- alpha / mu;

		temp <- alpha * log(beta) + lgamma(alpha + y);
		temp <- temp - lgamma(alpha) - (alpha + y) * log(beta + e);
		temp <- sum(temp);

		output.value <- temp + log(alpha) - 2 * log(alpha + z0);

		} else {

		alpha <- exp(model.parameters[,1]);
		mu    <- exp(model.parameters[,2]);
		beta  <- alpha / mu;

		FUN.temp <- function(i) {
			temp <- alpha[i] * log(beta[i]) + lgamma(alpha[i] + y);
			temp <- temp - lgamma(alpha[i]) - (alpha[i] + y) * log(beta[i] + e);
			temp <- sum(temp);
			return( temp + log(alpha[i]) - 2 * log(alpha[i] + z0) );
			}
		output.value <- sapply(X = 1:nrow(model.parameters), FUN = FUN.temp);

		}

	return(output.value);

        }

####################################################################################################
str(hearttransplants);
summary(hearttransplants);
# hearttransplants;

### SECTION 7.9, p.171 #############################################################################
sample.size = 1e+5;

### generate sample with "Metropolis with Gibbs" with z0 = 0.53
prior.and.data.z0.pt53 <- list(
	hyperparameters = list(z0 = 0.53),
	data            = hearttransplants
	);

laplace.results.z0.pt53 <- laplace(
	logpost        = log.posterior.pre.density,
	mode           = c(2,-7),
	prior.and.data = prior.and.data.z0.pt53
	);
laplace.results.z0.pt53;

gibbs.results.z0.pt53 <- gibbs(
	logpost        = log.posterior.pre.density,
	start          = laplace.results.z0.pt53[['mode']],
	m              = sample.size,
	scale          = 2 * diag(laplace.results.z0.pt53[['var']]),
	prior.and.data = prior.and.data.z0.pt53
	);
str(gibbs.results.z0.pt53);
summary(gibbs.results.z0.pt53);

gibbs.sample.z0.pt53 <- as.data.frame(gibbs.results.z0.pt53[['par']]);
colnames(gibbs.sample.z0.pt53) <- c('log.alpha','log.mu');
str(gibbs.sample.z0.pt53);
summary(gibbs.sample.z0.pt53);

### generate sample with "Metropolis with Gibbs" with z0 = 5
prior.and.data.z0.5 <- list(
	hyperparameters = list(z0 = 5),
	data            = hearttransplants
	);

laplace.results.z0.5 <- laplace(
	logpost        = log.posterior.pre.density,
	mode           = c(2,-7),
	prior.and.data = prior.and.data.z0.5
	);
laplace.results.z0.5;

gibbs.results.z0.5 <- gibbs(
	logpost        = log.posterior.pre.density,
	start          = laplace.results.z0.5[['mode']],
	m              = sample.size,
	scale          = 2 * diag(laplace.results.z0.5[['var']]),
	prior.and.data = prior.and.data.z0.5
	);
str(gibbs.results.z0.5);
summary(gibbs.results.z0.5);

gibbs.sample.z0.5 <- as.data.frame(gibbs.results.z0.5[['par']]);
colnames(gibbs.sample.z0.5) <- c('log.alpha','log.mu');
str(gibbs.sample.z0.5);
summary(gibbs.sample.z0.5);

### generate Fig. 7.11, p.173
png("Fig7-11.png");
my.ggplot <- ggplot();

my.levels <- c('prior, z0=0.53','prior, z0=5','posterior, z0=0.53','posterior, z0=5');

DF.z0.pt53 <- data.frame(
	log.alpha = gibbs.sample.z0.pt53[,'log.alpha'],
	density   = factor(rep('posterior, z0=0.53',nrow(gibbs.sample.z0.pt53)),levels=my.levels)
	);
DF.z0.5 <- data.frame(
	log.alpha = gibbs.sample.z0.5[,'log.alpha'],
	density   = factor(rep('posterior, z0=5',nrow(gibbs.sample.z0.5)),levels=my.levels)
	);
DF.temp <- rbind(DF.z0.pt53,DF.z0.5);
my.ggplot <- my.ggplot + geom_density(
	data    = DF.temp,
	mapping = aes(x = log.alpha, colour = density)
	);

grid.size     <- 1e-3;
lower.bound   <- -20;
upper.bound   <- 20;
log.alphas    <- lower.bound + (upper.bound - lower.bound) * seq(0,1,grid.size);
alphas        <- exp(log.alphas);
prior.z0.pt53 <- 0.53 * alphas / (0.53 + alphas)^2;
prior.z0.5    <- 5    * alphas / (5    + alphas)^2;
prior.z0.pt53 <- prior.z0.pt53 / (grid.size * (upper.bound - lower.bound) * sum(prior.z0.pt53));
prior.z0.5    <- prior.z0.5    / (grid.size * (upper.bound - lower.bound) * sum(prior.z0.5));

DF.z0.pt53 <- data.frame(
	log.alpha = log.alphas,
	value     = prior.z0.pt53,
	density   = factor(rep('prior, z0=0.53',length(alphas)),levels=my.levels)
	);
DF.z0.5 <- data.frame(
	log.alpha = log.alphas,
	value     = prior.z0.5,
	density   = factor(rep('prior, z0=5',length(alphas)),levels=my.levels)
	);
DF.temp <- rbind(DF.z0.pt53,DF.z0.5);
my.ggplot <- my.ggplot + geom_line(
	data    = DF.temp,
	mapping = aes(x = log.alpha, y = value, colour = density)
	);

my.ggplot <- my.ggplot + xlim(-3,5);
my.ggplot;
dev.off();

####################################################################################################

q();

