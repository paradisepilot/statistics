
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
        
	y <- prior.and.data[['data']][,'y'];
	n <- prior.and.data[['data']][,'n'];
	J <- nrow(prior.and.data[['data']]);

	output.value <- NULL;
	if (is.null(dim(model.parameters))) {

		theta1 <- model.parameters[1];
		theta2 <- model.parameters[2];

		K          <- exp(theta1);
		exp.theta2 <- exp(theta2);
		eta        <- exp.theta2 / (1 + exp.theta2);

		K.eta         <- K * eta;
		K.1.minus.eta <- K - K.eta;

		temp <- lbeta(
			a = K.eta + y,
			b = K.1.minus.eta + n - y
			);
		temp <- sum(temp) - J * lbeta(a = K.eta, b = K.1.minus.eta) - 2 * (1 + K);

		output.value <- temp;

		} else {

		theta1 <- model.parameters[,1];
		theta2 <- model.parameters[,2];

		K          <- exp(theta1);
		exp.theta2 <- exp(theta2);
		eta        <- exp.theta2 / (1 + exp.theta2);

		K.eta         <- K * eta;
		K.1.minus.eta <- K - K.eta;

		FUN.temp <- function(i) {
			temp <- lbeta(
				a = K.eta[i] + y,
				b = K.1.minus.eta[i] + n - y
				);
			temp <- sum(temp);
			temp <- temp - J * lbeta(a = K.eta[i], b = K.1.minus.eta[i]);
			temp <- temp - 2 * (1 + K[i]);
			return(temp);
			}
		output.value <- sapply(X = 1:nrow(model.parameters), FUN = FUN.temp);

		}

	return(output.value);

        }

### Exercise 7.13.4(a) #############################################################################
prior.and.data <- list(data = cancermortality);
prior.and.data;

prior.and.data[['data']][,'y'] / prior.and.data[['data']][,'n'];

theta1.0 <-  0.5;
theta2.0 <- -2.5;

laplace.results <- laplace(
	logpost        = log.posterior.pre.density,
	mode           = c(theta1.0,theta2.0),
	prior.and.data = prior.and.data
	);
laplace.results;

grid.xlimits <-  0.5 + 5 * c(-1,1);
grid.ylimits <- -2.5 + 5 * c(-1,1);

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
colnames(DF.contour) <- c('theta1','theta2','log.pre.density');
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
colnames(gibbs.sample) <- c('theta1','theta2');
str(gibbs.sample);
summary(gibbs.sample);

png("Fig1_posterior-contour.png");
my.ggplot <- ggplot();
my.ggplot <- my.ggplot + geom_point(
	data    = gibbs.sample,
	mapping = aes(x = theta1, y = theta2),
	colour  = alpha("#CC5500",0.01)
	);
my.ggplot <- my.ggplot + stat_contour(
	data     = DF.contour,
	mapping  = aes(x = theta1, y = theta2, z = log.pre.density),
	binwidth = 25
	);
my.ggplot <- my.ggplot + xlim(grid.xlimits) + ylim(grid.ylimits);
my.ggplot;
dev.off();

### Exercise 7.13.4(b) #############################################################################
theta1.sample <- gibbs.sample[,'theta1'];
theta2.sample <- gibbs.sample[,'theta2'];

eta.sample <- exp(theta2.sample) / (1 + exp(theta2.sample));
K.sample   <- exp(theta1.sample);

t(data.frame(
	eta = quantile(x = eta.sample, probs = c(0.05,0.95)),
	K   = quantile(x = K.sample,   probs = c(0.05,0.95))
	));

png("Fig2_eta-posterior-density.png");
qplot(x = eta.sample, geom = "density");
dev.off();

png("Fig3_K-posterior-density.png");
qplot(x = K.sample, geom = "density");
dev.off();

### Exercise 7.13.4(c) #############################################################################
y <- prior.and.data[['data']][,'y'];
n <- prior.and.data[['data']][,'n'];

K.eta         <- K.sample * eta.sample;
K.1.minus.eta <- K.sample - K.sample * eta.sample;

FUN.temp <- function(i) {
	p.i <- rbeta(
		n      = length(K.eta),
		shape1 = K.eta + y[i],
		shape2 = K.1.minus.eta + n[i] - y[i]
		);
	output.value <- c(mean(p.i),sd(p.i),quantile(x = p.i, probs = c(0.05,0.95)));
	return( output.value );
	}

posterior.estimates <- matrix(nrow = nrow(prior.and.data[['data']]), ncol = 4);
for (i in 1:nrow(posterior.estimates)) { posterior.estimates[i,] <- FUN.temp(i); }

posterior.estimates <- cbind(
	prior.and.data[['data']],
	y.over.n = prior.and.data[['data']][,'y'] / prior.and.data[['data']][,'n'],
	posterior.estimates
	);
colnames(posterior.estimates) <- c('y','n','y/n','post.mean','post.sd','5%','95%');
str(posterior.estimates);
summary(posterior.estimates);
posterior.estimates;

### Exercise 7.13.5(a) #############################################################################
y <- prior.and.data[['data']][,'y'];
n <- prior.and.data[['data']][,'n'];

K.eta         <- K.sample * eta.sample;
K.1.minus.eta <- K.sample - K.sample * eta.sample;

FUN.temp <- function(i) {
	p.i <- rbeta(
		n      = length(K.eta),
		shape1 = K.eta + y[i],
		shape2 = K.1.minus.eta + n[i] - y[i]
		);
	y.i <- rbinom(
		n    = length(p.i),
		size = n[i],
		prob = p.i
		);
	return( y.i );
	}

y.post.prediction <- matrix(nrow = nrow(prior.and.data[['data']]), ncol = length(K.eta));
for (i in 1:nrow(y.post.prediction)) { y.post.prediction[i,] <- FUN.temp(i); }
str(y.post.prediction);

### Exercise 7.13.5(b) #############################################################################
for (i in 1:nrow(y.post.prediction)) {

	png.filename <- paste(
		"posterior-prediction-city-",
		formatC(i,width=2,format="d",flag="0"),
		".png",
		sep = ""
		);

	png(filename = png.filename);
	my.ggplot <- ggplot();
	DF.temp <- data.frame(y.predicted = y.post.prediction[i,]);
	my.ggplot <- my.ggplot + geom_histogram(
		data     = DF.temp,
		mapping  = aes(x = y.predicted),
		fill     = alpha("gray",0.5),
		colour   = alpha("black",0.5),
		binwidth = 1
		);
	my.ggplot <- my.ggplot + geom_vline(xintercept = y[i], colour = "red");
	print(my.ggplot);
	dev.off();

	}

####################################################################################################

q();

