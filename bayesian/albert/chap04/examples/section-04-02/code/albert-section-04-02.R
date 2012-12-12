
command.arguments <- commandArgs(trailingOnly = TRUE);
output.directory  <- command.arguments[1];

####################################################################################################
setwd(output.directory);
library(LearnBayes);
library(ggplot2);
library(scales);

### SECTION 4.2 ####################################################################################

### Fig. 4.1, p.65
data(marathontimes);
str(marathontimes);
names(marathontimes);
ls();

grid.size    <- 1e-2;
gridpts.mean <- 220 + ( 330 - 220) * seq(0,1,grid.size);
gridpts.var  <- 500 + (9000 - 500) * seq(0,1,grid.size);

n    <- nrow(marathontimes);
y    <- marathontimes[,'time'];
ybar <- mean(y);
S    <- sum((y-ybar)^2);

f <- function(x) {
	mu     <- x[1];
	sigma2 <- x[2];
	return( exp(-(S+n*(mu-ybar)^2)/2/sigma2) / (sigma2^(1+n/2)) );
	}

f(x = c(220,500));

DF.temp <- expand.grid(x = gridpts.mean, y = gridpts.var);
colnames(DF.temp) <- c('mean','var');
DF.temp <- cbind(
	DF.temp,
	density = apply(X = as.matrix(DF.temp), MARGIN = 1, FUN = function(x) {return(f(x));})
	);
DF.temp[,'density'] <- DF.temp[,'density'] /sum(DF.temp[,'density']);
DF.temp[,'log.density'] <- log(DF.temp[,'density']);
str(DF.temp);
summary(DF.temp);

sigma2.sample <- S / rchisq(5000,n-1);
mu.sample     <- rnorm(length(sigma2.sample),mean=ybar,sd=sqrt(sigma2.sample)/sqrt(n));
DF.points <- data.frame(mean = mu.sample, var  = sigma2.sample);
str(DF.points);
summary(DF.points);

quantile(mu.sample,c(0.025,0.975));

quantile(sqrt(sigma2.sample),c(0.025,0.975));

png("Fig4-1_contour-posterior-density.png");
v <- ggplot(data = NULL);
v <- v + stat_contour(data = DF.temp,aes(x = mean, y = var, z = density));
v <- v + geom_point(data = DF.points, aes(x = mean, y = var), colour = alpha("red", 0.25));
v;
dev.off();

png("Fig4-1_contour-log-posterior-density.png");
v <- ggplot(data = NULL);
v <- v + stat_contour(data = DF.temp, aes(x = mean, y = var, z = log.density), binwidth = 1);
v <- v + geom_point(data = DF.points, aes(x = mean, y = var), colour = alpha("red", 0.25));
v;
dev.off();

