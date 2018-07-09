
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

	y <- parameters[['observations']];

	log.pre.density <- NULL;
	if (is.null(dim(theta))) {

		lambda.A <- exp(theta[1]);
		lambda.B <- exp(theta[2]);
		log.pre.density <- sum(log(
			0.8 * dexp(y, 1 / lambda.A) + (1 - 0.8) * dexp(y, 1 / lambda.B)
			));

		} else {

		lambda.A <- exp(theta[,1]);
		lambda.B <- exp(theta[,2]);
		log.pre.density <- numeric(nrow(theta));
		for (i in 1:length(log.pre.density)) {
			log.pre.density[i] <- sum(log(
				0.8 * dexp(y, 1 / lambda.A[i]) + (1 - 0.8)*dexp(y, 1 / lambda.B[i])
				));
			}

		}

	return(log.pre.density);

	}

### 5.13.6(a) ######################################################################################
posterior.parameters <- list(
	observations = c(
		 9.3,  4.9,  3.5, 26.0,  0.6,  1.0,  3.5, 26.9,
		 2.6, 20.4,  1.0, 10.0,  1.7, 11.3,  7.7, 14.1,
		24.8,  3.8,  8.4,  1.1, 24.5, 90.7, 16.4, 30.7,
		 8.5,  5.9, 14.7,  0.5, 99.5, 35.2
		)
	);

grid.parameters <- list(
	xlimits            = c( 1,4),
	ylimits            = c(-2,8),
	relative.grid.size = 2 * (1e-2)
	);

theta.grid <- generate.grid(
	xlimits            = grid.parameters[['xlimits']],
	ylimits            = grid.parameters[['ylimits']],
	relative.grid.size = grid.parameters[['relative.grid.size']]
	);

DF.log.posterior.pre.density <- cbind(
	theta.grid,
	my.log.posterior.pre.density(theta = theta.grid, parameters = posterior.parameters)
	);
colnames(DF.log.posterior.pre.density) <- c('thetaA','thetaB','log.pre.density');
summary(DF.log.posterior.pre.density);

png("Fig01_posterior-contour.png");
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + stat_contour(
	data = DF.log.posterior.pre.density,
	aes(x = thetaA, y = thetaB, z = log.pre.density),
	color = "black",
	binwidth = 0.75
	);
#my.ggplot <- my.ggplot + xlim(12,19) + ylim(-4,17);
my.ggplot;
dev.off();

### 5.13.6(b) ######################################################################################
laplace.results <- laplace(
	logpost = my.log.posterior.pre.density,
	mode    = c(3,0),
	posterior.parameters
	);
laplace.results;

### 5.13.6(c) ######################################################################################
laplace.results <- laplace(
	logpost = my.log.posterior.pre.density,
	mode    = c(2,4),
	posterior.parameters
	);
laplace.results;

### 5.13.6(d) ######################################################################################
#
#  It is because there are two local maxima, and the starting point in 5.13.6(b) is close to one
#  of the local maxima, while the starting point in 5.13.6(c) is close to the other one.
#  Consequently, the function laplace(), which uses the Nelder-Mead algorithm, yields these
#  two local maxima as result, depending on the starting point it is given.
#

