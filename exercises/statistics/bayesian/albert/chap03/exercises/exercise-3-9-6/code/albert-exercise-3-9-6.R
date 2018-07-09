
command.arguments <- commandArgs(trailingOnly = TRUE);
output.directory  <- command.arguments[1];

####################################################################################################
setwd(output.directory);
library(LearnBayes);
library(ggplot2);

####################################################################################################
### 3.9.6(a)
mu0   <- 70;
sigma <- 10;
s     <-  1;
f     <- 17;

mu         <- seq(0, 2 * mu0, 1e-3);
prior      <- 1;
likelihood <- pnorm(q=mu0,mean=mu,sd=sigma)^s * pnorm(q=mu0,mean=mu,sd=sigma,lower.tail=FALSE)^f;
posterior  <- prior * likelihood;
posterior  <- posterior / sum(posterior);

png("Fig1_posterior.png");
qplot(data = data.frame(mu = mu, posterior = posterior), x = mu, y = posterior, geom = "line");
dev.off();

### 3.9.6(b)
mu.posterior.mean <- sum(posterior * mu);
mu.posterior.mean;

### 3.9.6(c)
sum(posterior[mu > 80]);

