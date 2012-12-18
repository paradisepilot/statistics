
command.arguments <- commandArgs(trailingOnly = TRUE);
output.directory  <- command.arguments[1];
code.directory    <- command.arguments[2];

####################################################################################################
setwd(output.directory);
library(LearnBayes);
library(ggplot2);
library(scales);

source(paste(code.directory,"utils-monte-carlo.R",sep="/"));

### AUXILIARY FUNCTIONS ############################################################################
my.log.posterior.pre.density <- function(theta = NULL, parameters = NULL) {

	x <- parameters[['observations']][,'x'];
	y <- parameters[['observations']][,'y'];

	if (is.null(dim(theta))) {
		theta <- matrix(theta, nrow = 1);
		} else {
		theta <- as.matrix(theta);
		}

	X <- rbind(rep(1,length(x)),x);
	log.pre.density <- rowSums(theta %*% (X %*% diag(y)) - exp(theta %*% X));

	return(log.pre.density);

	}

multivariate.Gaussian.pdf <- function(x = NULL, parameters = NULL) {
	output.value <- LearnBayes::dmnorm(
		x      = as.matrix(x),
		mean   = parameters[['mean']],
		varcov = parameters[['varcov']],
		log    = parameters[['log']]
		);
	return(output.value);
	}

r.multivariate.Gaussian <- function(sample.size = NULL, parameters = NULL) {
	output.value <- LearnBayes::rmt(
		n      = sample.size,
		mean   = parameters[['mean']],
		varcov = parameters[['varcov']]
		);
	return(output.value);
	}

multivariate.t.pdf <- function(x, parameters) {
        output.value <- parameters[['enveloping.constant']] * LearnBayes::dmt(
                x    = as.matrix(x),
                mean = parameters[['mean']],
                S    = parameters[['S']],
                df   = parameters[['df']],
                log  = parameters[['log']]
                );
        return(output.value);
        }

r.multivariate.t <- function(sample.size = NULL, parameters) {
        output.value <- LearnBayes::rmt(
                n    = sample.size,
                mean = parameters[['mean']],
                S    = parameters[['S']],
                df   = parameters[['df']]
                );
        return(output.value);
        }

### 5.13.4(a) ######################################################################################
#
#  See definition of my.log.posterior.pre.density().
#

### 5.13.4(b) ######################################################################################
MATRIX.observations <- as.matrix(
	data.frame(x=1:18,y=c(15,11,14,17,5,11,10,4,8,10,7,9,11,3,6,1,1,4))
	);
posterior.parameters <- list(observations = MATRIX.observations);

beta.bootstrap.sample <- generate.bootstrap.sample(
	sample.size = 1e+5,
	logf        = my.log.posterior.pre.density,
	xlimits     = c( 0,  5  ),
	ylimits     = c(-0.5,0.5),
	parameters  = posterior.parameters
	);
beta.bootstrap.sample <- as.data.frame(beta.bootstrap.sample);
colnames(beta.bootstrap.sample) <- c('beta0','beta1');
summary(beta.bootstrap.sample);

grid.parameters <- list(
	xlimits            = c( 1.5,4  ),
	ylimits            = c(-0.2,0.2),
	relative.grid.size = 1e-2
	);

beta.grid <- generate.grid(
	xlimits            = grid.parameters[['xlimits']],
	ylimits            = grid.parameters[['ylimits']],
	relative.grid.size = grid.parameters[['relative.grid.size']]
	);

DF.log.posterior.pre.density <- cbind(
	beta.grid,
	my.log.posterior.pre.density(theta = beta.grid, parameters = posterior.parameters)
	);
colnames(DF.log.posterior.pre.density) <- c('beta0','beta1','log.pre.density');
summary(DF.log.posterior.pre.density);

png("Fig01_posterior-bootstrap-sample.png");
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_point(
	data = beta.bootstrap.sample,
	aes(x = beta0, y = beta1),
	color = alpha("red",0.01)
	);
my.ggplot <- my.ggplot + stat_contour(
	data = DF.log.posterior.pre.density,
	aes(x = beta0, y = beta1, z = log.pre.density),
	color = "black"
	);
#my.ggplot <- my.ggplot + xlim(12,19) + ylim(-4,17);
my.ggplot;
dev.off();

posterior.density <- target.pdf(
	log.pre.density        = my.log.posterior.pre.density,
	theta                  = beta.grid,
	pre.density.parameters = posterior.parameters,
	grid.parameters        = grid.parameters
	);

laplace.results <- laplace(
	logpost = my.log.posterior.pre.density,
	mode    = c(2.75,-0.1),
	posterior.parameters
	);
laplace.results;

gaussian.parameters <- list(
	enveloping.constant = 1,
	mean   = laplace.results[['mode']],
	varcov = laplace.results[['var']],
	log    = FALSE
	);

