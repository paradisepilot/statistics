
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

### Fig. 7.10, p.170 ###############################################################################
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

sample.size = 1e+5;
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

### generate Fig. 7.10, p.170
DF.temp <- as.data.frame(matrix(nrow = nrow(hearttransplants), ncol = 2 + ncol(hearttransplants)));
DF.temp[,1:ncol(hearttransplants)] <- hearttransplants;
colnames(DF.temp)    <- c(colnames(hearttransplants),'log.e','shrinkage.fraction');
DF.temp[,'log.e']    <- log(DF.temp[,'e']);

alphas <- exp(gibbs.sample[,'log.alpha']);
mus    <- exp(gibbs.sample[,'log.mu']);
FUN.shrinkage <- function(i) { return(mean(alphas / (alphas + DF.temp[i,'e'] * mus))); }
DF.temp[,'shrinkage.fraction'] <- sapply(X = 1:nrow(DF.temp),FUN = FUN.shrinkage);
str(DF.temp);
summary(DF.temp);

png("Fig7-10.png");
my.ggplot <- ggplot();
my.ggplot <- my.ggplot + geom_point(
	data    = DF.temp,
	mapping = aes(x = log.e, y = shrinkage.fraction)
	);
my.ggplot <- my.ggplot + xlim(6,9.5) + ylim(0,1);
my.ggplot <- my.ggplot + xlab("log(e)") + ylab("shrinkage fraction");
my.ggplot;
dev.off();

### FINDING THE HOSPITAL WITH SMALLEST POSTERIOR ESTIMATE OF MORTALITY RATE ########################
alphas <- exp(gibbs.sample[,'log.alpha']);
betas  <- exp(gibbs.sample[,'log.alpha'] - gibbs.sample[,'log.mu']);
FUN.mortality.rate <- function(i) {
	output.value <- mean(rgamma(
		n = length(alphas),
		shape = DF.temp[i,'y'] + alphas,
		rate  = DF.temp[i,'e'] + betas
		));
	return(output.value);
	}
lambdas <- sapply(X = 1:nrow(DF.temp), FUN = FUN.mortality.rate);
summary(lambdas);

which(lambdas==min(lambdas));

### COMPARISON WITH HOSPITAL 85 ####################################################################
alphas <- exp(gibbs.sample[,'log.alpha']);
betas  <- exp(gibbs.sample[,'log.alpha'] - gibbs.sample[,'log.mu']);
FUN.simulate.lambdas <- function(i) {
	output <- rgamma(
		n     = length(alphas),
		shape = DF.temp[i,'y'] + alphas,
		rate  = DF.temp[i,'e'] + betas 
		);
	return(output);
	}
DF.lambdas <- as.data.frame(sapply(X = 1:nrow(DF.temp), FUN = FUN.simulate.lambdas));
str(DF.lambdas);
#summary(DF.lambdas);

j0 <- 85;
FUN.compare.with.H85 <- function(j) {
	return( mean(DF.lambdas[,j] > DF.lambdas[,j0]) );
	}
prob.lambda85.is.smaller <- sapply(X = 1:ncol(DF.lambdas), FUN = FUN.compare.with.H85);
cbind(
	1:length(prob.lambda85.is.smaller),
	prob.lambda85.is.smaller,
	1 - prob.lambda85.is.smaller
	);

####################################################################################################

q();

