
command.arguments <- commandArgs(trailingOnly = TRUE);
output.directory  <- command.arguments[1];
code.directory    <- command.arguments[2];

####################################################################################################
require(LearnBayes);
require(ggplot2);
require(scales);
require(coda);
#require(sn);

#source(paste(code.directory, "utils-monte-carlo.R", sep = "/"));

setwd(output.directory);

### AUXILIARY FUNCTIONS ############################################################################
log.posterior.pre.density <- function(model.parameters = NULL, prior.and.data = NULL) {
        
	DF.frequencies <- prior.and.data[['data']];
	p1  <- DF.frequencies['Category1','frequency'];
	p23 <- DF.frequencies['Category2','frequency'] + DF.frequencies['Category3','frequency'];
	p4  <- DF.frequencies['Category4','frequency'];

	eta          <- model.parameters;
	exp.eta      <- exp(eta);
	logistic.eta <- exp.eta / (1 + exp.eta);

	output.value <- p1 * (2+logistic.eta) + (p4+1) * logistic.eta - (p23+1) * (1+exp.eta);

        return(output.value);

        }

### Exercise 6.13.3(a) #############################################################################
prior.and.data <- list(
	data  = data.frame(frequency = c(125,18,20,34), row.names = paste('Category',1:4,sep=""))
	);
prior.and.data;

png("Fig1_posterior-density-vs-eta.png");
eta.min   <- -10;
eta.max   <-  10;
grid.size <- 1e-3;
etas <- eta.min + (eta.max - eta.min) * seq(0,1,grid.size);
posterior.pre.density <- exp(log.posterior.pre.density(
	model.parameters = etas,
	prior.and.data   = prior.and.data
	));
posterior.density <- posterior.pre.density / sum(grid.size * posterior.pre.density);
DF.temp <- data.frame(eta = etas, posterior.density = posterior.density);
qplot(data = DF.temp, x = eta, y = posterior.density, geom = "line", xlim = c(-1,1));
dev.off();

start.point <- 0;
laplace.results <- laplace(
	logpost = log.posterior.pre.density,
	mode    = start.point,
	prior.and.data
	);
laplace.results;

rwmetrop.proposal.parameters <- list(
	var   = 2 * laplace.results[['var']],
	scale = 2
	);

sample.size <- 1e+5;
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

eta.rwmetrop.sample <- as.numeric(rwmetrop.results[['par']]);
theta.rwmetrop.sample <- exp(eta.rwmetrop.sample) / (1 + exp(eta.rwmetrop.sample));
summary(theta.rwmetrop.sample);

png("Fig2_posterior-density-vs-theta.png");
theta.min <- 0.001;
theta.max <- 1-0.001;
grid.size <- 1e-3;
thetas    <- theta.min + (theta.max - theta.min) * seq(0,1,grid.size);
posterior.pre.density <- exp(log.posterior.pre.density(
	model.parameters = log(thetas/(1-thetas)),
	prior.and.data   = prior.and.data
	));
posterior.density <- posterior.pre.density / sum(grid.size * posterior.pre.density);
DF.temp <- data.frame(theta = thetas, posterior.density = posterior.density);
summary(thetas);
summary(log(thetas/(1-thetas)));
summary(posterior.density);
summary(DF.temp);
qplot(data = DF.temp, x = theta, y = posterior.density, geom = "line", xlim = c(0,1));
dev.off();

png("Fig3_rwmetrop-sample-density.png");
DF.temp <- data.frame(theta = thetas, posterior.density = posterior.density);
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_line(
	data = DF.temp,
	aes(x = theta, y = posterior.density),
	colour = "black"
	);
my.ggplot <- my.ggplot + geom_density(
	data = data.frame(theta = theta.rwmetrop.sample),
	aes(x = theta),
	colour = "red"
	);
my.ggplot <- my.ggplot + xlim(0,1);
my.ggplot;
dev.off();

### Exercise 6.13.3(b) #############################################################################
indepmetrop.proposal.parameters <- list(
	var   = 2 * laplace.results[['var']],
	scale = 2
	);

sample.size <- 1e+5;
indepmetrop.results <- rwmetrop(
	logpost  = log.posterior.pre.density,
	proposal = list(
		var   = 2 * laplace.results[['var']],
		scale = 2
		),
	start    = laplace.results[['mode']],
	m        = sample.size,
	prior.and.data
	);
str(indepmetrop.results);

eta.indepmetrop.sample <- as.numeric(indepmetrop.results[['par']]);
theta.indepmetrop.sample <- exp(eta.indepmetrop.sample) / (1 + exp(eta.indepmetrop.sample));
summary(theta.indepmetrop.sample);

png("Fig4_indepmetrop-sample-density.png");
DF.temp <- data.frame(theta = thetas, posterior.density = posterior.density);
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_line(
	data = DF.temp,
	aes(x = theta, y = posterior.density),
	colour = "black"
	);
my.ggplot <- my.ggplot + geom_density(
	data = data.frame(theta = theta.indepmetrop.sample),
	aes(x = theta),
	colour = "red"
	);
my.ggplot <- my.ggplot + xlim(0,1);
my.ggplot;
dev.off();

####################################################################################################

q();

