
command.arguments <- commandArgs(trailingOnly = TRUE);
output.directory  <- command.arguments[1];
code.directory    <- command.arguments[2];
tmp.directory     <- command.arguments[3];

####################################################################################################
library(faraway);
library(ggplot2);

#source(paste(code.directory, "bugs-chains.R", sep = "/"));
#source(paste(code.directory, "which-bugs.R",  sep = "/"));

####################################################################################################
setwd(output.directory);

####################################################################################################
data(uswages);

str(uswages);

lm.results <- lm(
	formula = wage ~ educ + exper,
	data    = uswages
	);
summary(lm.results);

lm.results <- lm(
	formula = log(wage) ~ educ + exper,
	data    = uswages
	);
summary(lm.results);

####################################################################################################

q();

