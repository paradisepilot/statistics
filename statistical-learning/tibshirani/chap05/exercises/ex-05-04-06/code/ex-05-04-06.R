
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
data(Default);

Default <- cbind(
	Default,
	default.numeric = as.numeric(Default[['default']]) - 1
	);

str(Default);
summary(Default);

Default[131:140,c('default','default.numeric')];

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
### (a) fitting a logistic regression model

FIT.logistic <- glm(
	formula = default.numeric ~ income + balance,
	data    = Default,
	family  = binomial
	);
summary(FIT.logistic);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
### (b) ###
set.seed(1234567);

boot.fn <- function(
	DF.input = NULL,
	indices  = NULL
	){
	FIT.temp <- glm(
		formula = default.numeric ~ income + balance,
		data    = DF.input[indices,],
		family  = binomial
		);
	return( coef(FIT.temp)[2:3] );
	}

results.boot.fn <- boot.fn(
	DF.input = Default,
	indices  = sample(x = seq(1,nrow(Default)), size = nrow(Default), replace = TRUE)
	);
results.boot.fn;

results.boot.fn <- boot.fn(
	DF.input = Default,
	indices  = sample(x = seq(1,nrow(Default)), size = nrow(Default), replace = TRUE)
	);
results.boot.fn;

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
### (c) ###
set.seed(1234567);

results.boot <- boot(data = Default, statistic = boot.fn, R = 1000);
results.boot;

my.results <- t(rbind(
	original = results.boot[['t0']],
	bias     = apply(X = results.boot[['t']], MARGIN = 2, FUN = mean) - results.boot[['t0']],
	stddev   = apply(X = results.boot[['t']], MARGIN = 2, FUN = sd)
	));
my.results;

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###

q();

