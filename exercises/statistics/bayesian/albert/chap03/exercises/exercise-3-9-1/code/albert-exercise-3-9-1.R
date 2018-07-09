
command.arguments <- commandArgs(trailingOnly = TRUE);
output.directory  <- command.arguments[1];

####################################################################################################
setwd(output.directory);
library(LearnBayes);
library(ggplot2);

####################################################################################################
y.obs <- c(0, 10, 9, 8, 11, 3, 3, 8, 8, 11);

### 3.9.1(a)
theta <- seq(-2,18,0.001);

### 3.9.1(b)
posterior.density <- sapply(
	X   = theta,
	FUN = function(t) { return(1/prod(1+(y.obs-t)^2)); }
	);
posterior.density <- posterior.density / sum(posterior.density);

### 3.9.1(c)
png("Fig1_Cauchy-posterior.png");
DF.temp <- data.frame(
	theta             = theta,
	posterior.density = posterior.density
	);
qplot(data = DF.temp, x = theta, y = posterior.density, geom = "line");
dev.off();

### 3.9.1(d)
posterior.mean <- sum(posterior.density * theta);
posterior.var  <- sum(posterior.density * (theta - posterior.mean)^2);
posterior.sd   <- sqrt(posterior.var);

posterior.mean;
posterior.var;
posterior.sd;

