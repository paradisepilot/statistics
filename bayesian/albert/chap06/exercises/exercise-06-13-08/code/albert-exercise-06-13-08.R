
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

        y <- prior.and.data[['data']];

        log.pre.density <- NULL;
        if (is.null(dim(model.parameters))) {

                lambda.A <- exp(model.parameters[1]);
                lambda.B <- exp(model.parameters[2]);
                log.pre.density <- sum(log(
                        0.8 * dexp(y, 1 / lambda.A) + (1 - 0.8) * dexp(y, 1 / lambda.B)
                        ));

                } else {

                lambda.A <- exp(model.parameters[,1]);
                lambda.B <- exp(model.parameters[,2]);
                log.pre.density <- numeric(nrow(model.parameters));
                for (i in 1:length(log.pre.density)) {
                        log.pre.density[i] <- sum(log(
                                0.8 * dexp(y, 1 / lambda.A[i]) + (1 - 0.8)*dexp(y, 1 / lambda.B[i])
                                ));
                        }

                }

        return(log.pre.density);

        }

### CONTOUR PLOT OF POSTERIOR DENSITY ##############################################################
prior.and.data <- list(
	data = c(
		 9.3,  4.9,  3.5, 26.0,  0.6,  1.0,  3.5, 26.9,
		 2.6, 20.4,  1.0, 10.0,  1.7, 11.3,  7.7, 14.1,
		24.8,  3.8,  8.4,  1.1, 24.5, 90.7, 16.4, 30.7,
		 8.5,  5.9, 14.7,  0.5, 99.5, 35.2
		)
	);

grid.parameters <- list(
	xlimits            = c( 0,5),  # c(1,4)
	ylimits            = c(-4,10),  # c(-2,8)
	relative.grid.size = 2^(-8)
	);

theta.grid <- generate.grid(
	xlimits            = grid.parameters[['xlimits']],
	ylimits            = grid.parameters[['ylimits']],
	relative.grid.size = grid.parameters[['relative.grid.size']]
	);

DF.contour <- cbind(
	theta.grid,
	log.posterior.pre.density(
		model.parameters = theta.grid,
		prior.and.data   = prior.and.data
		)
	);
colnames(DF.contour) <- c('thetaA','thetaB','log.pre.density');
summary(DF.contour);

sample.size <- 1e+6;

parameter.limits = as.matrix(t(data.frame(
        thetaA = grid.parameters[['xlimits']],
        thetaB = grid.parameters[['ylimits']],
        row.names = c('min','max')
        )));
parameter.limits;

bootstrap.sample <- generate.bootstrap.sample(
	sample.size            = sample.size,
	log.pre.density        = log.posterior.pre.density,
	parameter.limits       = parameter.limits,
	pre.density.parameters = prior.and.data
	);
colnames(bootstrap.sample) <- c('thetaA','thetaB');
bootstrap.sample <- as.data.frame(bootstrap.sample);
str(bootstrap.sample);
summary(bootstrap.sample);

png("Fig01_posterior-contour.png");
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_point(
	data    = bootstrap.sample,
	mapping = aes(x = thetaA, y = thetaB),
	colour  = alpha('#CC5500',0.01)
	);
my.ggplot <- my.ggplot + stat_contour(
	data     = DF.contour,
	mapping  = aes(x = thetaA, y = thetaB, z = log.pre.density),
	color    = "black",
	binwidth = 0.75
	);
#my.ggplot <- my.ggplot + xlim(12,19) + ylim(-4,17);
my.ggplot;
dev.off();

### 6.13.8(a,b) ####################################################################################
### find posterior mode using laplace
laplace.results <- laplace(
	logpost = log.posterior.pre.density,
	mode = c(3,1),
	prior.and.data
	);
laplace.results;
log.posterior.pre.density(
	model.parameters = laplace.results[['mode']],
	prior.and.data = prior.and.data
	);

laplace.results <- laplace(
	logpost = log.posterior.pre.density,
	mode = c(2.25,4),
	prior.and.data
	);
laplace.results;
log.posterior.pre.density(
	model.parameters = laplace.results[['mode']],
	prior.and.data = prior.and.data
	);

### Exercise 6.13.8(a)
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
colnames(rwmetrop.sample) <- c('thetaA','thetaB');
#rwmetrop.sample <- rwmetrop.sample[-c(1:5000),];
str(rwmetrop.sample);
summary(rwmetrop.sample);

### Exercise 6.13.8(b)
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
colnames(gibbs.sample) <- c('thetaA','thetaB');
#gibbs.sample <- gibbs.sample[-c(1:5000),];
str(gibbs.sample);
summary(gibbs.sample);

### generate comparative density plots
png("Fig02_thetaA-posterior-densities.png");
my.levels <- c('bootstrap','rwmetrop','gibbs');
DF.bootstrap <- data.frame(
	thetaA = bootstrap.sample[,'thetaA'],
	sample = factor(rep('bootstrap',nrow(bootstrap.sample)),levels=my.levels)
	);
