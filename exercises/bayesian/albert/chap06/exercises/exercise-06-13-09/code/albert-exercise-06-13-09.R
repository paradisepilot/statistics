
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

	observations <- prior.and.data[['data']];

	Y <- apply(X = observations, MARGIN = 1, FUN = mean);
	n <- ncol(observations);
	S <- apply(X = observations, MARGIN = 1, FUN = var ) * (n - 1);

	log.pre.density <- NULL;
	if (is.null(dim(model.parameters))) {

		mu      <- model.parameters[1];
		sigma.y <- exp(model.parameters[2]);
		sigma.b <- exp(model.parameters[3]);

		log.pre.density <- model.parameters[2] + model.parameters[3] + sum(
			dnorm(x = Y, mean = mu, sd = sqrt(sigma.y^2/n+sigma.b^2), log = TRUE)
			+ dgamma(x = S, shape = (n-1)/2, rate = 1/(2*sigma.y^2), log = TRUE)
			);

		} else {

		mu      <- model.parameters[,1];
		sigma.y <- exp(model.parameters[,2]);
		sigma.b <- exp(model.parameters[,3]);

		log.pre.density <- numeric(nrow(model.parameters));
		for (i in 1:length(log.pre.density)) {
			log.pre.density[i] <- model.parameters[i,2] + model.parameters[i,3] + sum(
				dnorm(
					x    = Y,
					mean = mu[i],
					sd   = sqrt(sigma.y[i]^2/n+sigma.b[i]^2),
					log  = TRUE
					)
				+ dgamma(
					x = S,
					shape = (n-1)/2,
					rate = 1/(2*sigma.y[i]^2),
					log = TRUE
					)
				);
			}
		}

	return(log.pre.density);

	}

### 6.13.9(a) ######################################################################################
prior.and.data <- list(
	data = matrix(
		nrow  = 6,
		ncol  = 5,
		byrow = TRUE,
		data  = c(
			1545, 1440, 1440, 1520, 1580,
			1540, 1555, 1490, 1560, 1495,
			1595, 1550, 1605, 1510, 1560,
			1445, 1440, 1595, 1465, 1545,
			1595, 1630, 1515, 1635, 1625,
			1520, 1455, 1450, 1480, 1445
			)
		)
	);
prior.and.data;

### determine posterior mode
laplace.results <- laplace(
	logpost        = log.posterior.pre.density,
	mode           = c(1500,10,10),
	prior.and.data = prior.and.data
	);
laplace.results;

### generate posterior sample using random walk Metropolis
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

rwmetrop.sample <- as.data.frame(rwmetrop.results[['par']]);
colnames(rwmetrop.sample) <- c('mu','log.sigma.y','log.sigma.b');
#rwmetrop.sample <- rwmetrop.sample[-c(1:5000),];
str(rwmetrop.sample);
summary(rwmetrop.sample);

### 6.13.9(b) ######################################################################################
### generate posterior sample using "Metropolis with Gibbs"
sample.size <- 1e+5;

gibbs.results <- gibbs(
	logpost  = log.posterior.pre.density,
	start    = laplace.results[['mode']],
	m        = sample.size,
	scale    = 2 * diag(laplace.results[['var']]),
	prior.and.data
	);
str(gibbs.results);

gibbs.sample <- as.data.frame(gibbs.results[['par']]);
colnames(gibbs.sample) <- c('mu','log.sigma.y','log.sigma.b');
#gibbs.sample <- gibbs.sample[-c(1:5000),];
str(gibbs.sample);
summary(gibbs.sample);

### 6.13.9(c) ######################################################################################

### comparative density plots
png("Fig01_mu-posterior-densities.png");
my.levels <- c('rwmetrop','gibbs');
DF.rwmetrop <- data.frame(
	mu     = rwmetrop.sample[,'mu'],
	sample = factor(rep('rwmetrop',nrow(rwmetrop.sample)),levels=my.levels)
	);
DF.gibbs <- data.frame(
	mu     = gibbs.sample[,'mu'],
	sample = factor(rep('gibbs',nrow(gibbs.sample)),levels=my.levels)
	);
