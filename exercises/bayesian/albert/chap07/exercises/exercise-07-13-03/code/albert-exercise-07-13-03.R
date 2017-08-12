
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
        
	y     <- prior.and.data[['data']][,'y'];
	sigma <- prior.and.data[['data']][,'sigma'];

	output.value <- NULL;
	if (is.null(dim(model.parameters))) {

		theta1 <- model.parameters[1];
		theta2 <- model.parameters[2];

		mu     <- theta1;
		tau    <- exp(theta2);

		temp <- dnorm(
			x    = y,
			mean = mu,
			sd   = sqrt(sigma^2 + tau^2),
			log  = TRUE
			);
		temp <- sum(temp) + theta2;

		output.value <- temp;

		} else {

		theta1 <- model.parameters[,1];
		theta2 <- model.parameters[,2];

		mu     <- theta1;
		tau    <- exp(theta2);

		FUN.temp <- function(i) {
			temp <- dnorm(
				x    = y,
				mean = mu[i],
				sd   = sqrt(sigma^2 + tau[i]^2),
				log  = TRUE
				);
			temp <- sum(temp) + theta2[i];
			return(temp);
			}
		output.value <- sapply(X = 1:nrow(model.parameters), FUN = FUN.temp);

		}

	return(output.value);

        }

### Exercise 7.13.2(a) #############################################################################
prior.and.data <- list(
	data = data.frame(
		y     = c( 28,  8, -3,  7, -1,  1, 18, 12),
		sigma = c( 15, 10, 16, 11,  9, 11, 10, 18)
		)
	);

mu.0      <- 8;
log.tau.0 <- 2;

laplace.results <- laplace(
	logpost        = log.posterior.pre.density,
	mode           = c(mu.0,log.tau.0),
	prior.and.data = prior.and.data
	);
laplace.results;

grid.xlimits <- 40 * c(-1,1);
grid.ylimits <- 10 * c(-1,1);

grid.parameters <- list(
	xlimits            = grid.xlimits,
	ylimits            = grid.ylimits,
	relative.grid.size = 2^(-8)
        );
grid.parameters;

model.parameters.grid <- generate.grid(
	xlimits            = grid.parameters[['xlimits']],
	ylimits            = grid.parameters[['ylimits']],
	relative.grid.size = grid.parameters[['relative.grid.size']]
	);
str(model.parameters.grid);
summary(model.parameters.grid);

DF.contour <- as.data.frame(cbind(
	model.parameters.grid,
	log.pre.density = log.posterior.pre.density(
		model.parameters = model.parameters.grid,
		prior.and.data   = prior.and.data
		)
	));
colnames(DF.contour) <- c('mu','log.tau','log.pre.density');
str(DF.contour);
summary(DF.contour);

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
colnames(gibbs.sample) <- c('mu','log.tau');
str(gibbs.sample);
summary(cbind(gibbs.sample,exp(gibbs.sample[,'log.tau'])));

png("Fig1_posterior-contour.png");
my.ggplot <- ggplot();
my.ggplot <- my.ggplot + geom_point(
	data    = gibbs.sample,
	mapping = aes(x = mu, y = log.tau),
	colour  = alpha("#CC5500",0.01)
	);
my.ggplot <- my.ggplot + stat_contour(
	data     = DF.contour,
	mapping  = aes(x = mu, y = log.tau, z = log.pre.density),
	binwidth = 5
	);
my.ggplot <- my.ggplot + xlim(grid.xlimits) + ylim(grid.ylimits);
my.ggplot;
dev.off();

### Exercise 7.13.2(b) #############################################################################
y     <- prior.and.data[['data']][,'y'];
sigma <- prior.and.data[['data']][,'sigma'];

