
command.arguments <- commandArgs(trailingOnly = TRUE);
output.directory  <- command.arguments[1];

####################################################################################################
setwd(output.directory);
library(LearnBayes);
library(ggplot2);
library(scales);

### 4.8.5 ##########################################################################################
y.obs <- c(
	2,5,0,2,3,1,3,4,3,0,3,
	2,1,1,0,6,0,0,3,0,1,1,
	5,0,1,2,0,0,2,1,1,1,0
	);

log.posterior.Poisson.gamma <- function(theta = NULL, observed.data = NULL) {
	theta1 <- theta[1];
	theta2 <- theta[2];
	y      <- observed.data;

	n <- length(y);
	a <- exp(theta1);
	b <- exp(theta2);

	#posterior  <- (1/a/b) * prod(
	#	(gamma(y+a) * (b^a)) / gamma(a) / factorial(y) / ((b+1)^(y+a))
	#	);
	#log.posterior <- log(posterior);

	log.posterior <- - theta1 - theta2 + n * (a * theta2 - lgamma(a));
	log.posterior <- log.posterior + sum(lgamma(y+a) - (y+a)*log(b+1) - lfactorial(y));

	if (!is.finite(log.posterior)) {
		print("##########");
		print("theta");
		print( theta );
		print("observed.data");
		print( observed.data );
		print("cbind(gamma(y+a), factorial(y), ((b+1)^(y+a)))");
		print( cbind(gamma(y+a), factorial(y), ((b+1)^(y+a))) );
		print("log.posterior");
		print( log.posterior );
		}

	return(log.posterior);
	}

sample.size <- 1e+5;
posterior.sample <- simcontour(
	logf   = log.posterior.Poisson.gamma,
	limits = 5 * c(-1, 1,-1, 1),
	data   = y.obs,
	m      = sample.size
	);
str(posterior.sample);

png("Fig1_postetrior-sample.png");
DF.temp <- data.frame(
	a = exp(posterior.sample[['x']]),
	b = exp(posterior.sample[['y']])
	);
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_point(
	data = DF.temp,
	aes(x = a, y = b),
	colour = alpha("darkolivegreen",0.2)
	);
my.ggplot;
dev.off();

quantile(x = exp(posterior.sample[['x']]), c(0.05,0.95));
quantile(x = exp(posterior.sample[['y']]), c(0.05,0.95));