DF.temp <- rbind(DF.rwmetrop,DF.gibbs);
qplot(data = DF.temp, x = mu, color = sample, geom = "density");
dev.off();

png("Fig02_log-sigma-y-posterior-densities.png");
my.levels <- c('rwmetrop','gibbs');
DF.rwmetrop <- data.frame(
	log.sigma.y = rwmetrop.sample[,'log.sigma.y'],
	sample      = factor(rep('rwmetrop',nrow(rwmetrop.sample)),levels=my.levels)
	);
DF.gibbs <- data.frame(
	log.sigma.y = gibbs.sample[,'log.sigma.y'],
	sample      = factor(rep('gibbs',nrow(gibbs.sample)),levels=my.levels)
	);
DF.temp <- rbind(DF.rwmetrop,DF.gibbs);
qplot(data = DF.temp, x = log.sigma.y, color = sample, geom = "density");
dev.off();

png("Fig03_log-sigma-b-posterior-densities.png");
my.levels <- c('rwmetrop','gibbs');
DF.rwmetrop <- data.frame(
	log.sigma.b = rwmetrop.sample[,'log.sigma.b'],
	sample      = factor(rep('rwmetrop',nrow(rwmetrop.sample)),levels=my.levels)
	);
DF.gibbs <- data.frame(
	log.sigma.b = gibbs.sample[,'log.sigma.b'],
	sample      = factor(rep('gibbs',nrow(gibbs.sample)),levels=my.levels)
	);
DF.temp <- rbind(DF.rwmetrop,DF.gibbs);
qplot(data = DF.temp, x = log.sigma.b, color = sample, geom = "density");
dev.off();

### trace plots
png("Fig04_trace-plot-mu-rwmetrop.png");
DF.temp <- data.frame(
	iteration = 1:nrow(rwmetrop.sample),
	mu        = rwmetrop.sample[,'mu']
	);
qplot(data = DF.temp, x = iteration, y = mu, geom = "line");
dev.off();

png("Fig05_trace-plot-mu-gibbs.png");
DF.temp <- data.frame(
	iteration = 1:nrow(gibbs.sample),
	mu        = gibbs.sample[,'mu']
	);
qplot(data = DF.temp, x = iteration, y = mu, geom = "line");
dev.off();

png("Fig06_trace-plot-log-sigma-y-rwmetrop.png");
DF.temp <- data.frame(
	iteration   = 1:nrow(rwmetrop.sample),
	log.sigma.y = rwmetrop.sample[,'log.sigma.y']
	);
qplot(data = DF.temp, x = iteration, y = log.sigma.y, geom = "line");
dev.off();

png("Fig07_trace-plot-log-sigma-y-gibbs.png");
DF.temp <- data.frame(
	iteration   = 1:nrow(gibbs.sample),
	log.sigma.y = gibbs.sample[,'log.sigma.y']
	);
qplot(data = DF.temp, x = iteration, y = log.sigma.y, geom = "line");
dev.off();

png("Fig08_trace-plot-log-sigma-b-rwmetrop.png");
DF.temp <- data.frame(
	iteration   = 1:nrow(rwmetrop.sample),
	log.sigma.b = rwmetrop.sample[,'log.sigma.b']
	);
qplot(data = DF.temp, x = iteration, y = log.sigma.b, geom = "line");
dev.off();

png("Fig09_trace-plot-log-sigma-b-gibbs.png");
DF.temp <- data.frame(
	iteration   = 1:nrow(gibbs.sample),
	log.sigma.b = gibbs.sample[,'log.sigma.b']
	);
qplot(data = DF.temp, x = iteration, y = log.sigma.b, geom = "line");
dev.off();

### autocorrelation plots
png("Fig10_autocorrelation-rwmetrop.png");
acf(
        x       = rwmetrop.sample[-c(1:2000),c('mu','log.sigma.y','log.sigma.b')],
        lag.max = 200,
        type    = "correlation",
        plot    = TRUE
        );
dev.off();

png("Fig11_autocorrelation-gibbs.png");
acf(
        x       = gibbs.sample[-c(1:2000),c('mu','log.sigma.y','log.sigma.b')],
        lag.max = 200,
        type    = "correlation",
        plot    = TRUE
        );
dev.off();

####################################################################################################

q();

