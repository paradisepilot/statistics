
command.arguments <- commandArgs(trailingOnly = TRUE);
output.directory  <- command.arguments[1];
code.directory    <- command.arguments[2];

####################################################################################################
setwd(output.directory);
library(LearnBayes);
library(ggplot2);
library(scales);

### AUXILIARY FUNCTIONS ############################################################################
log.posterior.pre.density <- function(theta = NULL, parameters = NULL) {

	t  <- parameters[['total.time']];
	t1 <- parameters[['smallest.failure.time']];
	s  <- parameters[['n.failures.observed']];
	n  <- parameters[['sample.size']];

	log.pre.density <- NULL;
	if (is.null(dim(theta))) {

		beta            <- exp(theta[1]);
		mu              <- t1 - exp(theta[2]);
		log.pre.density <- (1 - s) * theta[1] + theta[2] - (t - n * mu) / beta;
		###  See solution to Exercise 5.13.2(a) for justification of the above formula

		} else {

		beta            <- exp(theta[,1]);
		mu              <- t1 - exp(theta[,2]);
		log.pre.density <- (1 - s) * theta[,1] + theta[,2] - (t - n * mu) / beta;
		###  See solution to Exercise 5.13.2(a) for justification of the above formula

		}

	return(log.pre.density);

	}

target.pdf <- function(theta = NULL, parameters = NULL) {

	t  <- parameters[['total.time']];
	t1 <- parameters[['smallest.failure.time']];
	s  <- parameters[['n.failures.observed']];
	n  <- parameters[['sample.size']];

	###  set up grid used to compute normalizing constant (i.e. integral) for pre-density
	theta1.min         <-  12;
	theta1.max         <-  19;
	theta2.min         <- - 4;
	theta2.max         <-  17;
	relative.grid.size <- 1e-3;
	theta1             <- theta1.min + (theta1.max - theta1.min) * seq(0,1,relative.grid.size);
	theta2             <- theta2.min + (theta2.max - theta2.min) * seq(0,1,relative.grid.size);
	theta.grid         <- expand.grid(x = theta1, y = theta2);

	###  compute normalizing constant (i.e.) for pre-density
	theta.pre.density <- exp(log.posterior.pre.density(
		theta = theta.grid, parameters = parameters
		));
	area.element      <- (theta1.max-theta1.min)*(theta2.max-theta2.min)*relative.grid.size^2;
	normalizing.constant <- area.element * sum(theta.pre.density);

	###  compute output value (i.e. posterior density)
	log.posterior.density <- log.posterior.pre.density(theta = theta, parameters = parameters);
	posterior.density     <- exp(log.posterior.density) / normalizing.constant;

	return(posterior.density);

	}

proposal.pdf <- function(x, parameters) {
	output.value <- parameters[['enveloping.constant']] * LearnBayes::dmt(
		x    = as.matrix(x),
		mean = parameters[['mean']],
		S    = parameters[['S']],
		df   = parameters[['df']],
		log  = parameters[['log']]
		);
	return(output.value);
	}

rproposal <- function(sample.size = NULL, parameters) {
	output.value <- LearnBayes::rmt(
		n        = sample.size,
		mean = parameters[['mean']],
		S    = parameters[['S']],
		df   = parameters[['df']]
		);
	return(output.value);
	}

generate.bootstrap.sample <- function(sample.size = NULL, logf = NULL, xlimits = NULL, ylimits = NULL, parameters = NULL) {

	grid.points <- data.frame(
		x = runif(n = sample.size, min = xlimits[1], max = xlimits[2]),
		y = runif(n = sample.size, min = ylimits[1], max = ylimits[2])
		); 

	log.posterior <- logf(theta = grid.points, parameters = parameters);

	row.sample <- sample(
		size    = sample.size,
		x       = 1:nrow(grid.points),
		prob    = exp(log.posterior),
		replace = TRUE
		);

	DF.temp <- grid.points[row.sample,];
	LIST.output <- list(x = DF.temp[,1], y = DF.temp[,2]);

	return(LIST.output);

	}

generate.grid <- function(xlimits = NULL, ylimits = NULL, relative.grid.size = NULL) {
	x.min   <-  xlimits[1];
	x.max   <-  xlimits[2];
	y.min   <-  ylimits[1];
	y.max   <-  ylimits[2];
	x.grid  <- x.min + (x.max - x.min) * seq(0,1,relative.grid.size);
	y.grid  <- y.min + (y.max - y.min) * seq(0,1,relative.grid.size);
	xy.grid <- expand.grid(x = x.grid, y = y.grid);
	return(xy.grid);
	}