mu.sample  <- gibbs.sample[,'mu'];
tau.sample <- exp(gibbs.sample[,'log.tau']);
FUN.temp <- function(i) {
	temp.var  <- sigma[i]^2 * tau.sample^2 / (sigma[i]^2 + tau.sample^2);
	temp.mean <- (tau.sample^2 * y[i] + sigma[i]^2 * mu.sample) / (tau.sample^2 + sigma[i]^2);
	p.i <- rnorm(
		n    = nrow(gibbs.sample),
		mean = temp.mean,
		sd   = sqrt(temp.var)
		);
	output.value <- c(mean(p.i),sd(p.i),quantile(x = p.i, probs = c(0.05,0.5,0.95)));
	return( output.value );
	}
posterior.estimates <- matrix(nrow = nrow(prior.and.data[['data']]), ncol = 5);
for (i in 1:nrow(posterior.estimates)) { posterior.estimates[i,] <- FUN.temp(i); }
posterior.estimates <- cbind(prior.and.data[['data']],posterior.estimates);
colnames(posterior.estimates) <- c('y','sigma','post.mean','post.sd','5%','50%','95%');
str(posterior.estimates);
summary(posterior.estimates);
posterior.estimates;

### Exercise 7.13.3(a) #############################################################################
y     <- prior.and.data[['data']][,'y'];
sigma <- prior.and.data[['data']][,'sigma'];

mu.sample  <- gibbs.sample[,'mu'];
tau.sample <- exp(gibbs.sample[,'log.tau']);
FUN.temp <- function(i) {
	temp.var  <- sigma[i]^2 * tau.sample^2 / (sigma[i]^2 + tau.sample^2);
	temp.mean <- (tau.sample^2 * y[i] + sigma[i]^2 * mu.sample) / (tau.sample^2 + sigma[i]^2);
	p.i <- rnorm(
		n    = nrow(gibbs.sample),
		mean = temp.mean,
		sd   = sqrt(temp.var)
		);
	shrinkage.fraction <- 1 / (1 + tau.sample^2/sigma[i]^2);
	output.value <- c(
		mean(p.i),
		sd(p.i),
		mean(shrinkage.fraction),
		quantile(x = p.i, probs = c(0.05,0.5,0.95))
		);
	return( output.value );
	}
posterior.estimates <- matrix(nrow = nrow(prior.and.data[['data']]), ncol = 6);
for (i in 1:nrow(posterior.estimates)) { posterior.estimates[i,] <- FUN.temp(i); }
posterior.estimates <- cbind(prior.and.data[['data']],posterior.estimates);
colnames(posterior.estimates) <- c('y','sigma','post.mean','post.sd','post.shrink','5%','50%','95%');
str(posterior.estimates);
summary(posterior.estimates);
posterior.estimates;

### Exercise 7.13.3(b) #############################################################################
y     <- prior.and.data[['data']][,'y'];
sigma <- prior.and.data[['data']][,'sigma'];

mu.sample  <- gibbs.sample[,'mu'];
tau.sample <- exp(gibbs.sample[,'log.tau']);
FUN.temp <- function(i) {
	temp.var  <- sigma[i]^2 * tau.sample^2 / (sigma[i]^2 + tau.sample^2);
	temp.mean <- (tau.sample^2 * y[i] + sigma[i]^2 * mu.sample) / (tau.sample^2 + sigma[i]^2);
	p.i <- rnorm(
		n    = nrow(gibbs.sample),
		mean = temp.mean,
		sd   = sqrt(temp.var)
		);
	return( p.i );
	}
thetas.sample <- matrix(nrow = nrow(prior.and.data[['data']]), ncol = sample.size);
for (i in 1:nrow(thetas.sample)) { thetas.sample[i,] <- FUN.temp(i); }
str(thetas.sample);

post.theta1.exceeds.thetaj <- numeric(nrow(thetas.sample));
for (i in 1:nrow(thetas.sample)) {
	post.theta1.exceeds.thetaj[i] <- mean(thetas.sample[1,] > thetas.sample[i,]);
	}
cbind(prior.and.data[['data']],post.theta1.exceeds.thetaj);

####################################################################################################

q();

