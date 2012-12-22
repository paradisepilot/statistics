
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
log.posterior.cauchy.errors <- function(model.parameters = NULL, prior.and.data = NULL) {
        
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

log.bivariate.normal <- function(model.parameters = NULL, prior.and.data = NULL) {
        
	output.value <- NULL;
	if (is.null(dim(model.parameters))) {

		output.value <- as.numeric(lbinorm(xy = model.parameters, par = prior.and.data));

		} else {

		output.value <- numeric(nrow(model.parameters));
		for (i in 1:length(output.value)) {
			output.value[i] <- as.numeric(
				lbinorm(xy = model.parameters[i,], par = prior.and.data)
				);
			}

		}

        return(output.value);

        }

### SECTION 6.9 ####################################################################################
prior.and.data <- list(observations = LearnBayes::darwin[,'difference']);

### Fig. 6.8, p.137
grid.parameters <- list(
        xlimits            = c(-10,60),
        ylimits            = c(1.0,4.5),
        relative.grid.size = 1e-2
        );

model.parameters.grid <- generate.grid(
        xlimits            = grid.parameters[['xlimits']],
        ylimits            = grid.parameters[['ylimits']],
        relative.grid.size = grid.parameters[['relative.grid.size']]
        );

DF.posterior.contour <- as.data.frame(cbind(
        model.parameters.grid,
        log.posterior = log.posterior.cauchy.errors(
                model.parameters = model.parameters.grid,
                prior.and.data   = prior.and.data
                )
        ));
colnames(DF.posterior.contour) <- c('mu','log.sigma','log.posterior');

laplace.results <- laplace(
	logpost = log.posterior.cauchy.errors,
	mode = c(mean(prior.and.data[['observations']]),log(sd(prior.and.data[['observations']]))),
	prior.and.data
	);
laplace.results;

DF.bivariate.normal.contour <- as.data.frame(cbind(
	model.parameters.grid,
	log.posterior = log.bivariate.normal(
		model.parameters = model.parameters.grid,
		prior.and.data   = list(
			m = laplace.results[['mode']],
			v = laplace.results[['var']]
			)
		)
        ));
colnames(DF.bivariate.normal.contour) <- c('mu','log.sigma','log.bivariate.normal');
str(DF.bivariate.normal.contour);
summary(DF.bivariate.normal.contour);

bootstrap.sample <- as.data.frame(generate.bootstrap.sample(
        sample.size = 1e+6,
        logf        = log.posterior.cauchy.errors,
        xlimits     = grid.parameters[['xlimits']],
        ylimits     = grid.parameters[['ylimits']],
        parameters  = prior.and.data
        ));
colnames(bootstrap.sample) <- c('mu','log.sigma');
str(bootstrap.sample);
summary(bootstrap.sample);

proposal.parameters <- list(var = laplace.results[['var']], scale = 2.5);
rw.metropolis.results <- rwmetrop(
        logpost  = log.posterior.cauchy.errors,
        proposal = proposal.parameters,
        start    = c(20,3),
        m        = 1e+5,
        prior.and.data
        );
str(rw.metropolis.results);
summary(rw.metropolis.results);

rw.metropolis.sample <- as.data.frame(rw.metropolis.results[['par']]);
rw.metropolis.sample <- rw.metropolis.sample[-c(1:2000),];
colnames(rw.metropolis.sample) <- c('mu','log.sigma');
str(rw.metropolis.sample);
summary(rw.metropolis.sample);

proposal.parameters <- list(mu = t(laplace.results[['mode']]), var = laplace.results[['var']]);
indep.metropolis.results <- indepmetrop(
        logpost  = log.posterior.cauchy.errors,
        proposal = proposal.parameters,
        start    = c(20,3),
        m        = 1e+5,
        prior.and.data
        );
str(indep.metropolis.results);
summary(indep.metropolis.results);

indep.metropolis.sample <- as.data.frame(indep.metropolis.results[['par']]);
indep.metropolis.sample <- indep.metropolis.sample[-c(1:2000),];
colnames(indep.metropolis.sample) <- c('mu','log.sigma');
str(indep.metropolis.sample);
summary(indep.metropolis.sample);

gibbs.sampling.results <- gibbs(
        logpost  = log.posterior.cauchy.errors,
        start    = c(20,3),
        m        = 1e+5,
	scale    = c(12,0.75),
        prior.and.data
        );
str(gibbs.sampling.results);
summary(gibbs.sampling.results);

gibbs.sampling.sample <- as.data.frame(gibbs.sampling.results[['par']]);
gibbs.sampling.sample <- gibbs.sampling.sample[-c(1:2000),];
colnames(gibbs.sampling.sample) <- c('mu','log.sigma');
str(gibbs.sampling.sample);
summary(gibbs.sampling.sample);

### Fig. 6.6, 6.7, 6.8 (combined into one), p.135, p.136, p.137.
png("Fig6-08.png");
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_point(
        data = bootstrap.sample,
        aes(x = mu, y = log.sigma),
        colour = alpha("red",0.01)
        );
my.ggplot <- my.ggplot + stat_contour(
        data = DF.posterior.contour,
        aes(x = mu, y = log.sigma, z = log.posterior),
	binwidth = 0.5
        );
my.ggplot <- my.ggplot + stat_contour(
        data = DF.bivariate.normal.contour,
        aes(x = mu, y = log.sigma, z = log.bivariate.normal),
	binwidth = 1,
	colour = "cyan"
        );
my.ggplot;
dev.off();

### Fig. 6.9, p.138
png("Fig6-09.png");
my.levels <- c('bootstrap','rw.metropolis','indep.metropolis','gibbs','bivariate normal');
DF.temp.bootstrap <- data.frame(
	mu   = bootstrap.sample[,'mu'],
	type = factor(rep('bootstrap',nrow(bootstrap.sample)),levels=my.levels)
	);
DF.temp.rw.metropolis <- data.frame(
	mu   = rw.metropolis.sample[,'mu'],
	type = factor(rep('rw.metropolis',nrow(rw.metropolis.sample)),levels=my.levels)
	);
DF.temp.indep.metropolis <- data.frame(
	mu   = indep.metropolis.sample[,'mu'],
	type = factor(rep('indep.metropolis',nrow(indep.metropolis.sample)),levels=my.levels)
	);
DF.temp.gibbs <- data.frame(
	mu   = gibbs.sampling.sample[,'mu'],
	type = factor(rep('gibbs',nrow(gibbs.sampling.sample)),levels=my.levels)
	);
DF.temp <- rbind(DF.temp.bootstrap,DF.temp.rw.metropolis,DF.temp.indep.metropolis,DF.temp.gibbs);
qplot(data = DF.temp, x = mu, colour = type, geom = "density");
dev.off();

### Fig. 6.10, p.139
png("Fig6-10.png");
my.levels <- c('bootstrap','rw.metropolis','indep.metropolis','gibbs','bivariate normal');
DF.temp.bootstrap <- data.frame(
	log.sigma = bootstrap.sample[,'log.sigma'],
	type      = factor(rep('bootstrap',nrow(bootstrap.sample)),levels=my.levels)
	);
DF.temp.rw.metropolis <- data.frame(
	log.sigma = rw.metropolis.sample[,'log.sigma'],
	type      = factor(rep('rw.metropolis',nrow(rw.metropolis.sample)),levels=my.levels)
	);
DF.temp.indep.metropolis <- data.frame(
	log.sigma = indep.metropolis.sample[,'log.sigma'],
	type      = factor(rep('indep.metropolis',nrow(indep.metropolis.sample)),levels=my.levels)
	);
DF.temp.gibbs <- data.frame(
	log.sigma = gibbs.sampling.sample[,'log.sigma'],
	type      = factor(rep('gibbs',nrow(gibbs.sampling.sample)),levels=my.levels)
	);
DF.temp <- rbind(DF.temp.bootstrap,DF.temp.rw.metropolis,DF.temp.indep.metropolis,DF.temp.gibbs);
qplot(data = DF.temp, x = log.sigma, colour = type, geom = "density");
dev.off();

####################################################################################################

q();

