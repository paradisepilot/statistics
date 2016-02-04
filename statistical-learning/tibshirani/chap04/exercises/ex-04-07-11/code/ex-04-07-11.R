
command.arguments <- commandArgs(trailingOnly = TRUE);
data.directory    <- command.arguments[1];
code.directory    <- command.arguments[2];
output.directory  <- command.arguments[3];
tmp.directory     <- command.arguments[4];

###################################################
library(ISLR);
library(MASS);
library(class);
library(ggplot2);

source(paste(code.directory, "ex-04-07-11-b.R", sep = "/"));
source(paste(code.directory, "ex-04-07-11-c.R", sep = "/"));
source(paste(code.directory, "getDFauto.R",     sep = "/"));

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
get.performance.metrics <- function(x = NULL) {
	output.list <- list(
		accuracy            = (x[1,1]+x[2,2]) / (x[1,1]+x[1,2]+x[2,1]+x[2,2]),
		sensitivity         = x[2,2] / (x[2,1]+x[2,2]),
		specificity         = x[1,1] / (x[1,1]+x[1,2]),
		false.negative.rate = x[2,1] / (x[1,1]+x[2,1]),
		false.positive.rate = x[1,2] / (x[1,2]+x[2,2])
		);
	return(output.list);
	}

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
setwd(output.directory);

resolution <- 100;

###################################################

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
### (a) ###
data(Auto);
DF.auto <- get.DFauto();
str(Auto);
summary(Auto);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
### (b) ###
ex.04.07.11.b(DF.auto = DF.auto);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
### (c) ###
is.training <- sample(x = c(TRUE,FALSE), size=nrow(DF.auto), replace=TRUE);

ex.04.07.11.c(
	DF.training = DF.auto[ is.training,],
	DF.testing  = DF.auto[!is.training,]
	);

###################################################

q();

