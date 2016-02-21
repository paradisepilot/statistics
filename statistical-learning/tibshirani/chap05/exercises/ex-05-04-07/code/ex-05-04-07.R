
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
data(Weekly);

colnames(Weekly) <- gsub(
	x           = colnames(Weekly),
	pattern     = "Direction",
	replacement = "Direction.original"
	);

Weekly <- cbind(
	Weekly,
	Direction = as.numeric(Weekly[["Direction.original"]]) - 1
	);

str(Weekly);
summary(Weekly);

Weekly[1:10,c('Direction','Direction.original')];

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
### (a) fitting a logistic regression model

FIT.logistic <- glm(
	formula = Direction ~ Lag1 + Lag2,
	data    = Weekly,
	family  = binomial
	);
summary(FIT.logistic);

DF.temp <- cbind(
	Weekly,
	prediction = ceiling(
		 -0.5 + predict(object = FIT.logistic, newdata = Weekly, type = "response")
		)
	);

temp0 <- sum(DF.temp[['prediction']] != DF.temp[['Direction']]) / nrow(DF.temp);
temp0;

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
### (b) ###

FIT.logistic <- glm(
	formula = Direction ~ Lag1 + Lag2,
	data    = Weekly[2:nrow(Weekly),],
	family  = binomial
	);
summary(FIT.logistic);

FIT.logistic <- glm(
	formula = Direction ~ Lag1 + Lag2,
	data    = Weekly[-1,],
	family  = binomial
	);
summary(FIT.logistic);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
### (c) ###

predict(object = FIT.logistic, newdata = Weekly[1,], type = "response");

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
### (d) ###

loocv <- function(
	DF.input        = NULL,
	leave.out.index = NULL
	) {
	FIT.temp <- glm(
		formula = Direction ~ Lag1 + Lag2,
		data    = DF.input[-leave.out.index,],
		family  = binomial
		);
	predicted.probability <- as.numeric(predict(
		object  = FIT.temp,
		newdata = DF.input[leave.out.index,],
		type    = "response"
		));
	prediction <- ceiling( predicted.probability - 0.5 );
	return(prediction);
	}

Weekly <- cbind(
	Weekly,
	prediction = sapply(
		X   = 1:nrow(Weekly),
		FUN = function(i){ return( loocv(DF.input = Weekly, leave.out.index = i) ); }
		)
	);

#Weekly[,c('Direction','prediction')];

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
### (e) ###

temp1 <- sum(Weekly[['prediction']] != Weekly[['Direction']]) / nrow(Weekly);
temp1;

abs(temp0 - temp1) / temp0;

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###

q();