gaussian.approximating.density <- multivariate.Gaussian.pdf(
	x          = beta.grid,
	parameters = gaussian.parameters
	);

t.parameters <- list(
	enveloping.constant = 1,
	mean = laplace.results[['mode']],
	S    = laplace.results[['var']],
	df   = 1,
	log  = FALSE
	);

t.proposal.density <- multivariate.t.pdf(
	x          = beta.grid,
	parameters = t.parameters
	);

DF.temp <- as.data.frame(cbind(
	beta.grid,
	posterior.density,
	gaussian.approximating.density,
	t.proposal.density,
	posterior.density / gaussian.approximating.density,
	posterior.density / t.proposal.density
	));
colnames(DF.temp) <- c('beta0','beta1','posterior','gaussian','t','posterior.to.gaussian','posterior.to.t');
DF.temp[,'log.posterior'] <- log(DF.temp[,'posterior']);
DF.temp[,'log.gaussian']  <- log(DF.temp[,'gaussian']);
DF.temp[,'log.t']         <- log(DF.temp[,'t']);
summary(DF.temp);

png("Fig02_posterior-gaussian.png");
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_point(
	data = beta.bootstrap.sample,
	aes(x = beta0, y = beta1),
	color = alpha("red",0.01)
	);
my.ggplot <- my.ggplot + stat_contour(
	data = DF.temp,
	aes(x = beta0, y = beta1, z = log.posterior),
	color = alpha("black",0.5),
	binwidth = 5
	);
my.ggplot <- my.ggplot + stat_contour(
	data = DF.temp,
	aes(x = beta0, y = beta1, z = log.gaussian),
	color = "cyan",
	binwidth = 5
	);
#my.ggplot <- my.ggplot + xlim(12,19) + ylim(-4,17);
my.ggplot;
dev.off();

png("Fig03_posterior-t.png");
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_point(
	data = beta.bootstrap.sample,
	aes(x = beta0, y = beta1),
	color = alpha("red",0.01)
	);
my.ggplot <- my.ggplot + stat_contour(
	data = DF.temp,
	aes(x = beta0, y = beta1, z = log.posterior),
	color = alpha("black",0.5),
	binwidth = 5
	);
my.ggplot <- my.ggplot + stat_contour(
	data = DF.temp,
	aes(x = beta0, y = beta1, z = log.t),
	color = "cyan",
	binwidth = 5
	);
#my.ggplot <- my.ggplot + xlim(12,19) + ylim(-4,17);
my.ggplot;
dev.off();

png("Fig04_posterior-gaussian-ratio-histogram.png");
qplot(x = DF.temp[,'posterior.to.gaussian'], geom = "histogram");
dev.off();

png("Fig05_posterior-t-ratio-histogram.png");
qplot(x = DF.temp[,'posterior.to.t'], geom = "histogram", binwidth = 0.01);
dev.off();

write.table(
	x = DF.temp[order(DF.temp[,'posterior.to.gaussian'], decreasing = TRUE),],
	file = 'beta-posterior-gaussian-t.csv',
	row.names = FALSE,
	sep = '\t'
	);

### 5.13.4(c) ######################################################################################
beta.SIR.sample <- perform.SIR(
	log.pre.density        = my.log.posterior.pre.density,
	target.pdf             = target.pdf,
	pre.density.parameters = posterior.parameters,
	grid.parameters        = grid.parameters,
	proposal.pdf           = multivariate.t.pdf,
	rproposal              = r.multivariate.t,
	proposal.parameters    = t.parameters,
	proposal.sample.size   = 1e+6,
	SIR.sample.size        = 1e+5
	);
beta.SIR.sample <- as.data.frame(beta.SIR.sample);
colnames(beta.SIR.sample) <- c('beta0','beta1');
summary(beta.SIR.sample);

png("Fig06_SIR-sample.png");
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_point(
	data = beta.SIR.sample,
	aes(x = beta0, y = beta1),
	color = alpha("orange",0.05)
	);
my.ggplot <- my.ggplot + stat_contour(
	data = DF.temp,
	aes(x = beta0, y = beta1, z = log.posterior),
	color = alpha("black",0.5),
	binwidth = 5
	);
#my.ggplot <- my.ggplot + xlim(12,19) + ylim(-4,17);
my.ggplot;
dev.off();

### posterior estimate for beta1 based on SIR:
beta1.SIR.sample <- beta.SIR.sample[,'beta1'] 
beta1.SIR.mean   <- mean(beta1.SIR.sample);
beta1.SIR.sd     <- sd(beta1.SIR.sample);
beta1.SIR.mean;
beta1.SIR.sd;

### estimate for beta1 based on Gaussian approximation:
laplace.results[['mode']];
laplace.results[['var']];
diag(laplace.results[['var']]);
sqrt(diag(laplace.results[['var']]));

