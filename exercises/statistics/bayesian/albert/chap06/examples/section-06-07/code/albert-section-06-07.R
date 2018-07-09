
command.arguments <- commandArgs(trailingOnly = TRUE);
output.directory  <- command.arguments[1];
code.directory    <- command.arguments[2];

####################################################################################################
library(LearnBayes);
library(ggplot2);
library(scales);
#library(sn);

source(paste(code.directory, "utils-monte-carlo.R", sep = "/"));

setwd(output.directory);

### AUXILIAR FUNCTIONS #############################################################################
log.posterior.grouped.data <- function(model.parameters = NULL, prior.and.data = NULL) {
        
	observed.frequencies  <- prior.and.data[['observations']][,'frequency'];
	interval.lower.bounds <- prior.and.data[['observations']][,'interval.lower.bound'];
	interval.upper.bounds <- prior.and.data[['observations']][,'interval.upper.bound'];

	output.value <- NULL;
	if (is.null(dim(model.parameters))) {

		mu    <- model.parameters[1];
		sigma <- exp(model.parameters[2]);

		temp <- pnorm(q = interval.upper.bounds, mean = mu, sd = sigma);
		temp <- temp - pnorm(q = interval.lower.bounds, mean = mu, sd = sigma);
		temp <- observed.frequencies * log(temp);

		output.value <- sum(temp);

		} else {

		mu    <- model.parameters[,1];
		sigma <- exp(model.parameters[,2]);

		output.value <- numeric(nrow(model.parameters));
		for (i in 1:length(output.value)) {

			temp <- pnorm(
				q    = interval.upper.bounds,
				mean = mu[i],
				sd   = sigma[i]
				);

			temp <- temp - pnorm(
				q    = interval.lower.bounds,
				mean = mu[i],
				sd   = sigma[i]
				);

			temp <- observed.frequencies * log(temp);

			output.value[i] <- sum(temp);

			}
		}

        return(output.value);

        }

### SECTION 6.7 ####################################################################################
prior.and.data <- list(
	observations = as.matrix(data.frame(
		interval.lower.bound = c(-Inf,seq(66,74,2)),
		interval.upper.bound = c(seq(66,74,2),Inf),
		frequency            = c(14,30,49,70,33,15)
		))
	);

laplace.results <- laplace(logpost = log.posterior.grouped.data, mode = c(70,1), prior.and.data);
laplace.results;

proposal.parameters <- list(var = laplace.results[['var']], scale = 2);
fit2 <- rwmetrop(
	logpost  = log.posterior.grouped.data,
	proposal = proposal.parameters,
	start    = c(70,1),
	m        = 10000,
	prior.and.data
	);
str(fit2);

post.means <- apply(X = fit2[['par']], MARGIN = 2, FUN = mean);
post.sds   <- apply(X = fit2[['par']], MARGIN = 2, FUN = sd);
t(cbind(post.means, post.sds));

grid.parameters <- list(
	xlimits            = c(69,71),
	ylimits            = c(0.6,1.3),
	relative.grid.size = 1e-2
	);

mu.sigma.grid <- generate.grid(
	xlimits            = grid.parameters[['xlimits']],
	ylimits            = grid.parameters[['ylimits']],
	relative.grid.size = grid.parameters[['relative.grid.size']]
	);

DF.mu.sigma.contour <- as.data.frame(cbind(
	mu.sigma.grid,
	log.posterior = log.posterior.grouped.data(
		model.parameters = mu.sigma.grid,
		prior.and.data   = prior.and.data
		)
	));
colnames(DF.mu.sigma.contour) <- c('mu','log.sigma','log.posterior');

mu.sigma.bootstrap.sample <- generate.bootstrap.sample(
	sample.size = 1e+5,
	logf        = log.posterior.grouped.data,
	xlimits     = grid.parameters[['xlimits']],
	ylimits     = grid.parameters[['ylimits']],
	parameters = prior.and.data
	);
mu.sigma.bootstrap.sample <- as.data.frame(mu.sigma.bootstrap.sample);
colnames(mu.sigma.bootstrap.sample) <- c('mu','log.sigma');
str(mu.sigma.bootstrap.sample);

png("Fig6-01.png");
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_point(
	data = mu.sigma.bootstrap.sample,
	aes(x = mu, y = log.sigma),
	colour = alpha("red",0.01)
	);
my.ggplot <- my.ggplot + stat_contour(
	data = DF.mu.sigma.contour,
	aes(x = mu, y = log.sigma, z = log.posterior)
	);
my.ggplot;
dev.off();

