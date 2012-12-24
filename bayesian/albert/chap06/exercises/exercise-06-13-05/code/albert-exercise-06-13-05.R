
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

### AUXILIARY FUNCTIONS ############################################################################
log.posterior.pre.density <- function(model.parameters = NULL, prior.and.data = NULL) {

	theta <- model.parameters;

	t  <- prior.and.data[['total.time']];
	t1 <- prior.and.data[['smallest.failure.time']];
	s  <- prior.and.data[['n.failures.observed']];
	n  <- prior.and.data[['sample.size']];

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

### Exercise 6.13.5(a) #############################################################################
prior.and.data <- list(
        total.time            = 15962989,
        smallest.failure.time = 237217,
        n.failures.observed   = 8,
        sample.size           = 15
        );

bootstrap.sample <- generate.bootstrap.sample(
        sample.size    = 1e+6,
        logf           = log.posterior.pre.density,
        xlimits        = c( 10,21),
        ylimits        = c(- 6,20),
        prior.and.data = prior.and.data
        );
bootstrap.sample <- as.data.frame(bootstrap.sample);
colnames(bootstrap.sample) <- c('theta1','theta2');
summary(bootstrap.sample);

theta.grid <- generate.grid(
        xlimits            = c(12,19),
        ylimits            = c(-4,17),
        relative.grid.size = 2^(-7)
        );

DF.log.posterior.contour <- cbind(
        theta.grid,
        log.posterior.pre.density(
		model.parameters = theta.grid,
		prior.and.data   = prior.and.data
		)
        );
colnames(DF.log.posterior.contour) <- c('theta1','theta2','log.pre.density');
summary(DF.log.posterior.contour);

png("Fig01_bootstrap-sample-scatter-plot.png");
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_point(
        data = bootstrap.sample,
        aes(x = theta1, y = theta2),
        color = alpha("#CC5500",0.005)
        );
my.ggplot <- my.ggplot + stat_contour(
        data = DF.log.posterior.contour,
        aes(x = theta1, y = theta2, z = log.pre.density),
        color = "black",
        binwidth = 2.5
        );
#my.ggplot <- my.ggplot + xlim(12,19) + ylim(-4,17);
my.ggplot;
dev.off();

### find posterior mode using laplace
laplace.results <- laplace(
	logpost = log.posterior.pre.density,
	mode = c(14.5,11.25),
	prior.and.data
	);
laplace.results;

sample.size <- 1e+6;
rwmetrop.results <- rwmetrop(
	logpost  = log.posterior.pre.density,
	proposal = list(
		var   = 2 * laplace.results[['var']],
		scale = 2
		),
	start    = laplace.results[['mode']],
	m        = sample.size,
	prior.and.data
	);
str(rwmetrop.results);

rwmetrop.sample <- as.data.frame(rwmetrop.results[['par']]);
colnames(rwmetrop.sample) <- c('theta1','theta2');
rwmetrop.sample <- rwmetrop.sample[-c(1:5000),];
str(rwmetrop.sample);
summary(rwmetrop.sample);

png("Fig02_rwmetrop-sample-scatter-plot.png");
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_point(
        data = rwmetrop.sample,
        aes(x = theta1, y = theta2),
        color = alpha("cyan3",0.005)
        );
my.ggplot <- my.ggplot + stat_contour(
        data = DF.log.posterior.contour,
        aes(x = theta1, y = theta2, z = log.pre.density),
        color = "black",
        binwidth = 2.5
        );
#my.ggplot <- my.ggplot + xlim(12,19) + ylim(-4,17);
my.ggplot;
dev.off();

png("Fig03_theta1-posterior-densities.png");
my.levels <- c('bootstrap','rwmetrop');
DF.bootstrap <- data.frame(
	theta1 = bootstrap.sample[,'theta1'],
	sample = factor(rep('bootstrap',nrow(bootstrap.sample)),levels=my.levels)
	);
DF.rwmetrop <- data.frame(
	theta1 = rwmetrop.sample[,'theta1'],
	sample = factor(rep('rwmetrop',nrow(rwmetrop.sample)),levels=my.levels)
	);
DF.temp <- rbind(DF.bootstrap,DF.rwmetrop);
qplot(data = DF.temp, x = theta1, color = sample, geom = "density");
dev.off();

png("Fig04_theta2-posterior-densities.png");
my.levels <- c('bootstrap','rwmetrop');
DF.bootstrap <- data.frame(
	theta2 = bootstrap.sample[,'theta2'],
	sample = factor(rep('bootstrap',nrow(bootstrap.sample)),levels=my.levels)
	);
DF.rwmetrop <- data.frame(
	theta2 = rwmetrop.sample[,'theta2'],
	sample = factor(rep('rwmetrop',nrow(rwmetrop.sample)),levels=my.levels)
	);
DF.temp <- rbind(DF.bootstrap,DF.rwmetrop);
qplot(data = DF.temp, x = theta2, color = sample, geom = "density");
dev.off();

### Exercise 6.13.5(b) #############################################################################
t0 <- 1e+6;
t1 <- prior.and.data[['smallest.failure.time']];

beta.bootstrap.sample <- exp(bootstrap.sample[,'theta1']);
  mu.bootstrap.sample <- t1 - exp(bootstrap.sample[,'theta2']);
 Rt0.bootstrap.sample <- exp(-(t0 - mu.bootstrap.sample)/beta.bootstrap.sample);

beta.rwmetrop.sample <- exp(rwmetrop.sample[,'theta1']);
  mu.rwmetrop.sample <- t1 - exp(rwmetrop.sample[,'theta2']);
 Rt0.rwmetrop.sample <- exp(-(t0 - mu.rwmetrop.sample)/beta.rwmetrop.sample);

data.frame(
	bootstrap = c(mean(Rt0.bootstrap.sample),sd(Rt0.bootstrap.sample)),
	rwmetrop  = c(mean(Rt0.rwmetrop.sample), sd(Rt0.rwmetrop.sample)),
	row.names = c('mean','sd')
	);

png("Fig05_Rt0-posterior-densities.png");
my.levels <- c('bootstrap','rwmetrop');
DF.bootstrap <- data.frame(
	Rt0    = Rt0.bootstrap.sample,
	sample = factor(rep('bootstrap',nrow(bootstrap.sample)),levels=my.levels)
	);
DF.rwmetrop <- data.frame(
	Rt0    = Rt0.rwmetrop.sample,
	sample = factor(rep('rwmetrop',nrow(rwmetrop.sample)),levels=my.levels)
	);
DF.temp <- rbind(DF.bootstrap,DF.rwmetrop);
qplot(data = DF.temp, x = Rt0, color = sample, geom = "density", xlim = c(0,1));
dev.off();

####################################################################################################

q();

