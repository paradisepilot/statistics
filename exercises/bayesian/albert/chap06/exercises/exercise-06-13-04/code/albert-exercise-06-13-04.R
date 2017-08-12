
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
log.posterior.pre.density.cauchy.errors <- function(model.parameters = NULL, prior.and.data = NULL) {
        
	y <- prior.and.data[['observations']];

	output.value <- NULL;
	if (is.null(dim(model.parameters))) {

		mu    <- model.parameters[1];
		sigma <- exp(model.parameters[2]);

		temp <- dt(x = (y - mu)/sigma, df = 1);
		temp <- log(temp / sigma);

		output.value <- sum(temp);

		} else {

		mu    <- model.parameters[,1];
		sigma <- exp(model.parameters[,2]);

		output.value <- numeric(nrow(model.parameters));
		for (i in 1:length(output.value)) {

			temp <- dt(x = (y - mu[i])/sigma[i], df = 1);
			temp <- log(temp / sigma[i]);

			output.value[i] <- sum(temp);

			}

		}

	return(output.value);

        }

### Exercise 6.13.4(a) #############################################################################
prior.and.data <- list(observations = c(36,13,23,6,20,12,23,93,98,91,89,100,90,95,90,87));

grid.parameters <- list(
	xlimits            = c(-30,150),
	ylimits            = c(-2,7),
	relative.grid.size = 2^(-8)
	);

model.parameters.grid <- generate.grid(
	xlimits            = grid.parameters[['xlimits']],
	ylimits            = grid.parameters[['ylimits']],
	relative.grid.size = grid.parameters[['relative.grid.size']]
	);

DF.posterior.contour <- as.data.frame(cbind(
	model.parameters.grid,
	log.posterior = log.posterior.pre.density.cauchy.errors(
		model.parameters = model.parameters.grid,
		prior.and.data   = prior.and.data
		)
	));
colnames(DF.posterior.contour) <- c('mu','log.sigma','log.posterior');
summary(DF.posterior.contour);

bootstrap.sample <- as.data.frame(generate.bootstrap.sample(
	sample.size = 1e+6,
	logf        = log.posterior.pre.density.cauchy.errors,
	xlimits     = grid.parameters[['xlimits']],
	ylimits     = grid.parameters[['ylimits']],
	parameters  = prior.and.data
	));
colnames(bootstrap.sample) <- c('mu','log.sigma');
str(bootstrap.sample);
summary(bootstrap.sample);

### Fig. 6.12, p.149
png("Fig6-12.png");
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_point(
	data = bootstrap.sample,
	aes(x = mu, y = log.sigma),
	colour = alpha("#CC5500",0.05)
	);
my.ggplot <- my.ggplot + stat_contour(
	data = DF.posterior.contour,
	aes(x = mu, y = log.sigma, z = log.posterior),
	binwidth = 2
	);
my.ggplot;
dev.off();

### find posterior mode using laplace
laplace.results <- laplace(
	logpost = log.posterior.pre.density.cauchy.errors,
	mode = c(mean(prior.and.data[['observations']]),log(sd(prior.and.data[['observations']]))),
	prior.and.data
	);
laplace.results;

### Exercise 6.13.4(b) #############################################################################
sample.size <- 1e+5;
rwmetrop.results <- rwmetrop(
	logpost  = log.posterior.pre.density.cauchy.errors,
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
colnames(rwmetrop.sample) <- c('mu','log.sigma');
summary(rwmetrop.sample);

png("Fig1_rwmetrop-sample-scatterplot.png");
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_point(
	data = rwmetrop.sample,
	aes(x = mu, y = log.sigma),
	colour = alpha("cyan4",0.05)
	);
my.ggplot <- my.ggplot + stat_contour(
	data = DF.posterior.contour,
	aes(x = mu, y = log.sigma, z = log.posterior),
	binwidth = 2
	);
my.ggplot;
dev.off();

png("Fig2_mu-posterior-densities.png");
my.levels <- c('bootstrap','rwmetrop');
DF.bootstrap <- data.frame(
	mu     = bootstrap.sample[,'mu'],
	sample = factor(rep('bootstrap',nrow(bootstrap.sample)),levels=my.levels)
	);
DF.rwmetrop <- data.frame(
	mu     = rwmetrop.sample[,'mu'],
	sample = factor(rep('rwmetrop',nrow(rwmetrop.sample)),levels=my.levels)
	);
DF.temp <- rbind(DF.bootstrap,DF.rwmetrop);
qplot(data = DF.temp, x = mu, color = sample, geom = "density");
dev.off();

png("Fig3_log-sigma-posterior-densities.png");
my.levels <- c('bootstrap','rwmetrop');
DF.bootstrap <- data.frame(
	log.sigma = bootstrap.sample[,'log.sigma'],
	sample    = factor(rep('bootstrap',nrow(bootstrap.sample)),levels=my.levels)
	);
DF.rwmetrop <- data.frame(
	log.sigma = rwmetrop.sample[,'log.sigma'],
	sample    = factor(rep('rwmetrop',nrow(rwmetrop.sample)),levels=my.levels)
	);
DF.temp <- rbind(DF.bootstrap,DF.rwmetrop);
qplot(data = DF.temp, x = log.sigma, color = sample, geom = "density");
dev.off();

####################################################################################################

q();

