
command.arguments <- commandArgs(trailingOnly = TRUE);
output.directory  <- command.arguments[1];

####################################################################################################
setwd(output.directory);
library(LearnBayes);
library(ggplot2);

####################################################################################################
### 3.9.3(a)
B     <- 200;
N     <- seq(1,B,1);
y.obs <- c(43,24,100,35,85);

n <- length(y.obs);
y.max <- max(y.obs);
N.posterior <- 1/(N^n);
N.posterior[N < y.max] <- 0;
N.posterior <- N.posterior / sum(N.posterior);
cbind(N,N.posterior);

### 3.9.3(b)
N.posterior.mean <- sum(N.posterior * N);
N.posterior.var  <- sum(N.posterior * (N - N.posterior.mean)^2);
N.posterior.sd   <- sqrt(N.posterior.var);

N.posterior.mean;
N.posterior.var;
N.posterior.sd;

### 3.9.3(c)
sum(N.posterior[N > 150]);

