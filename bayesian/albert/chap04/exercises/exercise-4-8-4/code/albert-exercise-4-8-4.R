
command.arguments <- commandArgs(trailingOnly = TRUE);
output.directory  <- command.arguments[1];

####################################################################################################
setwd(output.directory);
library(LearnBayes);
library(ggplot2);
library(scales);

### 4.8.4(a) #######################################################################################
y.obs <- c(10, 11, 12, 11, 9);

n     <- length(y.obs);
y.bar <- mean(y.obs);
S     <- sum((y.obs - y.bar)^2);

sample.size   <- 1e+5;
sigma2.sample <- S / rchisq(n = sample.size, df = n - 1);
mu.sample     <- rnorm(n = sample.size, mean = y.bar, sd = sqrt(sigma2.sample)/sqrt(n));

png("Fig1_as-exact_mean-sd-postetrior-sample.png");
DF.temp <- data.frame(mu = mu.sample, sd = sqrt(sigma2.sample));
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_point(data = DF.temp, aes(x = mu, y = sd), colour = alpha("darkolivegreen",0.2));
my.ggplot;
dev.off();

### 4.8.4(b) #######################################################################################
#
#     g(\mu, \sigma^{2} | rounded data \{y_{i}\})  
#  =~ g(\mu, \sigma^{2}) * f(rounded data \{y_{i}\} | \mu, \sigma^{2})
#  =  \dfrac{1}{\sigma^{2}} * \prod_{i=1}^{n} P(y_{i} - 1/2 < Y < y_{i} + 1/2 | Y ~ N(\mu,sigma^{2}))
#

### 4.8.4(c) #######################################################################################
count <- 0;
log.posterior.rounded <- function(theta = NULL, observed.data = NULL) {
	mu    <- theta[1];
	sigma <- theta[2];
	y     <- observed.data;

	prior      <- 1 / (sigma^2);
	likelihood <- prod(pnorm(q=y+1/2,mean=mu,sd=sigma)-pnorm(q=y-1/2,mean=mu,sd=sigma));
	posterior  <- prior * likelihood;

	#print("##########");
	#count <- 1 + count;
	#print("count");
	#print( count );
	#print("mu");
	#print( mu );
	#print("sigma");
	#print( sigma );
	#print("observed.data");
	#print( observed.data );
	#print("posterior")
	#print( posterior )
	#print("log(posterior)")
	#print( log(posterior) )

	return(log(posterior));
	}

mu.sd.correct.posterior.sample <- simcontour(
	logf   = log.posterior.rounded,
	limits = c(-5,25,0.001,30), ## Note: A zero lower for sigma causes an error in simcontour.
	data   = y.obs,
	m      = sample.size
	);
str(mu.sd.correct.posterior.sample);

png("Fig2_as-rounded_mean-sd-postetrior-sample.png");
DF.temp <- data.frame(
	mu = mu.sd.correct.posterior.sample[['x']],
	sd = mu.sd.correct.posterior.sample[['y']]
	);
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_point(data = DF.temp, aes(x = mu, y = sd), colour = alpha("red",0.2));
my.ggplot;
dev.off();

### 4.8.4(d) #######################################################################################
png("Fig3_mean.png");
DF.as.exact <- data.frame(
	mean = mu.sample,
	type = factor(x=rep('as exact',length(mu.sample)),levels=c('as exact','as rounded'))
	);
DF.as.rounded <- data.frame(
	mean = mu.sd.correct.posterior.sample[['x']],
	type = factor(
		x      = rep('as rounded',length(mu.sd.correct.posterior.sample[['x']])),
		levels = c('as exact','as rounded')
		)
	);
DF.temp <- rbind(DF.as.exact,DF.as.rounded);
qplot(data = DF.temp, x = mean, colour = type, geom = "density");
dev.off();

png("Fig4_sd.png");
DF.as.exact <- data.frame(
	sd   = sqrt(sigma2.sample),
	type = factor(x=rep('as exact',length(mu.sample)),levels=c('as exact','as rounded'))
	);
DF.as.rounded <- data.frame(
	sd   = mu.sd.correct.posterior.sample[['y']],
	type = factor(
		x      = rep('as rounded',length(mu.sd.correct.posterior.sample[['y']])),
		levels = c('as exact','as rounded')
		)
	);
DF.temp <- rbind(DF.as.exact,DF.as.rounded);
qplot(data = DF.temp, x = sd, colour = type, geom = "density");
dev.off();

