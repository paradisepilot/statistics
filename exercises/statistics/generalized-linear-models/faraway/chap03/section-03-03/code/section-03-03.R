
command.arguments <- commandArgs(trailingOnly = TRUE);
data.directory    <- command.arguments[1];
code.directory    <- command.arguments[2];
output.directory  <- command.arguments[3];
tmp.directory     <- command.arguments[4];

####################################################################################################
library(faraway);
library(MASS);
library(ggplot2);

#source(paste(code.directory, "bugs-chains.R", sep = "/"));
#source(paste(code.directory, "which-bugs.R",  sep = "/"));

resolution <- 100;

setwd(output.directory);

####################################################################################################
data(solder);

str(solder);
summary(solder);
head(solder);

####################################################################################################
results.poisson <- glm(
	formula = skips ~ .,
	data    = solder,
	family  = poisson
	);
summary(results.poisson);

####################################################################################################
results.negative.binomial <- glm(
	formula = skips ~ .,
	data    = solder,
	family  = negative.binomial(1) 
	);
summary(results.negative.binomial);

####################################################################################################
results.MASS.nb <- MASS::glm.nb(formula = skips ~ ., data = solder);
summary(results.MASS.nb);

####################################################################################################

q();