### function to perform rejection SIR (sample importance resampling)
perform.SIR <- function(target.pdf = NULL, target.parameters = NULL, proposal.pdf = NULL, rproposal = NULL, proposal.parameters = NULL, proposal.sample.size = NULL, SIR.sample.size = NULL) {

        proposal.sample <- rproposal(
		sample.size = proposal.sample.size,
		parameters  = proposal.parameters
		);

        target.density   <- target.pdf(
		theta      = proposal.sample,
		parameters = target.parameters
		);

        proposal.density <- proposal.pdf(
		x          = proposal.sample,
		parameters = proposal.parameters
		);

        SIR.density <- target.density / proposal.density;
        SIR.density <- SIR.density / sum(SIR.density);

        row.index.sample <- sample(
                size    = SIR.sample.size,
                x       = 1:nrow(proposal.sample),
                prob    = SIR.density,
                replace = TRUE
                );

        SIR.sample <- proposal.sample[row.index.sample,];

        return(SIR.sample);

        }

### 5.13.2(a) ######################################################################################
#
#  Let f(theta1,theta2|data) be posterior density expressed in terms of (theta1,theta2),
#  whether (beta,mu) = F(theta1,theta2) := (exp(theta1), t1 - exp(theta2)).
#
#  Note that:
#
#                  | dF1/dtheta1 dF1/dtheta2 |   | exp(theta1)   0           |
#  |Jacobian(F)| = |                         | = |                           | = exp(theta1+theta2)
#                  | dF2/dtheta1 dF2/dtheta2 |   | 0            -exp(theta2) |
#
#  Next, recall that:
#
#        \int f(\theta_{1},\theta_{2}|data) d\theta_{1} d\theta_{2}
#      = \int g(\beta,\mu|data) d\beta d\mu
#      = \int g(F(\theta_{1},\theta_{2})|data) |Jacobian(F)| d\theta_{1} d\theta_{2}
#
#  We thus see that:
#
#         f(\theta_{1},\theta_{2}|data)
#       = g(F(\theta_{1},\theta_{2})|data) |Jacobian(F)|
#       = g(\exp(\theta_{1}), t1 - \exp(\theta_{2})|data) |Jacobian(F)|
#       = g(\exp(\theta_{1}), t1 - \exp(\theta_{2})|data) \exp(\theta_{1} + \theta_{2})
#       = \dfrac{1}{\beta^{s}} \exp(-(t-n\mu)/\beta) \exp(\theta_{1} + \theta_{2})
#
#  Thus,
#
#         log f(\theta_{1},\theta_{2}|data)
#       = -s\log(\beta) - \dfrac{t-n\mu}{\beta} + \theta_{1} + \theta_{2}
#       = -s\log(\exp(\theta_{1})) - \dfrac{t-n\mu}{\beta} + \theta_{1} + \theta_{2}
#       = (1-s)\theta_{1} + \theta_{2} - \dfrac{t - n(t_{1}-\exp\theta_{2})}{\exp\theta_{1}}
#
#  The above formula justifies the definition of the funtion log.posterior.pre.density().
#

### 5.13.2(b) ######################################################################################
###  Answer to 5.13.2(b): See the definition of log.posterior.pre.density() above.

###  The following scatter plot shows the "effective"
###  support of the posterior distribution
posterior.parameters <- list(
	total.time            = 15962989,
	smallest.failure.time = 237217,
	n.failures.observed   = 8,
	sample.size           = 15
	);

my.posterior.sample <- generate.bootstrap.sample(
	sample.size = 1e+5,
	logf        = log.posterior.pre.density,
	xlimits     = c( 10,20),
	ylimits     = c(-15,20),
	parameters  = posterior.parameters
	);
my.posterior.sample <- as.data.frame(my.posterior.sample);
colnames(my.posterior.sample) <- c('theta1','theta2');
summary(my.posterior.sample);

theta.grid <- generate.grid(
	xlimits            = c(12,19),
	ylimits            = c(-4,17),
	relative.grid.size = 1e-2
	);

DF.temp <- cbind(
	theta.grid,
	log.posterior.pre.density(theta = theta.grid, parameters = posterior.parameters)
	);
colnames(DF.temp) <- c('theta1','theta2','log.density');
summary(DF.temp);

png("Fig01_posterior-sample-scatter-plot.png");
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_point(
	data = my.posterior.sample,
	aes(x = theta1, y = theta2),
	color = alpha("red",0.005)
	);
my.ggplot <- my.ggplot + stat_contour(
	data = DF.temp,
	aes(x = theta1, y = theta2, z = log.density),
	color = "black",
	binwidth = 5
	);
