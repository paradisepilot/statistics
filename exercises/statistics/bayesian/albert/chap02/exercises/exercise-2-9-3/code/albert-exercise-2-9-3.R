
command.arguments <- commandArgs(trailingOnly = TRUE);
output.directory  <- command.arguments[1];

####################################################################################################
setwd(output.directory);
library(LearnBayes);
library(ggplot2);

### 2.9.3(a) #######################################################################################
png("Fig1_prior-density.png");
p <- seq(0,1,0.001);
qplot(
	data = data.frame(p = p, prior = dbeta(x = p, shape1 = 1, shape2 = 1)),
        x    = p,
        y    = prior,
        geom = c("line")
        );
dev.off();

qbeta(p = c(0.05,0.95), shape1 = 23, shape2 = 8);

### 2.9.3(b) #######################################################################################
pbeta(q = 0.6, shape1 = 23, shape2 = 8, lower.tail = FALSE);

### 2.9.3(c) #######################################################################################
sample.size <- 1e+6;
p.posterior.sample <- rbeta(n = sample.size, shape1 = 23, shape2 = 8);

png("Fig2_posterior-sample.png");
qplot(
        x    = p.posterior.sample,
        geom = c("histogram"),
	binwidth = 0.01
        );
dev.off();

### 2.9.3(d) #######################################################################################
n.trials <- 10;
y.predicted <- rbinom(n = length(p.posterior.sample), size = n.trials, prob = p.posterior.sample)
length(y.predicted);

DF.y.predicted <- as.data.frame(table(y.predicted));
print( DF.y.predicted );

png("Fig3_prediction.png");
qplot(
        x        = y.predicted,
        geom     = c("histogram"),
	binwidth = 0.5
        );
dev.off();

