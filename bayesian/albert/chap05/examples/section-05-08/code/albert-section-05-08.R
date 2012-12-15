
command.arguments <- commandArgs(trailingOnly = TRUE);
output.directory  <- command.arguments[1];
code.directory    <- command.arguments[2];

####################################################################################################
library(LearnBayes);
library(ggplot2);
library(scales);

source(paste(code.directory,"add-contour.R",  sep = "/"));
source(paste(code.directory,"my-simcontour.R",sep = "/"));

setwd(output.directory);

### AUXILIAR FUNCTIONS #############################################################################
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

lBetaBinom.minus.lMultivarT <- function(parameters, data) {

	obns <- data[['observed.data']];
	tpar <- data[['t.parameters']];

	difference <- log.posterior.beta.binomial.tranformed(
		parameters = parameters,
		data = obns
		);
	difference <- difference - dmt(
		parameters,
		mean = c(tpar$m),
		S = tpar$var,
		df = tpar$df,
		log = TRUE
		);

	return(difference);

	}

### SECTION 5.6 ####################################################################################
fit <- laplace(log.posterior.beta.binomial.tranformed, c(-6,7), cancermortality);
fit;

tpar.list <- list(m = fit$mode, var = 2 * fit$var, df = 4);
data.list <- list(observed.data = cancermortality, t.parameters = tpar.list);
fit1      <- laplace(lBetaBinom.minus.lMultivarT, c(-6.9,12.4), data.list);
fit1;

d.max <- log.posterior.beta.binomial.tranformed(
	parameters = fit1[['mode']],
	data       = cancermortality
	);
d.max;

theta.sample <- rejectsampling(
	logf = log.posterior.beta.binomial.tranformed,
	tpar = tpar.list,
	dmax = d.max,
	n    = 1e+5,
	data = cancermortality
	);
colnames(theta.sample) <- c('logit.eta','log.K');
str(theta.sample);
summary(theta.sample);

png("Fig5-04_contour-logit-eta-vs-log-K.png");
ggplot.obj <- ggplot(data = NULL);
ggplot.obj <- ggplot.obj + geom_point(
	data = as.data.frame(theta.sample),
	aes(x = logit.eta, y = log.K),
	colour = alpha("red", 0.05)
	);
ggplot.obj <- add.contour(
	ggplot.obj = ggplot.obj,
        f          = log.posterior.beta.binomial.tranformed,
        limits     = c(-8,-5,2,16),
        data       = cancermortality,
        grid.size  = (1e-2)/2,
        bins       = 300
        );
ggplot.obj <- ggplot.obj + xlim(-8,-5) + ylim(2,16);
ggplot.obj;
dev.off();