DF.rwmetrop <- data.frame(
	thetaA = rwmetrop.sample[,'thetaA'],
	sample = factor(rep('rwmetrop',nrow(rwmetrop.sample)),levels=my.levels)
	);
DF.gibbs <- data.frame(
	thetaA = gibbs.sample[,'thetaA'],
	sample = factor(rep('gibbs',nrow(gibbs.sample)),levels=my.levels)
	);
DF.temp <- rbind(DF.bootstrap,DF.rwmetrop,DF.gibbs);
qplot(data = DF.temp, x = thetaA, color = sample, geom = "density");
dev.off();

png("Fig03_thetaB-posterior-densities.png");
my.levels <- c('bootstrap','rwmetrop','gibbs');
DF.bootstrap <- data.frame(
	thetaB = bootstrap.sample[,'thetaB'],
	sample = factor(rep('bootstrap',nrow(bootstrap.sample)),levels=my.levels)
	);
DF.rwmetrop <- data.frame(
	thetaB = rwmetrop.sample[,'thetaB'],
	sample = factor(rep('rwmetrop',nrow(rwmetrop.sample)),levels=my.levels)
	);
DF.gibbs <- data.frame(
	thetaB = gibbs.sample[,'thetaB'],
	sample = factor(rep('gibbs',nrow(gibbs.sample)),levels=my.levels)
	);
DF.temp <- rbind(DF.bootstrap,DF.rwmetrop,DF.gibbs);
qplot(data = DF.temp, x = thetaB, color = sample, geom = "density");
dev.off();

### 6.13.8(c) ######################################################################################

### trace plots
png("Fig04_trace-plot-thetaA-rwmetrop.png");
DF.temp <- data.frame(
	iteration = 1:nrow(rwmetrop.sample),
	thetaA    = rwmetrop.sample[,'thetaA']
	);
qplot(data = DF.temp, x = iteration, y = thetaA, geom = "line");
dev.off();

png("Fig05_trace-plot-thetaA-gibbs.png");
DF.temp <- data.frame(
	iteration = 1:nrow(gibbs.sample),
	thetaA    = gibbs.sample[,'thetaA']
	);
qplot(data = DF.temp, x = iteration, y = thetaA, geom = "line");
dev.off();

png("Fig06_trace-plot-thetaB-rwmetrop.png");
DF.temp <- data.frame(
	iteration = 1:nrow(rwmetrop.sample),
	thetaB    = rwmetrop.sample[,'thetaB']
	);
qplot(data = DF.temp, x = iteration, y = thetaB, geom = "line");
dev.off();

png("Fig07_trace-plot-thetaB-gibbs.png");
DF.temp <- data.frame(
	iteration = 1:nrow(gibbs.sample),
	thetaB    = gibbs.sample[,'thetaB']
	);
qplot(data = DF.temp, x = iteration, y = thetaB, geom = "line");
dev.off();

### autocorrelation plots
png("Fig08_autocorrelation-rwmetrop.png");
acf(
        x       = rwmetrop.sample[-c(1:2000),c('thetaA','thetaB')],
        lag.max = 200,
        type    = "correlation",
        plot    = TRUE
        );
dev.off();

png("Fig09_autocorrelation-gibbs.png");
acf(
        x       = gibbs.sample[-c(1:2000),c('thetaA','thetaB')],
        lag.max = 200,
        type    = "correlation",
        plot    = TRUE
        );
dev.off();

### trajectory plots
png("Fig10_trajectory-plot-rwmetrop.png");
selected.rows <- (nrow(rwmetrop.sample)-2500):nrow(rwmetrop.sample);
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_path(
	data    = rwmetrop.sample[selected.rows,],
	mapping = aes(x = thetaA, y = thetaB),
	colour  = "black"
	);
my.ggplot <- my.ggplot + stat_contour(
	data     = DF.contour,
	mapping  = aes(x = thetaA, y = thetaB, z = log.pre.density),
	color    = alpha("red",0.99),
	binwidth = 1.5
	);
my.ggplot <- my.ggplot + xlim(1,4) + ylim(-3,8);
my.ggplot;
dev.off();

png("Fig11_trajectory-plot-gibbs.png");
selected.rows <- (nrow(gibbs.sample)-2500):nrow(gibbs.sample);
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_path(
	data    = gibbs.sample[selected.rows,],
	mapping = aes(x = thetaA, y = thetaB),
	colour  = "black"
	);
my.ggplot <- my.ggplot + stat_contour(
	data     = DF.contour,
	mapping  = aes(x = thetaA, y = thetaB, z = log.pre.density),
	color    = alpha("red",0.99),
	binwidth = 1.5
	);
my.ggplot <- my.ggplot + xlim(1,4) + ylim(-3,8);
my.ggplot;
dev.off();

####################################################################################################

q();

