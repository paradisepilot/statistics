
command.arguments <- commandArgs(trailingOnly = TRUE);
data.directory    <- command.arguments[1];
code.directory    <- command.arguments[2];
output.directory  <- command.arguments[3];
tmp.directory     <- command.arguments[4];

####################################################################################################
library(faraway);
library(ggplot2);

#source(paste(code.directory, "bugs-chains.R", sep = "/"));
#source(paste(code.directory, "which-bugs.R",  sep = "/"));

resolution <- 100;

setwd(output.directory);

####################################################################################################
nagelkerke <- function(object = NULL) {
	n    <- sum(object[['model']][[1]]);
	dev  <- object[['deviance']];
	dev0 <- object[['null.deviance']];
	output <- (1 - exp((dev - dev0)/n)) / (1 - exp(- dev0 / n));
	return(output);
	}

####################################################################################################
data(bliss);
str(bliss);
bliss;

####################################################################################################
results.glm <- glm(formula = cbind(dead,alive) ~ conc, data = bliss, family = binomial);
summary(results.glm);

temp.residuals <- residuals(object = results.glm, type = 'pearson');
temp.residuals;
sum(temp.residuals^2);

nagelkerke(object = results.glm);

q();

