
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
DF.waiver <- data.frame(
	y = c(320,14,80,36),
	particle = c('no','yes','no','yes'),
	quality  = factor(x = c('good','good','bad','bad'), levels = c('good','bad'))
	);
str(DF.waiver);
DF.waiver;

####################################################################################################
xtabs(formula = y ~ quality + particle, data = DF.waiver)

####################################################################################################
results.poisson <- glm(
	formula = y ~ particle + quality,
	data    = DF.waiver,
	family  = poisson
	);
summary(results.poisson);

drop1(results.poisson, test = 'LRT');


results.temp <- glm(formula = y ~ quality, data = DF.waiver, family  = poisson);
anova(results.temp,results.poisson,test='LRT');

results.temp <- glm(formula = y ~ particle, data = DF.waiver, family  = poisson);
anova(results.temp,results.poisson,test='LRT');

####################################################################################################

q();

