
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
	formula = default ~ income + balance,
	data    = Default,
	family  = binomial
	);
summary(FIT.logistic);

FIT.logistic <- glm(
	formula = default.numeric ~ income + balance,
	data    = Default,
	family  = binomial
	);
summary(FIT.logistic);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
### (b), (c) ###
#set.seed(1234567);
set.seed(7654321);

ex.05.04.05.b <- function(
	DF.input = NULL
	){
	is.training   <- sample(x = c(TRUE,FALSE), size = nrow(DF.input), replace = TRUE);
	DF.training   <- DF.input[ is.training,];
	DF.validation <- DF.input[!is.training,];
	FIT.training <- glm(
		formula = default.numeric ~ income + balance,
		data    = DF.training,
		family  = binomial
		);
	posterior.probabilities <- predict(
		object  = FIT.training,
		newdata = DF.validation[,c('income','balance')],
		type    = "response"
		);
	DF.validation <- cbind(
		DF.validation,
		prediction = ceiling(posterior.probabilities - 0.5)
		);
	#print("str(DF.validation)");
	#print( str(DF.validation) );
	is.correct <- (DF.validation[["default.numeric"]] == DF.validation[["prediction"]]);
	error.rate <- 1 - sum(is.correct)/nrow(DF.validation);
	return(error.rate);
	}

error.rate <- ex.05.04.05.b(DF.input = Default); error.rate;
error.rate <- ex.05.04.05.b(DF.input = Default); error.rate;
error.rate <- ex.05.04.05.b(DF.input = Default); error.rate;

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
### (d) ###

ex.05.04.05.d <- function(
	DF.input = NULL
	){
	is.training   <- sample(x = c(TRUE,FALSE), size = nrow(DF.input), replace = TRUE);
	DF.training   <- DF.input[ is.training,];
	DF.validation <- DF.input[!is.training,];
	FIT.training <- glm(
		formula = default.numeric ~ income + balance + student,
		data    = DF.training,
		family  = binomial
		);
	posterior.probabilities <- predict(
		object  = FIT.training,
		newdata = DF.validation[,c('income','balance','student')],
		type    = "response"
		);
	DF.validation <- cbind(
		DF.validation,
		prediction = ceiling(posterior.probabilities - 0.5)
		);
	#print("str(DF.validation)");
	#print( str(DF.validation) );
	is.correct <- (DF.validation[["default.numeric"]] == DF.validation[["prediction"]]);
	error.rate <- 1 - sum(is.correct)/nrow(DF.validation);
	return(error.rate);
	}

error.rate <- ex.05.04.05.d(DF.input = Default); error.rate;
error.rate <- ex.05.04.05.d(DF.input = Default); error.rate;
error.rate <- ex.05.04.05.d(DF.input = Default); error.rate;

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
### (d) ###

ex.05.04.05.d <- function(
	DF.input = NULL
	){
	is.training   <- sample(x = c(TRUE,FALSE), size = nrow(DF.input), replace = TRUE);
	DF.training   <- DF.input[ is.training,];
	DF.validation <- DF.input[!is.training,];
	FIT.training <- glm(
		formula = default.numeric ~ income + balance + student,
		data    = DF.training,
		family  = binomial
		);
	posterior.probabilities <- predict(
		object  = FIT.training,
		newdata = DF.validation[,c('income','balance','student')],
		type    = "response"
		);
	DF.validation <- cbind(
		DF.validation,
		prediction = ceiling(posterior.probabilities - 0.5)
		);
	#print("str(DF.validation)");
	#print( str(DF.validation) );
	is.correct <- (DF.validation[["default.numeric"]] == DF.validation[["prediction"]]);
	error.rate <- 1 - sum(is.correct)/nrow(DF.validation);
	return(error.rate);
	}

error.rate <- ex.05.04.05.d(DF.input = Default); error.rate;
error.rate <- ex.05.04.05.d(DF.input = Default); error.rate;
error.rate <- ex.05.04.05.d(DF.input = Default); error.rate;

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
### extra stuff ###

ex.05.04.05.e <- function(
	DF.input = NULL
	){
	is.training   <- sample(x = c(TRUE,FALSE), size = nrow(DF.input), replace = TRUE);
	DF.training   <- DF.input[ is.training,];
	DF.validation <- DF.input[!is.training,];
	FIT.training <- glm(
		formula = default.numeric ~ student,
		data    = DF.training,
		family  = binomial
		);
	posterior.probabilities <- predict(
		object  = FIT.training,
		newdata = DF.validation[,c('default','student')],
		type    = "response"
		);
	DF.validation <- cbind(
		DF.validation,
		prediction = ceiling(posterior.probabilities - 0.5)
		);
	#print("str(DF.validation)");
	#print( str(DF.validation) );
	is.correct <- (DF.validation[["default.numeric"]] == DF.validation[["prediction"]]);
	error.rate <- 1 - sum(is.correct)/nrow(DF.validation);
	return(error.rate);
	}

error.rate <- ex.05.04.05.e(DF.input = Default); error.rate;
error.rate <- ex.05.04.05.e(DF.input = Default); error.rate;
error.rate <- ex.05.04.05.e(DF.input = Default); error.rate;

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###

q();

