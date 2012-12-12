
command.arguments <- commandArgs(trailingOnly = TRUE);
output.directory  <- command.arguments[1];

####################################################################################################
setwd(output.directory);
library(LearnBayes);
library(ggplot2);

####################################################################################################
### 3.9.8(a)
num.of.points <- 1e+4;
lambda <- 2500 * seq(1,num.of.points,1) / num.of.points;
cmpnt1 <-  pexp(q = 100, rate = 1/lambda)^3;
cmpnt2 <-  dexp(x = 100, rate = 1/lambda);
cmpnt3 <- (pexp(q = 300, rate = 1/lambda) - pexp(q = 100, rate = 1/lambda))^3;
cmpnt4 <-  dexp(x = 300, rate = 1/lambda);
cmpnt5 <-  pexp(q = 300, rate = 1/lambda, lower.tail = FALSE)^4;

prior      <- 1;
likelihood <- cmpnt1 * cmpnt2 * cmpnt3 * cmpnt4 * cmpnt5;
posterior  <- prior * likelihood;
posterior  <- posterior / sum(posterior);

png("Fig1_posterior.png");
qplot(
	data = data.frame(lambda = lambda, posterior = posterior),
	x    = lambda,
	y    = posterior,
	geom = "line"
	);
dev.off();

### 3.9.8(b)
posterior.mean <- sum(posterior * lambda);
posterior.var  <- sum(posterior * (lambda - posterior.mean)^2);
posterior.sd   <- sqrt(posterior.var);

posterior.mean;
posterior.var;
posterior.sd;

### 3.9.8(c)
sum(posterior[300 < lambda & lambda < 500]);

