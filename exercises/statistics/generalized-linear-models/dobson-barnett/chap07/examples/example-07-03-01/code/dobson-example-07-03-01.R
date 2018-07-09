
command.arguments <- commandArgs(trailingOnly = TRUE);
data.directory   <- command.arguments[1];
output.directory <- command.arguments[2];
code.directory   <- command.arguments[3];
tmp.directory    <- command.arguments[4];

####################################################################################################
library(MPV);
library(ggplot2);

#source(paste(code.directory, "bugs-chains.R", sep = "/"));
#source(paste(code.directory, "which-bugs.R",  sep = "/"));

####################################################################################################
setwd(output.directory);

####################################################################################################
DF.data <- read.delim(
	file = paste0(data.directory,'/table-07-02-beetle-mortality.csv'),
	sep  = '\t'
	);
DF.data[,'num.alive'] <- DF.data[,'num.of.beetles'] - DF.data[,'num.killed'];
DF.data[,'saturated.model'] <- factor(1:nrow(DF.data));
str(DF.data);
DF.data;

####################################################################################################
glm.results <- glm(
	formula = cbind(num.killed,num.alive) ~ dose,
	data    = DF.data,
	family  = binomial(link = "logit")
	);

summary(glm.results);

####################################################################################################
### VERIFYING PARAMETER ESTIMATES AND FITTED VALUES

coefficients(glm.results);

X <- cbind(rep(1,nrow(DF.data)),DF.data[,'dose']);
X;

temp <- X %*% coefficients(glm.results);
computed.predictors <- exp(temp) / (1 + exp(temp));

predictors <- fitted.values(glm.results);
cbind(
	DF.data,
	fitted = DF.data[,'num.of.beetles'] * predictors,
	pi = predictors,
	computed.pi = computed.predictors
	);

####################################################################################################
summary(glm.results)[['cov.scaled']];
summary(glm.results)[['cov.unscaled']];

####################################################################################################
### VERIFYING DEVIANCE FOR TWO-PARAMETER MODEL IN EXAMPLE 7.3.1

# compute likelihood for saturated model
saturated.glm.results <- glm(
	formula = cbind(num.killed,num.alive) ~ saturated.model,
	data    = DF.data,
	family  = binomial(link = "logit")
	);

summary(saturated.glm.results);

saturated.predictors <- fitted.values(saturated.glm.results);
saturated.likelihood <- dbinom(
	x    = DF.data[,'num.killed'],
	size = DF.data[,'num.of.beetles'],
	prob = saturated.predictors,
	log  = FALSE
	);

prod(saturated.likelihood);
log(prod(saturated.likelihood));

# compute likelihood for two-parameter model in Example 7.3.1
likelihood <- dbinom(
	x    = DF.data[,'num.killed'],
	size = DF.data[,'num.of.beetles'],
	prob = predictors,
	log  = FALSE
	);
likelihood;
prod(likelihood);
log(prod(likelihood));

# compute deviance for two-parameter model in Exmaple 7.3.1:
2 * ( log(prod(saturated.likelihood)) - log(prod(likelihood)) );
deviance(glm.results);

####################################################################################################
### VERIYING DEVIANCE FOR NULL MODEL
null.glm.results <- glm(
	formula = cbind(num.killed,num.alive) ~ 1,
	data    = DF.data,
	family  = binomial(link = "logit")
	);

null.predictors <- fitted.values(null.glm.results);
null.likelihood <- dbinom(
	x    = DF.data[,'num.killed'],
	size = DF.data[,'num.of.beetles'],
	prob = null.predictors,
	log  = FALSE
	);
prod(null.likelihood);
log(prod(null.likelihood));

# deviance for null model computed in three ways:
2 * ( log(prod(saturated.likelihood)) - log(prod(null.likelihood)) );
deviance(null.glm.results);
glm.results[['null.deviance']];

####################################################################################################

q()

