
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

####################################################################################################
data(babyfood);
babyfood;

####################################################################################################
setwd(output.directory);

results.logit <- glm(
	data    = babyfood,
	formula = cbind(disease,nondisease) ~ sex + food,
	family  = binomial(link = logit)
	);
summary(results.logit);
pchisq(q = deviance(results.logit), df = df.residual(results.logit), lower = FALSE);

drop1(results.logit, test = 'LRT');

####################################################################################################
results.temp <- glm(
	data    = babyfood,
	formula = cbind(disease,nondisease) ~ sex,
	family  = binomial(link = logit)
	);
anova(results.temp, results.logit, test = 'LRT');

results.temp <- glm(
	data    = babyfood,
	formula = cbind(disease,nondisease) ~ food,
	family  = binomial(link = logit)
	);
anova(results.temp, results.logit, test = 'LRT');

####################################################################################################

q();

