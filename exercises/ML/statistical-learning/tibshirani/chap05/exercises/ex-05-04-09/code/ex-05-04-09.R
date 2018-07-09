
command.arguments <- commandArgs(trailingOnly = TRUE);
data.directory    <- command.arguments[1];
code.directory    <- command.arguments[2];
output.directory  <- command.arguments[3];
tmp.directory     <- command.arguments[4];

setwd(output.directory);

###################################################
library(ISLR);
library(MASS);
library(class);
library(ggplot2);
library(boot);

#source(paste(code.directory, "ex-04-07-11-b.R", sep = "/"));
#source(paste(code.directory, "ex-04-07-11-d.R", sep = "/"));
#source(paste(code.directory, "ex-04-07-11-e.R", sep = "/"));
#source(paste(code.directory, "ex-04-07-11-f.R", sep = "/"));
#source(paste(code.directory, "ex-04-07-11-g.R", sep = "/"));
#source(paste(code.directory, "getDFauto.R",     sep = "/"));

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###

resolution <- 100;

###################################################
data(Boston);

str(Boston);

summary(Boston);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
### (a) ###

mu.hat <- mean( Boston[['medv']] );
mu.hat;

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
### (b) ###

sd( Boston[['medv']] ) / sqrt( nrow(Boston) );

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
### (c) ###

set.seed(17);
sd(sapply(
	X   = 1:50000,
	FUN = function(x) {
		mean(Boston[sample(x=1:nrow(Boston),size=nrow(Boston),replace=TRUE),'medv'])
		}
	));

set.seed(1234567);
sd(sapply(
	X   = 1:50000,
	FUN = function(x) {
		mean(Boston[sample(x=1:nrow(Boston),size=nrow(Boston),replace=TRUE),'medv'])
		}
	));

set.seed(7654321);
sd.bootstrap <- sd(sapply(
	X   = 1:50000,
	FUN = function(x) {
		mean(Boston[sample(x=1:nrow(Boston),size=nrow(Boston),replace=TRUE),'medv'])
		}
	));
sd.bootstrap;

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
### (d) ###

CI.bootstrap <- mu.hat + qnorm(0.975) * sd.bootstrap * c(-1,1);
CI.bootstrap;

t.test(x = Boston[['medv']]);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
### (e) ###

median(Boston[['medv']]);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
### (f) ###

set.seed(17);
median.bootstrap.sample <- sapply(
	X   = 1:50000,
	FUN = function(x) {
		median(Boston[sample(x=1:nrow(Boston),size=nrow(Boston),replace=TRUE),'medv'])
		}
	);

median(Boston[['medv']]);
mean(median.bootstrap.sample);
sd(  median.bootstrap.sample);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
### (g) ###

quantile(x = Boston[['medv']], probs = c(0.1));

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
### (h) ###

set.seed(1234567);
tenthPercentile.bootstrap.sample <- sapply(
	X   = 1:50000,
	FUN = function(x) {
		quantile(
			x     = Boston[sample(x=1:nrow(Boston),size=nrow(Boston),replace=TRUE),'medv'],
			probs = c(0.1)
			)
		}
	);

quantile(x = Boston[['medv']], probs = c(0.1));
mean(tenthPercentile.bootstrap.sample);
sd(  tenthPercentile.bootstrap.sample);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###

q();

