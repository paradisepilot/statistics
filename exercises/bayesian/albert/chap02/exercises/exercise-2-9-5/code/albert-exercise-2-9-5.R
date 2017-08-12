
command.arguments <- commandArgs(trailingOnly = TRUE);
output.directory  <- command.arguments[1];

####################################################################################################
setwd(output.directory);
library(LearnBayes);
library(ggplot2);

### 2.9.5(a) #######################################################################################
mu    <- seq(20,70,10);
prior <- c(10,15,25,25,15,10)/100;

### 2.9.5(b) #######################################################################################
y    <- c(38.6, 42.4, 57.5, 40.5, 51.7, 67.1, 33.4, 60.9, 64.1, 40.1, 40.7, 6.4);
ybar <- mean(y);
ybar;

### 2.9.5(c) #######################################################################################
sigma <- 10;
n     <- length(y);

likelihood <- exp( - n * (mu - ybar)^2 / (2*sigma^2) );

### 2.9.5(d) #######################################################################################
posterior <- prior * likelihood;
posterior <- posterior / sum(posterior);

data.frame(mu = mu, prior = prior, likelihood = likelihood, posterior = posterior);

### 2.9.5(e) #######################################################################################
discint(
	dist = data.frame(mu = mu, posterior = posterior),
	prob = 0.8
	);

