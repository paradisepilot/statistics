
command.arguments <- commandArgs(trailingOnly = TRUE);
output.directory  <- command.arguments[1];

####################################################################################################
setwd(output.directory);
library(LearnBayes);
library(ggplot2);
library(scales);

### 4.8.1(a) #######################################################################################
#
#  If the chosen prior density is g(mu,sigma^2) =~ 1/sigma^2, then the joint posterior distribution
#  g(mu,sigma^2|y) is given on p.63 of the text.
#
#  However, the important observations to make, as explained at the top of p.64, is that:
#    (a)  the conditional posterior distribution of mu, given sigma^2, is N(y.bar,sigma^2/n), and
#    (b)  the marginal posterior distribution of sigma^2 is an inverse chi-square distribution.
#
#  The implication is that we can numerically sample (mu,sigma^2) from the joint posterior
#  distribution by first sampling sigma^2 from inv-chi-square, followed by sampling mu from
#  N(y.bar,sigma^2/n).
#

y.obs <- c(
	9.0, 8.5, 7.0, 8.5, 6.0, 12.5, 6.0, 9.0, 8.5, 7.5,
	8.0, 6.0, 9.0, 8.0, 7.0, 10.0, 9.0, 7.5, 5.0, 6.5
	);

n     <- length(y.obs);
y.bar <- mean(y.obs);
S     <- sum((y.obs - y.bar)^2);

sample.size   <- 1e+5;
sigma2.sample <- S / rchisq(n = sample.size, df = n - 1);
mu.sample     <- rnorm(n = sample.size, mean = y.bar, sd = sqrt(sigma2.sample)/sqrt(n));

png("Fig1_posterior-sample-var-vs-mean.png");
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_point(
	data = data.frame(mean = mu.sample, var = sigma2.sample),
	aes(x = mean, y = var),
	colour = alpha("darkolivegreen", 0.15)
	);
my.ggplot;
dev.off();

### 4.8.1(b) #######################################################################################
quantile(x = mu.sample,     probs = c(0.05,0.95));

quantile(x = sqrt(sigma2.sample), probs = c(0.05,0.95));

### 4.8.1(c) #######################################################################################
temp <- qnorm(p = 0.75, mean = 0, sd = 1);
temp;

p75.sample <- mu.sample + temp * sqrt(sigma2.sample);
mean(p75.sample);
sd(p75.sample);

