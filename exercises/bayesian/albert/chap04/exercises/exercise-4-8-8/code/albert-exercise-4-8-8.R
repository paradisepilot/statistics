
command.arguments <- commandArgs(trailingOnly = TRUE);
output.directory  <- command.arguments[1];

####################################################################################################
setwd(output.directory);
library(LearnBayes);
library(ggplot2);
library(scales);

### SET-UP #########################################################################################
sample.size <- 1e+6;
#sample.size <- 1e+5;

### AUXILIARY FUNCTIONS ############################################################################
my.logisticpost <- function (beta, data) {

	beta0 <- beta[1];
	beta1 <- beta[2];

	x <- data[,1];
	n <- data[,2];
	y <- data[,3];

	logf = function(x, n, y, beta0, beta1) {
		lp <- beta0 + beta1 * x;
		p  <- exp(lp) / (1 + exp(lp));

		log.p         <- log(p);
		log.1.minus.p <- log(1 - p);

		output.vector <- y * log.p + (n - y) * log.1.minus.p;
		output.vector[(log.p == -Inf) | (log.1.minus.p == -Inf)] <- -Inf;

		return(output.vector);
		}

	output.value <- sum(logf(x, n, y, beta0, beta1));

	if (!is.finite(output.value)) {
		lp <- beta0 + beta1 * x;
		p  <- exp(lp) / (1 + exp(lp));
		temp <- y * log(p) + (n - y) * log(1 - p);
		print("#####");
		print("beta");
		print( beta );
		print("cbind(data,lp,p)");
		print( cbind(data,lp,p,logp=log(p),log1minusp=log(1-p),post=temp) );
		print("output.value");
		print( output.value );
		}

	return(output.value);

	}

my.simcontour <- function(logf = NULL, limits = NULL, data = NULL, m = NULL) {

	grid.points <- data.frame(
		x = runif(n = m, min = limits[1], max = limits[2]),
		y = runif(n = m, min = limits[3], max = limits[4])
		); 

	log.posterior <- apply(
		X      = grid.points,
		MARGIN = 1,
		FUN    = function(v) {return(logf(beta = v, data = data));}
		);

	print("str(log.posterior)");
	print( str(log.posterior) );
	print("summary(log.posterior)");
	print( summary(log.posterior) );

	posterior <- exp(log.posterior);
	posterior <- posterior / sum(posterior);

	row.sample <- sample(size = m, x = 1:nrow(grid.points), prob = posterior, replace = TRUE);
	DF.temp <- grid.points[row.sample,];
	LIST.output <- list(x = DF.temp[,1], y = DF.temp[,2]);

	return(LIST.output);

	}

### 4.8.8 (a) ######################################################################################
x18.q25   <- list(p = 0.25, x = 0.15);
x18.q75   <- list(p = 0.75, x = 0.35);
x18.betas <- beta.select(quantile1 = x18.q25,quantile2 = x18.q75);

x26.q25   <- list(p = 0.25, x = 0.75);
x26.q75   <- list(p = 0.75, x = 0.95);
x26.betas <- beta.select(quantile1 = x26.q25,quantile2 = x26.q75);

x18.betas;
x26.betas;

png("Fig01_priors.png");
ACT.scores <- c('18','26');
p <- seq(0,1,0.001);
DF.x18 <- data.frame(
	probability = p,
	density     = dbeta(x = p, shape1 = x18.betas[1], shape2 = x18.betas[2]),
	ACT.score   = factor(rep('18',length(p)),levels=ACT.scores)
	);
DF.x26 <- data.frame(
	probability = p,
	density   = dbeta(x = p, shape1 = x26.betas[1], shape2 = x26.betas[2]),
	ACT.score = factor(rep('26',length(p)),levels=ACT.scores)
	);
DF.temp <- rbind(DF.x18,DF.x26);
print("summary(DF.temp)");
print( summary(DF.temp) );
qplot(data = DF.temp, x = probability, y = density, colour = ACT.score, geom = "line");
dev.off();

### 4.8.8 (b,c) ####################################################################################
my.obs <- cbind(
	x = c( 16, 18, 20, 22, 24, 26, 28),
	n = c(  2,  7, 14, 26, 13, 14,  3),
	y = c(  0,  0,  6, 12,  7,  9,  3)
	);

my.prior <- cbind(
	x = c(18,26),
	n = c(sum(x18.betas),sum(x26.betas)),
	y = c(x18.betas[1],x26.betas[1])
	);

my.data <- rbind(my.obs,my.prior);
my.data;

#my.limits <- 5 * c(-1,1,-1,1);
#my.limits <- c(-10,3,-1,1);
#my.limits <- c(-20,3,-1,1);
#my.limits <- c(-20,3,-1.3,1.3);
my.limits <- c(-20,3,-1,1);

###  The above is the answer to 4.8.8(b).
###  The preceding commented-out attempts of my.limits shows how the final
###  region was progressively obtained (after examining the scatter plot in Fig02, below,
###  at each iteration).

### The following call to my.simcontour is the answer to 4.8.8(c).
posterior.sample <- my.simcontour(
	logf   = my.logisticpost,
	limits = my.limits,
	data   = my.data,
	m      = sample.size
	);
posterior.sample <- as.data.frame(posterior.sample);
colnames(posterior.sample) <- c('beta0','beta1');
str(posterior.sample);
summary(posterior.sample);

png("Fig02_joint-postetrior-beta0-beta1.png");
DF.temp <- data.frame(
	beta0 = posterior.sample[,'beta0'],
	beta1 = posterior.sample[,'beta1']
	);
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_point(
	data = DF.temp,
	aes(x = beta0, y = beta1),
	colour = alpha("darkolivegreen",0.2)
	);
my.ggplot;
dev.off();

### 4.8.8 (d) ######################################################################################
covariate.posterior.sample <- posterior.sample[,'beta0'] + 20 * posterior.sample[,'beta1'];
p.posterior.sample <- exp(covariate.posterior.sample) / (1 + exp(covariate.posterior.sample));

summary(p.posterior.sample);

quantile(x = p.posterior.sample, probs = c(0.05,0.95));

png("Fig03_ACT20-success-probability-density.png");
qplot(x = p.posterior.sample, geom = "density");
dev.off();

