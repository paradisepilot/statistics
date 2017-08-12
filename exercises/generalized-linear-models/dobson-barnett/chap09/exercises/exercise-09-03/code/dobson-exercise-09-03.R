
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
	file = paste0(data.directory,'/table-09-06-influenza-vaccine.csv'),
	sep  = '\t'
	);
str(DF.data);
DF.data;

### (a) ############################################################################################
DF.sum.by.response  <- aggregate(formula = frequency ~ response,  data = DF.data, FUN = sum);
DF.sum.by.treatment <- aggregate(formula = frequency ~ treatment, data = DF.data, FUN = sum);

colnames(DF.sum.by.response) <- gsub(
	x           = colnames(DF.sum.by.response),
	pattern     = 'frequency',
	replacement = 'response.marginal'
	);

colnames(DF.sum.by.treatment) <- gsub(
	x           = colnames(DF.sum.by.treatment),
	pattern     = 'frequency',
	replacement = 'treatment.marginal'
	);

DF.data <- merge(x = DF.data, y = DF.sum.by.response,  by = 'response' );
DF.data <- merge(x = DF.data, y = DF.sum.by.treatment, by = 'treatment');
DF.data[,'total'] <- sum(DF.data[,'frequency']);
DF.data[,'expected'] <- DF.data[,'response.marginal'] * DF.data[,'treatment.marginal'] / DF.data[,'total'];
DF.data[,'pearson.residual'] <- (DF.data[,'frequency'] - DF.data[,'expected']) / sqrt(DF.data[,'expected']);
DF.data;

X2 <- sum( (DF.data[,'pearson.residual'])^2 );
X2;
pchisq(q = X2, df = 2, lower.tail = FALSE);

# Conclusion:
# Since the p-value of the X2-test is 0.0001472 < 0.05, we reject the null hypothesis that
# the distributions of responses is the same for the placebo and vaccine groups.

# double check:
DF.temp <- data.frame(
	placebo = DF.data["placebo" == DF.data[,'treatment'],'frequency'],
	vaccine = DF.data["vaccine" == DF.data[,'treatment'],'frequency']
	);

DF.temp;

chisq.test(x = DF.temp);

### (b) ############################################################################################
glm.independent <- glm(
	formula = frequency ~ treatment + response,
	data    = DF.data,
	family  = poisson
	);

glm.interaction <- glm(
	formula = frequency ~ treatment + response + treatment * response,
	data    = DF.data,
	family  = poisson
	);

summary(glm.independent);
summary(glm.interaction);

anova(glm.independent,glm.interaction,test = 'Chisq');

fittedValues <- fitted.values(glm.independent);

temp = 2 * (DF.data[,'frequency'] * log(DF.data[,'frequency']/fittedValues) - (DF.data[,'frequency'] - fittedValues));
devianceResiduals = sign(DF.data[,'frequency'] - fittedValues) * sqrt(temp);

DF.residuals <- data.frame(
	fitted.value      = fittedValues,
	pearson.residual  = (DF.data[,'frequency'] - fittedValues) / sqrt(fittedValues),
	deviance.residual = devianceResiduals
	);
DF.residuals;

# Chi-sq goodness-of-fit statistic X2:
X2 <- sum(DF.residuals[,'pearson.residual']^2);
X2;
pchisq(q = X2, df = 2, lower.tail = FALSE);

# Deviance = 2 * (log(likelihood.saturated.model) - log(likelihood.given.model)):
Deviance <- sum(DF.residuals[,'deviance.residual']^2);
Deviance;
pchisq(q = Deviance, df = 2, lower.tail = FALSE);

#
# Conclusions:
#
# (*) The independence model fits the data poorly. This can be from the small p-values
#     of both the Pearson X2 (goodness-of-fit) statistic and the Deviance.
#
# (*) The Deviance also happens to be the "difference of deviances" statistic for comparing
#     the independence model and the full interaction model; this is so because the full
#     interaction model happens to be the saturated model, and the deviance of the saturated
#     model in a Generalized Linear Model with Poisson response distribution happens to be
#     zero deviance residuals, and hence zero deviance.
#
#     Consequently, we also reject the null hypothsis that treatment and response are
#     independent, since the p-value obtained of the independence model deviance
#     8.95007e-05 < 0.05.
#

####################################################################################################

q();

