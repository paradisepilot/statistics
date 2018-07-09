
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

	x <- prior.and.data[['observations']][,'x'];
	y <- prior.and.data[['observations']][,'y'];

	if (is.null(dim(model.parameters))) {
		beta <- matrix(model.parameters, nrow = 1);
		} else {
		beta <- as.matrix(model.parameters);
		}

	X <- rbind(rep(1,length(x)),x);
	log.pre.density <- rowSums(beta %*% (X %*% diag(y)) - exp(beta %*% X));

	return(log.pre.density);

	}

### Exercise 6.13.6(a,b) ###########################################################################
MATRIX.observations <- as.matrix(
	data.frame(x=1:18,y=c(15,11,14,17,5,11,10,4,8,10,7,9,11,3,6,1,1,4))
	);
prior.and.data <- list(observations = MATRIX.observations);

sample.size <- 1e+6;
bootstrap.sample <- generate.bootstrap.sample(
	sample.size    = sample.size,
	logf           = log.posterior.pre.density,
	xlimits        = c( 0,  5  ),
	ylimits        = c(-0.5,0.5),
	prior.and.data = prior.and.data
	);
bootstrap.sample <- as.data.frame(bootstrap.sample);
colnames(bootstrap.sample) <- c('beta0','beta1');
summary(bootstrap.sample);

beta.grid <- generate.grid(
	xlimits            = c( 0,  5  ),
	ylimits            = c(-0.5,0.5),
	relative.grid.size = 2^(-7)
	);

DF.log.posterior.contour <- cbind(
	beta.grid,
	log.posterior.pre.density(
		model.parameters = beta.grid,
		prior.and.data   = prior.and.data
		)
	);
colnames(DF.log.posterior.contour) <- c('beta0','beta1','log.pre.density');
summary(DF.log.posterior.contour);

png("Fig01_bootstrap-sample-scatter-plot.png");
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_point(
        data = bootstrap.sample,
        aes(x = beta0, y = beta1),
        color = alpha("#CC5500",0.005)
        );
my.ggplot <- my.ggplot + stat_contour(
        data = DF.log.posterior.contour,
        aes(x = beta0, y = beta1, z = log.pre.density),
        color = "black",
	#binwidth = 250
        );
#my.ggplot <- my.ggplot + xlim(12,19) + ylim(-4,17);
my.ggplot;
dev.off();

### find posterior mode using laplace
laplace.results <- laplace(
	logpost = log.posterior.pre.density,
	mode = c(2.75,-0.1),
	prior.and.data
	);
laplace.results;

### generate posterior sample using random walk Metropolis
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
colnames(rwmetrop.sample) <- c('beta0','beta1');
rwmetrop.sample <- rwmetrop.sample[-c(1:5000),];
str(rwmetrop.sample);
summary(rwmetrop.sample);

### generate posterior sample using independent Metropolis
sample.size <- 1e+6;
indepmetrop.results <- indepmetrop(
	logpost  = log.posterior.pre.density,
	proposal = list(
		mu    = laplace.results[['mode']],
		var   = laplace.results[['var']]
		),
	start    = laplace.results[['mode']],
	m        = sample.size,
	prior.and.data
	);
str(indepmetrop.results);

indepmetrop.sample <- as.data.frame(indepmetrop.results[['par']]);
colnames(indepmetrop.sample) <- c('beta0','beta1');
indepmetrop.sample <- indepmetrop.sample[-c(1:5000),];
str(indepmetrop.sample);
summary(indepmetrop.sample);

### generate diagnostic plots
png("Fig02_rwmetrop-sample-scatter-plot.png");
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_point(
        data = rwmetrop.sample,
        aes(x = beta0, y = beta1),
        color = alpha("cyan3",0.005)
        );
my.ggplot <- my.ggplot + stat_contour(
        data = DF.log.posterior.contour,
        aes(x = beta0, y = beta1, z = log.pre.density),
        color = "black",
        #binwidth = 500
        );
#my.ggplot <- my.ggplot + xlim(12,19) + ylim(-4,17);
my.ggplot;
dev.off();

png("Fig03_indepmetrop-sample-scatter-plot.png");
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_point(
        data = indepmetrop.sample,
        aes(x = beta0, y = beta1),
        color = alpha("aquamarine",0.005)
        );
my.ggplot <- my.ggplot + stat_contour(
        data = DF.log.posterior.contour,
        aes(x = beta0, y = beta1, z = log.pre.density),
        color = "black",
        #binwidth = 500
        );
#my.ggplot <- my.ggplot + xlim(12,19) + ylim(-4,17);
my.ggplot;
dev.off();

png("Fig04_beta0-posterior-densities.png");
my.levels <- c('bootstrap','rwmetrop','indepmetrop');
DF.bootstrap <- data.frame(
	beta0  = bootstrap.sample[,'beta0'],
	sample = factor(rep('bootstrap',nrow(bootstrap.sample)),levels=my.levels)
	);
DF.rwmetrop <- data.frame(
	beta0  = rwmetrop.sample[,'beta0'],
	sample = factor(rep('rwmetrop',nrow(rwmetrop.sample)),levels=my.levels)
	);
DF.indepmetrop <- data.frame(
	beta0  = indepmetrop.sample[,'beta0'],
	sample = factor(rep('indepmetrop',nrow(indepmetrop.sample)),levels=my.levels)
	);
DF.temp <- rbind(DF.bootstrap,DF.rwmetrop,DF.indepmetrop);
qplot(data = DF.temp, x = beta0, color = sample, geom = "density");
dev.off();

png("Fig05_beta1-posterior-densities.png");
my.levels <- c('bootstrap','rwmetrop','indepmetrop');
DF.bootstrap <- data.frame(
	beta1  = bootstrap.sample[,'beta1'],
	sample = factor(rep('bootstrap',nrow(bootstrap.sample)),levels=my.levels)
	);
DF.rwmetrop <- data.frame(
	beta1  = rwmetrop.sample[,'beta1'],
	sample = factor(rep('rwmetrop',nrow(rwmetrop.sample)),levels=my.levels)
	);
DF.indepmetrop <- data.frame(
	beta1  = indepmetrop.sample[,'beta1'],
	sample = factor(rep('indepmetrop',nrow(rwmetrop.sample)),levels=my.levels)
	);
DF.temp <- rbind(DF.bootstrap,DF.rwmetrop,DF.indepmetrop);
qplot(data = DF.temp, x = beta1, color = sample, geom = "density");
dev.off();

####################################################################################################

q();

