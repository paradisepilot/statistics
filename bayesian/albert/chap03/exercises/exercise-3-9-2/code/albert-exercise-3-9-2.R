
command.arguments <- commandArgs(trailingOnly = TRUE);
output.directory  <- command.arguments[1];

####################################################################################################
setwd(output.directory);
library(LearnBayes);
library(ggplot2);

####################################################################################################
### 3.9.2(a)
#
#  Since theta = 1 / lambda, we have:
#
#  g(lamda|data) =~ (lambda)^(-n-1)   * exp(-s / lambda)
#                =  (theta) ^ (n+1)   * exp(-s * theta)
#                =  (theta) ^ (n+2-1) * exp(-s * theta)
#
#  Thus, theta ~ Gamma(shape = n+2, rate = s).
#

### 3.9.2(b)
y.obs <- c(751, 594, 1213, 1126, 819);
n <- length(y.obs);
s <- sum(y.obs);

sample.size <- 1e+5;
theta <- rgamma(n = sample.size, shape = n+2, rate = s);

### 3.9.2(c)
lambda <- 1/theta;

### 3.9.2(d)
### The posterior estimate of P(lambda > 1000 | data) is given by:
sum(lambda > 1000) / length(lambda);