#my.ggplot <- my.ggplot + xlim(12,19) + ylim(-4,17);
my.ggplot;
dev.off();

### 5.13.2(c) ######################################################################################
theta.grid <- generate.grid(
	xlimits            = c(12,19),
	ylimits            = c(-4,17),
	relative.grid.size = 1e-2
	);
str(theta.grid);
summary(theta.grid);

posterior.density <- target.pdf(theta = theta.grid, parameters = posterior.parameters);

laplace.results <- laplace(
	logpost = log.posterior.pre.density,
	mode    = c(14.5,11.25),
	posterior.parameters
	);
laplace.results;

proposal.parameters <- list(
	enveloping.constant = 1,
	mean = laplace.results[['mode']],
	S    = laplace.results[['var']],
	df   = 5,
	log  = FALSE
	);

proposal.density <- proposal.pdf(x = theta.grid, parameters = proposal.parameters);

DF.temp <- cbind(
	theta.grid,
	posterior.density,
	proposal.density,
	posterior.density / proposal.density
	);
colnames(DF.temp) <- c('theta1','theta2','posterior','proposal','posterior.over.proposal');
summary(DF.temp);

png("Fig02_posterior-proposal.png");
DF.temp[,'posterior'] <- log(DF.temp[,'posterior']);
DF.temp[,'proposal']  <- log(DF.temp[,'proposal']);
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_point(
	data = my.posterior.sample,
	aes(x = theta1, y = theta2),
	color = alpha("red",0.005)
	);
my.ggplot <- my.ggplot + stat_contour(
	data = DF.temp,
	aes(x = theta1, y = theta2, z = posterior),
	color = alpha("black",0.5),
	binwidth = 5
	);
my.ggplot <- my.ggplot + stat_contour(
	data = DF.temp,
	aes(x = theta1, y = theta2, z = proposal),
	color = "blue",
	binwidth = 2.5
	);
#my.ggplot <- my.ggplot + xlim(12,19) + ylim(-4,17);
my.ggplot;
dev.off();

png("Fig03_posterior-proposal-ratio-histogram.png");
qplot(x = DF.temp[,'posterior.over.proposal'], geom = "histogram");
dev.off();

### 5.13.2(d) ######################################################################################
theta.SIR.sample <- perform.SIR(
	target.pdf           = target.pdf,
	target.parameters    = posterior.parameters,
	proposal.pdf         = proposal.pdf,
	rproposal            = rproposal,
	proposal.parameters  = proposal.parameters,
	proposal.sample.size = 1e+6,
	SIR.sample.size      = 1e+5
	);
theta.SIR.sample <- as.data.frame(theta.SIR.sample);
colnames(theta.SIR.sample) <- c('theta1','theta2');
summary(theta.SIR.sample);

png("Fig04_SIR-sample.png");
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_point(
	data = theta.SIR.sample,
	aes(x = theta1, y = theta2),
	color = alpha("orange",0.05)
	);
my.ggplot <- my.ggplot + stat_contour(
	data = DF.temp,
	aes(x = theta1, y = theta2, z = posterior),
	color = alpha("black",0.5),
	binwidth = 5
	);
#my.ggplot <- my.ggplot + xlim(12,19) + ylim(-4,17);
my.ggplot;
dev.off();

### 5.13.2(e) ######################################################################################
t0 <- 1e+6;

theta1 <- theta.SIR.sample[,1];
theta2 <- theta.SIR.sample[,2];

beta.sample <- exp(theta1);
mu.sample   <- posterior.parameters[['smallest.failure.time']] - exp(theta2);

R.t0.sample <- exp(-(t0 - mu.sample)/beta.sample);
summary(R.t0.sample);

png("Fig05_R-t0-histogram.png");
qplot(x = R.t0.sample, geom = "histogram", binwidth = 0.01);
dev.off();

R.t0.mean <- mean(R.t0.sample);
R.t0.sd   <- sd(R.t0.sample);
R.t0.mean;
R.t0.sd;

### repeat using the bootstrap posterior sample directly:
theta1 <- my.posterior.sample[,1];
theta2 <- my.posterior.sample[,2];

beta.sample <- exp(theta1);
mu.sample   <- posterior.parameters[['smallest.failure.time']] - exp(theta2);

R.t0.sample <- exp(-(t0 - mu.sample)/beta.sample);
summary(R.t0.sample);

R.t0.mean <- mean(R.t0.sample);
R.t0.sd   <- sd(R.t0.sample);
R.t0.mean;
R.t0.sd;

