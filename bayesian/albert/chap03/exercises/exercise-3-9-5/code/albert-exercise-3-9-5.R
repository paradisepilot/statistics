
command.arguments <- commandArgs(trailingOnly = TRUE);
output.directory  <- command.arguments[1];

####################################################################################################
setwd(output.directory);
library(LearnBayes);
library(ggplot2);

####################################################################################################
### 3.9.5(a)
n.trials    <- 20;
n.successes <- 8;

p0 <- 0.2;
pbinom(q = n.successes - 1, size = n.trials, prob = p0, lower.tail = FALSE);

### 3.9.5(b)
pbetat(p0 = p0, prob = 0.5, ab = c(1,4), data = c(n.trials,n.trials-n.successes));

### 3.9.5(c)
pbetat(p0 = p0, prob = 0.5, ab = c(0.5, 2), data = c(n.trials,n.trials-n.successes));
pbetat(p0 = p0, prob = 0.5, ab = c(2,   8), data = c(n.trials,n.trials-n.successes));
pbetat(p0 = p0, prob = 0.5, ab = c(8,  32), data = c(n.trials,n.trials-n.successes));

### 3.9.5(d)
#
#  Maybe ... :P
#

