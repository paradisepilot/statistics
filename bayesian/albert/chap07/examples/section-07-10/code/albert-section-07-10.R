
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

### SECTION 7.10, p.173 ############################################################################
sample.size = 1e+5;

### generate (log.alpha, log.mu) posterior sample with "Metropolis with Gibbs" with z0 = 0.53
prior.and.data <- list(
	hyperparameters = list(z0 = 0.53),
	data            = hearttransplants
	);

laplace.results <- laplace(
	logpost        = log.posterior.pre.density,
	mode           = c(2,-7),
	prior.and.data = prior.and.data
	);
laplace.results;

gibbs.results <- gibbs(
	logpost        = log.posterior.pre.density,
	start          = laplace.results[['mode']],
	m              = sample.size,
	scale          = 2 * diag(laplace.results[['var']]),
	prior.and.data = prior.and.data
	);
str(gibbs.results);
summary(gibbs.results);

gibbs.sample <- as.data.frame(gibbs.results[['par']]);
colnames(gibbs.sample) <- c('log.alpha','log.mu');
str(gibbs.sample);
summary(gibbs.sample);

### generate Fig. 7.12, p.174
j0 <- 94;
alphas  <- exp(gibbs.sample[,'log.alpha']);
betas   <- exp(gibbs.sample[,'log.alpha'] - gibbs.sample[,'log.mu']);
lambdas <- rgamma(
	n     = length(alphas),
	shape = hearttransplants[j0,'y'] + alphas,
	rate  = hearttransplants[j0,'e'] + betas
	);
y.predicted <- rpois(n = length(lambdas), lambda = hearttransplants[j0,'e'] * lambdas);
png("Fig7-12.png");
my.ggplot <- ggplot();
my.ggplot <- my.ggplot + geom_histogram(
	data     = data.frame(y94.predicted = y.predicted),
	mapping  = aes(x = y94.predicted),
	colour   = alpha("black",0.5),
	fill     = alpha("#CC5500",0.5),
	binwidth = 1
	);
my.ggplot <- my.ggplot + geom_vline(xintercept = hearttransplants[j0,'y'], lwd = 1.2);
my.ggplot <- my.ggplot + xlim(0,40);
my.ggplot;
dev.off();

temp1 <- mean(y.predicted >= hearttransplants[j0,'y']);
temp2 <- mean(y.predicted <= hearttransplants[j0,'y']);
min(temp1,temp2);

### generate Fig. 7.13, p.176
FUN.pvalue.exchangeable <- function(i) {
	lambdas <- rgamma(
		n     = length(alphas),
		shape = hearttransplants[i,'y'] + alphas,
		rate  = hearttransplants[i,'e'] + betas
		);
	y.predicted <- rpois(n = length(lambdas), lambda = hearttransplants[i,'e'] * lambdas);
	temp1 <- mean(y.predicted >= hearttransplants[i,'y']);
	temp2 <- mean(y.predicted <= hearttransplants[i,'y']);
	return(min(temp1,temp2));
	}
pvalues.exchangeable <- sapply(X = 1:nrow(hearttransplants), FUN = FUN.pvalue.exchangeable);

DF.temp <- data.frame(
        e      = hearttransplants[,'e'],
        y      = hearttransplants[,'y'],
        log.e  = log(hearttransplants[,'e']),
        pvalue = numeric(length=nrow(hearttransplants))
        );

temp.sample.size <- 1e+5;
temp.alpha <- sum(hearttransplants[,'y']);
temp.beta  <- sum(hearttransplants[,'e']);
FUN.pvalue.equal.means <- function(i) {
	lambdas <- rgamma(
		n     = temp.sample.size,
		shape = temp.alpha,
		rate  = temp.beta
		);
	y.predicted <- rpois(
		n      = length(lambdas),
		lambda = hearttransplants[i,'e'] * lambdas
		);
	temp1 <- mean(y.predicted >= hearttransplants[i,'y']);
	temp2 <- mean(y.predicted <= hearttransplants[i,'y']);
	return(min(temp1,temp2));
	}
pvalues.equal.means <- sapply(X = 1:nrow(hearttransplants), FUN = FUN.pvalue.equal.means);

png("Fig7-13.png");
my.ggplot <- ggplot();
my.ggplot <- my.ggplot + geom_point(
	data = data.frame(
		pvalue.exchangeable = pvalues.exchangeable,
		pvalue.equal.means  = pvalues.equal.means
		),
	mapping = aes(x = pvalue.equal.means, y = pvalue.exchangeable)
	);
my.ggplot <- my.ggplot + geom_abline(slope = 1, intercept = 0, colour = "red");
my.ggplot <- my.ggplot + xlim(0,1) + ylim(0,1);
my.ggplot;
dev.off();

####################################################################################################

q();

