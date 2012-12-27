
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
        
	z0 <- prior.and.data[['hyperparameters']][['z0']];
	e  <- prior.and.data[['data']][,'e'];
	y  <- prior.and.data[['data']][,'y'];

	output.value <- NULL;
	if (is.null(dim(model.parameters))) {

		alpha <- exp(model.parameters[1]);
		mu    <- exp(model.parameters[2]);
		beta  <- alpha / mu;

		temp <- alpha * log(beta) + lgamma(alpha + y);
		temp <- temp - lgamma(alpha) - (alpha + y) * log(beta + e);
		temp <- sum(temp);

		output.value <- temp + log(alpha) - 2 * log(alpha + z0);

		} else {

		alpha <- exp(model.parameters[,1]);
		mu    <- exp(model.parameters[,2]);
		beta  <- alpha / mu;

		temp.function <- function(i) {
			temp <- alpha[i] * log(beta[i]) + lgamma(alpha[i] + y);
			temp <- temp - lgamma(alpha[i]) - (alpha[i] + y) * log(beta[i] + e);
			temp <- sum(temp);
			return( temp + log(alpha[i]) - 2 * log(alpha[i] + z0) );
			}
		output.value <- sapply(X = 1:nrow(model.parameters), FUN = temp.function);

		}

	return(output.value);

        }

####################################################################################################
str(hearttransplants);
summary(hearttransplants);
# hearttransplants;

### Fig. 7.7, p.167 ################################################################################
prior.and.data <- list(
	hyperparameters = list(z0 = 0.53),
	data            = hearttransplants
	);

laplace.results <- laplace(
	logpost        = log.posterior.pre.density,
	mode           = c(2,-7),
	prior.and.data = prior.and.data
	);
laplace.results;

### generate Fig. 7.7, p.167
grid.parameters <- list(
        xlimits            = c(0,8),
        ylimits            = c(-7.3,-6.6),
        relative.grid.size = 2^(-8)
        );

model.parameters.grid <- generate.grid(
        xlimits            = grid.parameters[['xlimits']],
        ylimits            = grid.parameters[['ylimits']],
        relative.grid.size = grid.parameters[['relative.grid.size']]
        );

DF.contour <- as.data.frame(cbind(
	model.parameters.grid,
	log.pre.density = log.posterior.pre.density(
		model.parameters = model.parameters.grid,
		prior.and.data   = prior.and.data
		)
	));
colnames(DF.contour) <- c('log.alpha','log.mu','log.pre.density');
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
colnames(gibbs.sample) <- c('log.alpha','log.mu');
str(gibbs.sample);
summary(gibbs.sample);

png("Fig7-07.png");
my.ggplot <- ggplot();
my.ggplot <- my.ggplot + geom_point(
	data    = gibbs.sample,
	mapping = aes(x = log.alpha, y = log.mu),
	colour  = alpha("#CC5500",0.01)
	);
my.ggplot <- my.ggplot + stat_contour(
	data     = DF.contour,
	mapping  = aes(x = log.alpha, y = log.mu, z = log.pre.density),
	binwidth = 1
	);
my.ggplot;
dev.off();

### Fig. 7.8, p.168 ################################################################################
png("Fig7-08.png");
qplot(x = gibbs.sample[,'log.alpha'], geom = "density", xlab = "log(alpha)", xlim = c(0,10));
dev.off();

### Fig. 7.9, p.169 ################################################################################
DF.temp <- as.data.frame(matrix(nrow = nrow(hearttransplants), ncol = 4 + ncol(hearttransplants)));
DF.temp[,1:ncol(hearttransplants)] <- hearttransplants;
colnames(DF.temp)    <- c(colnames(hearttransplants),'log.e','y.over.e','ci.min','ci.max');
DF.temp[,'log.e']    <- log(DF.temp[,'e']);
DF.temp[,'y.over.e'] <- DF.temp[,'y'] / DF.temp[,'e'];
summary(DF.temp);

alphas <- exp(gibbs.sample[,'log.alpha']);
betas  <- exp(gibbs.sample[,'log.alpha'] - gibbs.sample[,'log.mu']);
for (i in 1:nrow(DF.temp)) {
	lambdas <- rgamma(
		n     = length(alphas),
		shape = DF.temp[i,'y'] + alphas,
		rate  = DF.temp[i,'e'] + betas
		);
	DF.temp[i,c('ci.min','ci.max')] <- quantile(x = lambdas, probs = c(0.05,0.95));
	}
summary(DF.temp);

png("Fig7-09.png");
my.ggplot <- ggplot();
my.ggplot <- my.ggplot + geom_point(
	data    = DF.temp,
	mapping = aes(x = log.e, y = y.over.e)
	);
my.ggplot <- my.ggplot + geom_segment(
	data    = DF.temp,
	mapping = aes(x = log.e, xend = log.e, y = ci.min, yend = ci.max)
	);
my.ggplot <- my.ggplot + xlim(6,9.5) + ylim(0,0.004);
my.ggplot <- my.ggplot + xlab("log(e)") + ylab("mortality rates");
my.ggplot;
dev.off();

####################################################################################################

q();

