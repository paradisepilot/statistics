
command.arguments <- commandArgs(trailingOnly = TRUE);
output.directory  <- command.arguments[1];
code.directory    <- command.arguments[2];

####################################################################################################
library(LearnBayes);
library(ggplot2);
library(scales);

source(paste(code.directory,"my-simcontour.R",sep = "/"));
source(paste(code.directory,"my-contour.R",   sep = "/"));

setwd(output.directory);

### AUXILIAR FUNCTIONS #############################################################################
log.posterior.beta.binomial <- function(parameters = NULL, data = NULL) {
	
	eta <- parameters[1];
	K   <- parameters[2];

	y <- data[,1];
	n <- data[,2];

	N <- length(y);

	output.value <- lbeta(K * eta + y, K * (1 - eta) + n - y) - lbeta(K * eta, K * (1 - eta));
	output.value <- sum(output.value);
	output.value <- output.value - 2 * log(1 + K) - log(eta) - log(1 - eta);

	return(output.value);

	}

log.posterior.beta.binomial.tranformed <- function(parameters = NULL, data = NULL) {
	
	eta <- exp(parameters[1]) / (1 + exp(parameters[1]));
	K   <- exp(parameters[2]);

	y <- data[,1];
	n <- data[,2];

	N <- length(y);

	output.value <- lbeta(K * eta + y, K * (1 - eta) + n - y) - lbeta(K * eta, K * (1 - eta));
	output.value <- sum(output.value);
	output.value <- output.value - 2 * log(1 + K) - log(eta) - log(1 - eta);

	return(output.value);

	}

my.lbinorm <- function (parameters, data) {

	x = parameters[1];
	y = parameters[2];

	m = data[['m']];
	v = data[['v']];

	zx = (x - m[1])/sqrt(v[1, 1]);
	zy = (y - m[2])/sqrt(v[2, 2]);
	r = v[1, 2]/sqrt(v[1, 1] * v[2, 2]);

	return(-0.5/(1 - r^2) * (zx^2 - 2 * r * zx * zy + zy^2));

	}

### SECTION 5.6 ####################################################################################
fit <- laplace(log.posterior.beta.binomial.tranformed, c(-6,7), cancermortality);
fit;

png("Fig5-03_contour-multivariate-normal-approximation-to-log-posterior.png");
ggplot.obj <- my.contour(
	f         = my.lbinorm,
	limits    = c(-8,-4.5,3,16.5),
	data      = list(m = fit$mode, v = fit$var),
	grid.size = (1e-2)/2,
	bins      = 50
	);
ggplot.obj;
dev.off();

### approximate confidence intervals for logit(eta) and log(K) respectively:
temp <- cbind(fit$mode,fit$mode) + qnorm(p = 0.95) * sqrt(diag(fit$var)) %*% t(c(-1,1));
row.names(temp) <- c('logit(eta)','log(K)');
temp;

