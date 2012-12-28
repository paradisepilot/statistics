
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
        
	#z0 <- 0.53;

	e <- prior.and.data[['data']][,'e'];
	y <- prior.and.data[['data']][,'y'];

	output.value <- NULL;
	if (is.null(dim(model.parameters))) {

		theta1 <- model.parameters[1];
		theta2 <- model.parameters[2];
		alpha  <- exp(theta1);
		beta   <- exp(theta2);

		temp <- alpha * theta2 + lgamma(alpha + y);
		temp <- temp - lgamma(alpha) - (alpha + y) * log(beta + e);
		temp <- sum(temp);

		#temp <- temp + log(z0) + theta1 - 2 * log(alpha + z0);
		temp <- temp + theta1 - 2 * log(alpha + 1);
		temp <- temp + theta2 - 2 * log(beta  + 1);

		output.value <- temp;

		} else {

		theta1 <- model.parameters[,1];
		theta2 <- model.parameters[,2];
		alpha  <- exp(theta1);
		beta   <- exp(theta2);

		FUN.temp <- function(i) {
			temp <- alpha[i] * theta2[i] + lgamma(alpha[i] + y);
			temp <- temp - lgamma(alpha[i]) - (alpha[i] + y) * log(beta[i] + e);
			temp <- sum(temp);

			#temp <- temp + log(z0) + theta1[i] - 2 * log(alpha[i] + z0);
			temp <- temp + theta1[i] - 2 * log(alpha[i] + 1);
			temp <- temp + theta2[i] - 2 * log(beta[i]  + 1);

			return(temp);
			}
		output.value <- sapply(X = 1:nrow(model.parameters), FUN = FUN.temp);

		}

	return(output.value);

        }

### Derivation of the above function:
#
#  First, we drive g(alpha,beta|y):
#
#       g(\alpha,\beta|y)
#
#    =  \int
#           \left[\prod_{i=1}^{94}f(y_{i}|\lambda_{i})g(\lambda_{i}|\alpha,\beta)\right]
#           g(\alpha,\beta)
#       d\lambda_{1} \cdots d\lambda_{94}
#
#    =  g(\alpha,\beta) \cdot
#       \int
#           \left[\prod_{i=1}^{94}f(y_{i}|\lambda_{i})g(\lambda_{i}|\alpha,\beta)\right]
#       d\lambda_{1} \cdots d\lambda_{94}
#
#    =  \dfrac{1}{(\alpha+1)^2} \dfrac{1}{(\beta+1)^2} \cdot \prod_{i=1}^{94} \cdot
#       \int \left[ f(y_{i}|\lambda_{i})g(\lambda_{i}|\alpha,\beta) \right] d\lambda_{i}
#
#    =  \dfrac{1}{(\alpha+1)^2} \dfrac{1}{(\beta+1)^2} \cdot \prod_{i=1}^{94} \cdot
#       \int \left[
#           \dfrac{1}{y_{i}!} (e_{i}\lambda_{i})^{y_{i}} \exp(-e_{i}\lambda_{i}) \cdot
#           \dfrac{\beta^{\alpha}\lambda^{\alpha-1}}{\Gamma(\alpha)} \exp(-\beta\lambda_{i})
#       \right] d\lambda_{i}
#
#    =  \dfrac{1}{(\alpha+1)^2} \dfrac{1}{(\beta+1)^2} \cdot
#       \left(\dfrac{\beta^{\alpha}}{\Gamma(\alpha)}\right)^{94} \cdot
#       \left(\prod_{i}^{94} \dfrac{e_{i}^{y_{i}}}{y_{i}!} \right) \cdot
#       \prod_{i=1}^{94}\int\lambda_{i}^{y_{i}+\alpha-1}\exp(-lambda_{i}(e_{i}+\beta))d\lambda_{i}
#
#    =  \dfrac{1}{(\alpha+1)^2} \dfrac{1}{(\beta+1)^2} \cdot
#       \left(\dfrac{\beta^{\alpha}}{\Gamma(\alpha)}\right)^{94} \cdot
#       \left(\prod_{i}^{94} \dfrac{e_{i}^{y_{i}}}{y_{i}!} \right) \cdot
#       \prod_{i=1}^{94} \dfrac{\Gamma(y_{i}+\alpha)}{(e_{i}+\beta)^{y_{i}+\alpha}}           (*)
#
#    where the last equation uses the fact that:
#
#    \int^{\infty}_{t=0} t^{s-1} \exp(-Kt) dt = \dfrac{\Gamma(s)}{K^s}
#
#  Next, recall that:
#
#      \int g(\alpha,\beta|y) d\alpha d\beta = 1
#    = \int g(F(\theta_{1},\theta_{2})|y) \cdot
#           \left|\dfrac{\partial(\alpha,\beta)}{\partial(\theta_{1},\theta_{2})}right|
#      d\theta_{1}d\theta_{2}
#
#  where (alpha,beta) = F(theta_{1},theta_{2}) = (exp(theta_{1},theta_{2})).
#
#  Hence,
#
#      \left|\dfrac{\partial(\alpha,\beta)}{\partial(\theta_{1},\theta_{2})}right|
#    = ... = \exp(\theta_{1})\exp(\theta_{2}) = \alpha\beta
#
#  Thus, the posterior density in terms of (theta_{1},theta_{2}), up to a proportionality
#  constant, is given by:
#
#    g(e^{\theta_{1}},e^{\theta_{2}}|y) \cdot \exp(\theta_{1} + \theta_{2})                   (**)
#
#  where g(\alpha,\beta|y) is given in (*).  The R function "log.posterior.pre.density" above
#  computes, up to a proportionality constant, the logarithm of (**).
#

