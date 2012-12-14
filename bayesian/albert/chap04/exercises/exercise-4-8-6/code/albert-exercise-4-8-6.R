
command.arguments <- commandArgs(trailingOnly = TRUE);
output.directory  <- command.arguments[1];

####################################################################################################
setwd(output.directory);
library(LearnBayes);
library(ggplot2);
library(scales);

### 4.8.6 (a) ######################################################################################
#
#     g(\lamda_{1},\lambda_{2}|data)
#
#  =  g(\lambda_{1},\lambda_{2}) * f(data|\lambda_{1},\lambda_{2})
#
#  =~   (\lambda_{1}^{144-1}) * exp(-2.4\lambda_{1}) * (\lambda_{2}^{100-1}) * exp(-2.5\lambda_{2})
#     * exp(-4\lambda_{1})\lambda_{1}^{260} * exp(-4\lambda_{2})\lambda_{2}^{165}
#
#  =    \lambda_{1}^{144+260-1} * exp(-(2.4+4)\lambda_{1})
#     * \lambda_{2}^{100+165-1} * exp(-(2.5+4)\lambda_{2})
#
#  The above shows the joint posterior distribution for (\lambda_{1},\lambda_{2}), but it
#  also shows that the two parameters have independent posterior distributions, since it
#  is clear by inspection that the joint posterior distribution is simply the product of
#  the marginal posterior distributions of the two parameters (derivable for each parameter
#  by disregarding the other).
#

### 4.8.6 (b) ######################################################################################
log.joint.posterior <- function(theta = NULL, data = NULL) {

	lambda1 <- theta[1];
	lambda2 <- theta[2];

	t  <- data[['exposure']];

	a1 <- data[['prior']][[1]][['alpha']];
	b1 <- data[['prior']][[1]][['beta' ]];

	a2 <- data[['prior']][[2]][['alpha']];
	b2 <- data[['prior']][[2]][['beta' ]];

	y1 <- data[['observed']][1];
	y2 <- data[['observed']][2];

	log.posterior <- 0;
	log.posterior <- log.posterior + log(lambda1)*(a1+y1-1) - lambda1 *(b1+t);
	log.posterior <- log.posterior + log(lambda2)*(a2+y2-1) - lambda2 *(b2+t);
	log.posterior <- log.posterior - lfactorial(y1) - lfactorial(y2);
	log.posterior <- log.posterior + a1 * log(b1) - lgamma(a1);
	log.posterior <- log.posterior + a2 * log(b2) - lgamma(a2);

	if (0 < log.posterior) {
		print("log.posterior (log.joint.posterior)");
		print( log.posterior );
		}

	return(log.posterior);
	}

my.simcontour <- function(logf = NULL, limits = NULL, data = NULL, m = NULL) {

	################################################################
	################################################################
	#
	#  The following did NOT work at all.
	#  The grid (hence extremely NON-random) nature of the points
	#  chosen to compute the log joint posterior distribution
	#  led to very severe "jaggedness" in the resulting
	#  simulated sample.
	#
	#grid.size <- (1e-2)/2;
	#x.range   <- (limits[2]-limits[1]);
	#y.range   <- (limits[4]-limits[3]);
	#x.grid    <- limits[1] + x.range * seq(0,1,grid.size);
	#y.grid    <- limits[3] + y.range * seq(0,1,grid.size);
	#
	#grid.points <- expand.grid(x = x.grid, y = y.grid);
	#grid.points <- cbind(
	#	x = jitter(grid.points[,1], amount = x.range * grid.size),
	#	y = jitter(grid.points[,2], amount = y.range * grid.size)
	#	);
	#
	################################################################
	################################################################

	grid.points <- data.frame(
		x = runif(n = m, min = limits[1], max = limits[2]),
		y = runif(n = m, min = limits[3], max = limits[4])
		); 

	log.posterior <- apply(
		X      = grid.points,
		MARGIN = 1,
		FUN    = function(v) {return(logf(theta = v, data = data));}
		);

	posterior <- exp(log.posterior);
	posterior <- posterior / sum(posterior);

	#print("str(grid.points)");
	#print( str(grid.points) );
	#print("summary(grid.points)");
	#print( summary(grid.points) );
	#print("summary(log.posterior)");
	#print( summary(log.posterior) );
	#print("summary(posterior)");
	#print( summary(posterior) );

	row.sample <- sample(size = m, x = 1:nrow(grid.points), prob = posterior, replace = TRUE);
	DF.temp <- grid.points[row.sample,];
	LIST.output <- list(x = DF.temp[,1], y = DF.temp[,2]);

	return(LIST.output);

	}

