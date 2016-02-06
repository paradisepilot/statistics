
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

#source(paste(code.directory, "bugs-chains.R", sep = "/"));
#source(paste(code.directory, "which-bugs.R",  sep = "/"));

resolution <- 300;

###################################################
my.function <- function(
	degree         = NULL,
	DF.input       = NULL,
	formula.string = NULL
	) {
	FIT.glm <- glm(
		formula = as.formula(formula.string),
		data    = DF.input
		);
	cv.err = cv.glm(data = DF.input, glmfit = FIT.glm, K = 10);
	return(cv.err[['delta']][1]);
	}

###################################################
data(Auto);
str(Auto);
summary(Auto);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
set.seed(17);
sapply(
	X = seq(1,10,1),
	FUN = function(x) {
		return(
			my.function(degree = x, DF.input = Auto, formula.string = "mpg ~ poly(horsepower,degree)")
			)
		}
	);

###################################################

q();