####################################################################################################
str(hearttransplants);
summary(hearttransplants);
# hearttransplants;

### Exercise 7.13.1(a) #############################################################################
prior.and.data <- list(data = hearttransplants);

laplace.results <- laplace(
	logpost        = log.posterior.pre.density,
	mode           = c(2,9),
	prior.and.data = prior.and.data
	);
laplace.results;

### determining how big the plot rectangle should be:
diag(laplace.results[['var']]);
sqrt(diag(laplace.results[['var']]));

temp <- ceiling(10 * sqrt(diag(laplace.results[['var']])));
grid.xlimits <- 2 + temp[1] * c(-1,1);
grid.ylimits <- 9 + temp[2] * c(-1,1);

grid.parameters <- list(
	xlimits            = grid.xlimits,
	ylimits            = grid.ylimits,
	relative.grid.size = 2^(-6)
        );
grid.parameters;

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
colnames(DF.contour) <- c('log.alpha','log.beta','log.pre.density');
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
colnames(gibbs.sample) <- c('log.alpha','log.beta');
str(gibbs.sample);
summary(gibbs.sample);

png("Fig1_posterior-contour.png");
my.ggplot <- ggplot();
my.ggplot <- my.ggplot + geom_point(
	data    = gibbs.sample,
	mapping = aes(x = log.alpha, y = log.beta),
	colour  = alpha("#CC5500",0.01)
	);
my.ggplot <- my.ggplot + stat_contour(
	data     = DF.contour,
	mapping  = aes(x = log.alpha, y = log.beta, z = log.pre.density),
	binwidth = 250
	);
my.ggplot <- my.ggplot + xlim(grid.xlimits) + ylim(grid.ylimits);
my.ggplot;
dev.off();

### Exercise 7.13.1(b) #############################################################################
alphas <- exp(gibbs.sample[,'log.alpha']);
betas  <- exp(gibbs.sample[,'log.beta']);
FUN.temp <- function(i) {
	lambdas.i <- rgamma(
		n     = nrow(gibbs.sample),
		shape = hearttransplants[i,'y'] + alphas,
		rate  = hearttransplants[i,'e'] + betas
		);
	return( quantile(x = lambdas.i, probs = c(0.05,0.95)) );
	}
#sapply(X = 1:nrow(hearttransplants), FUN = FUN.temp);
credible.intervals <- matrix(nrow = nrow(hearttransplants), ncol = 2);
for (i in 1:nrow(hearttransplants)) {
	credible.intervals[i,] <- FUN.temp(i);
	}
str(credible.intervals);
summary(credible.intervals);
credible.intervals;

### Counterpart of Fig. 7.9, p.169 #################################################################
DF.temp <- as.data.frame(matrix(nrow = nrow(hearttransplants), ncol = 4 + ncol(hearttransplants)));
DF.temp[,1:ncol(hearttransplants)] <- hearttransplants;
colnames(DF.temp)    <- c(colnames(hearttransplants),'log.e','y.over.e','ci.min','ci.max');
DF.temp[,'log.e']    <- log(DF.temp[,'e']);
DF.temp[,'y.over.e'] <- DF.temp[,'y'] / DF.temp[,'e'];
summary(DF.temp);

alphas <- exp(gibbs.sample[,'log.alpha']);
betas  <- exp(gibbs.sample[,'log.beta']);
for (i in 1:nrow(DF.temp)) {
	lambdas <- rgamma(
		n     = length(alphas),
		shape = DF.temp[i,'y'] + alphas,
		rate  = DF.temp[i,'e'] + betas
		);
	DF.temp[i,c('ci.min','ci.max')] <- quantile(x = lambdas, probs = c(0.05,0.95));
	}
summary(DF.temp);

png("Fig2.png");
my.ggplot <- ggplot();
my.ggplot <- my.ggplot + geom_point(
	data    = DF.temp,
	mapping = aes(x = log.e, y = y.over.e)
	);
my.ggplot <- my.ggplot + geom_segment(
	data    = DF.temp,
	mapping = aes(x = log.e, xend = log.e, y = ci.min, yend = ci.max)
	);
my.ggplot <- my.ggplot + xlim(6,9.5);  # + ylim(0,0.004);
my.ggplot <- my.ggplot + xlab("log(e)") + ylab("mortality rates");
my.ggplot;
dev.off();

####################################################################################################

q();

