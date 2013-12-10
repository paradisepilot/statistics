
command.arguments <- commandArgs(trailingOnly = TRUE);
data.directory   <- command.arguments[1];
output.directory <- command.arguments[2];
code.directory   <- command.arguments[3];
tmp.directory    <- command.arguments[4];

####################################################################################################
library(faraway);
library(ggplot2);

#source(paste(code.directory, "bugs-chains.R", sep = "/"));
#source(paste(code.directory, "which-bugs.R",  sep = "/"));

####################################################################################################
setwd(output.directory);

####################################################################################################
DF.data <- read.csv(
	file   = paste0(data.directory,'/appendices/data-table-B1.csv'),
	header = TRUE,
	sep    = "\t",
	quote  = "\""
	);
str(DF.data);

### (a) ############################################################################################
lm.results <- lm(
	formula = y ~ x8,
	data    = DF.data
	);
summary(lm.results);

### (b) ############################################################################################
SS.grand.mean <- sum((lm.results[['model']][,'y'] - mean(lm.results[['model']][,'y']))^2);
SS.grand.mean;

SS.full <- sum(residuals(lm.results)^2);
SS.full;

SS.grand.mean - SS.full;

MS.full <- SS.full / (nrow(lm.results[['model']])-2);
MS.full;

F.statistic <- (SS.grand.mean - SS.full) / MS.full;
F.statistic;

pf(q = F.statistic, df1 = 1, df2 = nrow(lm.results[['model']])-2, lower.tail = FALSE);

anova(lm.results);

### (c) ############################################################################################
X <- cbind(rep(1,nrow(DF.data)),DF.data[,'x8']);

beta.hat <- solve( t(X) %*% X ) %*% t(X) %*% DF.data[,'y'];
beta.hat;

beta.Sigma <- MS.full * solve( t(X) %*% X );
beta.Sigma;

beta.hat.sd <- sqrt(beta.Sigma[2,2]);
beta.hat.sd;

beta.hat[2] + qt(p = 0.975, df = nrow(DF.data)-2) * beta.hat.sd * c(-1,1);

### (d) ############################################################################################
(SS.grand.mean - SS.full) / SS.grand.mean;

### (e) ############################################################################################

####################################################################################################

q();

