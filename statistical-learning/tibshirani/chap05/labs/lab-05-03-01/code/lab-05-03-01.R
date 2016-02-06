
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

#source(paste(code.directory, "bugs-chains.R", sep = "/"));
#source(paste(code.directory, "which-bugs.R",  sep = "/"));

resolution <- 300;

###################################################
data(Auto);
str(Auto);
summary(Auto);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
set.seed(1);
indices.training <- sample(x = 1:nrow(Auto), size = 196);

DF.testing    <- Auto[ indices.training,];
DF.validation <- Auto[-indices.training,];

FIT.lm.1 <- lm(
	formula = mpg ~ horsepower,
	data    = DF.testing
	);

temp <- cbind(
	DF.validation,
	predicted = predict(object = FIT.lm.1, newdata = DF.validation)
	);
mean((temp[,'mpg'] - temp[,'predicted'])^2);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
FIT.lm.2 <- lm(
	formula = mpg ~ poly(horsepower,2),
	data    = DF.testing
	);

temp <- cbind(
	DF.validation,
	predicted = predict(object = FIT.lm.2, newdata = DF.validation)
	);
mean((temp[,'mpg'] - temp[,'predicted'])^2);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
FIT.lm.3 <- lm(
	formula = mpg ~ poly(horsepower,3),
	data    = DF.testing
	);

temp <- cbind(
	DF.validation,
	predicted = predict(object = FIT.lm.3, newdata = DF.validation)
	);
mean((temp[,'mpg'] - temp[,'predicted'])^2);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
set.seed(2);
indices.training <- sample(x = 1:nrow(Auto), size = 196);

DF.testing    <- Auto[ indices.training,];
DF.validation <- Auto[-indices.training,];

FIT.lm.1 <- lm(
	formula = mpg ~ horsepower,
	data    = Auto,
	subset  = indices.training
	);

DF.validation <- Auto[-indices.training,];
temp <- cbind(
	DF.validation,
	predicted = predict(object = FIT.lm.1, newdata = DF.validation)
	);
mean((temp[,'mpg'] - temp[,'predicted'])^2);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
FIT.lm.2 <- lm(
	formula = mpg ~ poly(horsepower,2),
	data    = DF.testing
	);

temp <- cbind(
	DF.validation,
	predicted = predict(object = FIT.lm.2, newdata = DF.validation)
	);
mean((temp[,'mpg'] - temp[,'predicted'])^2);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
FIT.lm.3 <- lm(
	formula = mpg ~ poly(horsepower,3),
	data    = DF.testing
	);

temp <- cbind(
	DF.validation,
	predicted = predict(object = FIT.lm.3, newdata = DF.validation)
	);
mean((temp[,'mpg'] - temp[,'predicted'])^2);

###################################################

q();

