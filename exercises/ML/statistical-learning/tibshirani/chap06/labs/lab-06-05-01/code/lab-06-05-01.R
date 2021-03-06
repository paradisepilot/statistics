
command.arguments <- commandArgs(trailingOnly = TRUE);
data.directory    <- command.arguments[1];
code.directory    <- command.arguments[2];
output.directory  <- command.arguments[3];
tmp.directory     <- command.arguments[4];

setwd(output.directory);

###################################################
library(ISLR);
library(MASS);
library(boot);
library(class);
library(ggplot2);
library(leaps);

#source(paste(code.directory, "bugs-chains.R", sep = "/"));
#source(paste(code.directory, "which-bugs.R",  sep = "/"));

resolution <- 300;

###################################################
data(Hitters);
str(Hitters);
summary(Hitters);

str(na.omit(Hitters));

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
Hitters <- na.omit(Hitters);

results.regsubsets <- regsubsets(
	x     = Salary ~ .,
	data  = Hitters,
	nvmax = 19
	);

summary(results.regsubsets);

str(results.regsubsets);

q();

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
alpha.function(DF.input=Portfolio,indices=sample(x=1:100,size=100,replace=TRUE));

temp <- boot(data = Portfolio, statistic = alpha.function, R =  1000);
c(mean(temp[['t']] - temp[['t0']]), sd((temp[['t']])));

temp <- boot(data = Portfolio, statistic = alpha.function, R =  1000);
c(mean(temp[['t']] - temp[['t0']]), sd((temp[['t']])));

temp <- boot(data = Portfolio, statistic = alpha.function, R =  1000);
c(mean(temp[['t']] - temp[['t0']]), sd((temp[['t']])));

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
temp <- boot(data = Portfolio, statistic = alpha.function, R = 10000);
c(mean(temp[['t']] - temp[['t0']]), sd((temp[['t']])));

temp <- boot(data = Portfolio, statistic = alpha.function, R = 10000);
c(mean(temp[['t']] - temp[['t0']]), sd((temp[['t']])));

temp <- boot(data = Portfolio, statistic = alpha.function, R = 10000);
c(mean(temp[['t']] - temp[['t0']]), sd((temp[['t']])));

temp;

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
set.seed(1);

boot.function(DF.input = Auto, indices = sample(x = 1:nrow(Auto), size = nrow(Auto), replace = TRUE));
boot.function(DF.input = Auto, indices = sample(x = 1:nrow(Auto), size = nrow(Auto), replace = TRUE));

temp <- boot(data = Auto, statistic = boot.function, R = 1000);
c(mean(temp[['t']] - temp[['t0']]), sd((temp[['t']])));
temp;

summary(lm(formula = mpg ~ horsepower, data = Auto))[['coefficients']];

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
set.seed(1);

temp <- boot(data = Auto, statistic = boot2.function, R = 1000);
c(mean(temp[['t']] - temp[['t0']]), sd((temp[['t']])));
temp;

summary(lm(formula = mpg ~ horsepower + I(horsepower^2), data = Auto))[['coefficients']];

###################################################

q();

