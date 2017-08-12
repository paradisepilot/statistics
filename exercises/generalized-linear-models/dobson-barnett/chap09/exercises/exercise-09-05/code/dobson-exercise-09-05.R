
command.arguments <- commandArgs(trailingOnly = TRUE);
data.directory   <- command.arguments[1];
output.directory <- command.arguments[2];
code.directory   <- command.arguments[3];
tmp.directory    <- command.arguments[4];

####################################################################################################
library(ggplot2);

#source(paste(code.directory, "bugs-chains.R", sep = "/"));
#source(paste(code.directory, "which-bugs.R",  sep = "/"));

####################################################################################################
setwd(output.directory);

####################################################################################################
DF.data <- read.delim(
	file = paste0(data.directory,'/table-08-05-housing-conditions.csv'),
	sep  = '\t'
	);
str(DF.data);
DF.data;

### (a) ############################################################################################

# Tower block
glm.independence <- glm(
	formula = frequency ~ satisfaction + contact,
	data    = DF.data["tower block" == DF.data[,'type'],],
	family  = poisson
	);
summary(glm.independence);

glm.interaction <- glm(
	formula = frequency ~ satisfaction + contact + satisfaction * contact,
	data    = DF.data["tower block" == DF.data[,'type'],],
	family  = poisson
	);
summary(glm.interaction);

anova(glm.independence,glm.interaction,test='Chisq');

# apartment
glm.independence <- glm(
	formula = frequency ~ satisfaction + contact,
	data    = DF.data["apartment" == DF.data[,'type'],],
	family  = poisson
	);
summary(glm.independence);

glm.interaction <- glm(
	formula = frequency ~ satisfaction + contact + satisfaction * contact,
	data    = DF.data["apartment" == DF.data[,'type'],],
	family  = poisson
	);
summary(glm.interaction);

anova(glm.independence,glm.interaction,test='Chisq');

# house
glm.independence <- glm(
	formula = frequency ~ satisfaction + contact,
	data    = DF.data["house" == DF.data[,'type'],],
	family  = poisson
	);
summary(glm.independence);

glm.interaction <- glm(
	formula = frequency ~ satisfaction + contact + satisfaction * contact,
	data    = DF.data["house" == DF.data[,'type'],],
	family  = poisson
	);
summary(glm.interaction);

anova(glm.independence,glm.interaction,test='Chisq');

#
# Conclusions:
#
# We compare the independence model with the interaction model (which happens to be the 
# saturated model) for tower blocks only.
# This boils down to examining the "difference of deviances" statistics between the two models
# (the deviance of the independence model minus that of the saturated model).
# This difference of deviances in this case simplifies to just the deviance of the independence
# model, since the saturated model model happens to have deviance zero in the case of a
# Generalized Linear Model with Poisson response distribution.
#
# (i)   Tower block:
#       The p-value based on the independence model deviance (which equals to "difference of
#       deviances" statistic in this case) is 0.03435 (6.7424, with 2 degrees of freedom).
#       We thus reject the null hypothesis that, for tower block residents, contact and
#       satisfaction are not assoicated. Though the evidence does not appear particularly
#       strong.
#
# (ii)  Apartment:
#       The p-value based on the independence model deviance (which equals to "difference of
#       deviances" statistic in this case) is 0.02081 (7.7448, with 2 degrees of freedom).
#       We thus reject the null hypothesis that, for apartment residents, contact and
#       satisfaction are not assoicated. Though the evidence does not appear particularly
#       strong.
#
# (iii) House:
#       The p-value based on the independence model deviance (which equals to "difference of
#       deviances" statistic in this case) is 0.529 (1.2736, with 2 degrees of freedom).
#       We thus do NOT reject the null hypothesis that, for apartment residents, contact and
#       satisfaction are not assoicated.
#

### (b) ############################################################################################
glm.independence <- glm(
	formula = frequency ~ satisfaction + contact,
	data    = DF.data,
	family  = poisson
	);
summary(glm.independence);

glm.interaction <- glm(
	formula = frequency ~ satisfaction + contact + satisfaction * contact,
	data    = DF.data,
	family  = poisson
	);
summary(glm.interaction);

anova(glm.independence,glm.interaction,test='Chisq');

#
# Conclusions:
#
# When we compute the "difference of deviances" statistic for the independence model and the
# interaction model (the deviance of the independence model minus that of the interaction model),
# we find that the resulting statistic has value 5.1258, with 2 degrees of freedom, which gives
# p-value of 0.07708. We therefore do NOT reject the null hypothesis that contact and satisfaction
# are not associated.
#
# Comments:
# deg.freedom(independence model) = #(observations) - #(parameters) = 18 - 4 = 14.
# deg.freedom(interaction  model) = #(observations) - #(parameters) = 18 - 6 = 12.
#
# Note also that the interaction model here is no longer the saturated model.
#

q();