my.data <- list(
	exposure = 4,
	prior    = list(list(alpha = 144, beta = 2.4), list(alpha = 100, beta = 2.5)),
	observed = c(260,165)
	);

#  The original limits were: limits = 1 + 199 * c(0,1,0,1).
#  The resulting (lambda1,lambda2) scatter plot revealed there were no points
#  in the sample (of size 1 million) that lay beyond the rectangle defined by
#  45 < x < 85 and 25 < y < 60.  Consequently, we restrict the area to this
#  rectangle, and the new sample is now sampling from a much more relevant
#  area.
my.limits <- c(45,85,25,60);

sample.size <- 1e+6;
#posterior.sample <- simcontour(
posterior.sample <- my.simcontour(
	logf   = log.joint.posterior,
	limits = my.limits,
	data   = my.data,
	m      = sample.size
	);
posterior.sample <- as.data.frame(posterior.sample);
colnames(posterior.sample) <- c('lambda1','lambda2');
str(posterior.sample);
summary(posterior.sample);

png("Fig1_joint-postetrior-sample.png");
DF.temp <- data.frame(
	lambda1 = posterior.sample[,'lambda1'],
	lambda2 = posterior.sample[,'lambda2']
	);
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_point(
	data = DF.temp,
	aes(x = lambda1, y = lambda2),
	colour = alpha("darkolivegreen",0.2)
	);
my.ggplot;
dev.off();

lambda1.posterior.sample <- rgamma(
	n     = sample.size,
	shape = my.data[['prior']][[1]][['alpha']] + my.data[['observed']][1] - 1,
	rate  = my.data[['prior']][[1]][['beta']]  + my.data[['exposure']]
	);

lambda2.posterior.sample <- rgamma(
	n     = sample.size,
	shape = my.data[['prior']][[2]][['alpha']] + my.data[['observed']][2] - 1,
	rate  = my.data[['prior']][[2]][['beta']]  + my.data[['exposure']]
	);

png("Fig2_posterior-densities.png");
my.levels <- c('lambda1, joint','lambda2, joint','lambda1','lambda2');
DF.joint.lambda1 <- data.frame(
	density = posterior.sample[,'lambda1'],
	type    = factor(rep('lambda1, joint',sample.size),levels=my.levels)
	);
DF.joint.lambda2 <- data.frame(
	density = posterior.sample[,'lambda2'],
	type    = factor(rep('lambda2, joint',sample.size),levels=my.levels)
	);
DF.lambda1 <- data.frame(
	density = lambda1.posterior.sample,
	type    = factor(rep('lambda1',sample.size),levels=my.levels)
	);
DF.lambda2 <- data.frame(
	density = lambda2.posterior.sample,
	type    = factor(rep('lambda2',sample.size),levels=my.levels)
	);
DF.temp <- rbind(DF.joint.lambda1,DF.joint.lambda2,DF.lambda1,DF.lambda2);
qplot(data = DF.temp, x = density, color = type, geom = "density");
dev.off();

### 4.8.6 (c) ######################################################################################
mean(lambda1.posterior.sample > 1.5 * lambda2.posterior.sample);

