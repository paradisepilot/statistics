
library(lattice);

# load data
FILE.ulcer <- "../../data/table-09-7_Ulcer-and-aspirin-use.csv";

DF.ulcer <- read.table(
	file = FILE.ulcer,
	sep = "\t",
	header = TRUE
	);
DF.ulcer;

####################################################################################################
### Saturated model (i.e each data point gets its own a fixed-effect parameter) ####################
GLM.ulcer.5 <- glm(
	formula = frequency ~ ulcer.site * case.control * aspirin,
	data    = DF.ulcer,
	family  = poisson
	);
summary(GLM.ulcer.5);

# expected values (computed from maximum likelihood estimates of model coefficients),
# (observation-wise) likelihood, Pearson residuals, and deviance residuals:
X <- model.matrix(GLM.ulcer.5);
beta <- coefficients(GLM.ulcer.5);
X;
beta;
cbind( X %*% beta, exp(X %*% beta));

observed.values <- DF.ulcer[,'frequency'];
expected.values <- fitted.values(GLM.ulcer.5);
DF.residuals.5 <- cbind(
	observed          = observed.values,
	expected          = expected.values,
	by.hand           = exp(X %*% beta),
	likelihood        = dpois(x=observed.values,lambda=expected.values),
	Pearson.residual  = (observed.values - expected.values) / sqrt(expected.values),
	deviance.residual = rep(0,length(observed.values))
	# deviance.residual = sign(observed.values - expected.values) * sqrt( 2 * (observed.values * log(observed.values/expected.values) - (observed.values - expected.values)) )
	);
DF.residuals.5;

# maximum likelihood
prod(DF.residuals.5[,'likelihood']);
log.max.likelihood.5 <- log( prod(DF.residuals.5[,'likelihood']) );
log.max.likelihood.5;

####################################################################################################
### Saturated model (i.e each data point gets its own a fixed-effect parameter) ####################
GLM.ulcer.4 <- glm(
	formula = frequency ~ ulcer.site * case.control + aspirin * case.control + aspirin * ulcer.site,
	data    = DF.ulcer,
	family  = poisson
	);
summary(GLM.ulcer.4);

# expected values (computed from maximum likelihood estimates of model coefficients),
# (observation-wise) likelihood, Pearson residuals, and deviance residuals:
X <- model.matrix(GLM.ulcer.4);
beta <- coefficients(GLM.ulcer.4);
X;
beta;
cbind( X %*% beta, exp(X %*% beta));

observed.values <- DF.ulcer[,'frequency'];
expected.values <- fitted.values(GLM.ulcer.4);
DF.residuals.4 <- cbind(
	observed          = observed.values,
	expected          = expected.values,
	by.hand           = exp(X %*% beta),
	likelihood        = dpois(x=observed.values,lambda=expected.values),
	Pearson.residual  = (observed.values - expected.values) / sqrt(expected.values),
	deviance.residual = sign(observed.values - expected.values) * sqrt( 2 * (observed.values * log(observed.values/expected.values) - (observed.values - expected.values)) )
	);
DF.residuals.4;

# maximum likelihood
prod(DF.residuals.4[,'likelihood']);
log.max.likelihood.4 <- log( prod(DF.residuals.4[,'likelihood']) );
log.max.likelihood.4;

####################################################################################################
### Saturated model (i.e each data point gets its own a fixed-effect parameter) ####################
GLM.ulcer.3 <- glm(
	formula = frequency ~ ulcer.site * case.control + aspirin * case.control,
	data    = DF.ulcer,
	family  = poisson
	);
summary(GLM.ulcer.3);

# expected values (computed from maximum likelihood estimates of model coefficients),
# (observation-wise) likelihood, Pearson residuals, and deviance residuals:
X <- model.matrix(GLM.ulcer.3);
beta <- coefficients(GLM.ulcer.3);
X;
beta;
cbind( X %*% beta, exp(X %*% beta));

observed.values <- DF.ulcer[,'frequency'];
expected.values <- fitted.values(GLM.ulcer.3);
DF.residuals.3 <- cbind(
	observed          = observed.values,
	expected          = expected.values,
	by.hand           = exp(X %*% beta),
	likelihood        = dpois(x=observed.values,lambda=expected.values),
	Pearson.residual  = (observed.values - expected.values) / sqrt(expected.values),
	deviance.residual = sign(observed.values - expected.values) * sqrt( 2 * (observed.values * log(observed.values/expected.values) - (observed.values - expected.values)) )
	);
DF.residuals.3;

# maximum likelihood
prod(DF.residuals.3[,'likelihood']);
log.max.likelihood.3 <- log( prod(DF.residuals.3[,'likelihood']) );
log.max.likelihood.3;

####################################################################################################
### Saturated model (i.e each data point gets its own a fixed-effect parameter) ####################
GLM.ulcer.2 <- glm(
	formula = frequency ~ ulcer.site * case.control + aspirin,
	data    = DF.ulcer,
	family  = poisson
	);
summary(GLM.ulcer.2);

# expected values (computed from maximum likelihood estimates of model coefficients),
# (observation-wise) likelihood, Pearson residuals, and deviance residuals:
X <- model.matrix(GLM.ulcer.2);
beta <- coefficients(GLM.ulcer.2);
X;
beta;
cbind( X %*% beta, exp(X %*% beta));

observed.values <- DF.ulcer[,'frequency'];
expected.values <- fitted.values(GLM.ulcer.2);
DF.residuals.2 <- cbind(
	observed          = observed.values,
	expected          = expected.values,
	by.hand           = exp(X %*% beta),
	likelihood        = dpois(x=observed.values,lambda=expected.values),
	Pearson.residual  = (observed.values - expected.values) / sqrt(expected.values),
	deviance.residual = sign(observed.values - expected.values) * sqrt( 2 * (observed.values * log(observed.values/expected.values) - (observed.values - expected.values)) )
	);
DF.residuals.2;

# maximum likelihood
prod(DF.residuals.2[,'likelihood']);
log.max.likelihood.2 <- log( prod(DF.residuals.2[,'likelihood']) );
log.max.likelihood.2;

####################################################################################################
### Saturated model (i.e each data point gets its own a fixed-effect parameter) ####################
GLM.ulcer.1 <- glm(
	formula = frequency ~ ulcer.site * case.control,
	data    = DF.ulcer,
	family  = poisson
	);
summary(GLM.ulcer.1);

# expected values (computed from maximum likelihood estimates of model coefficients),
# (observation-wise) likelihood, Pearson residuals, and deviance residuals:
X <- model.matrix(GLM.ulcer.1);
beta <- coefficients(GLM.ulcer.1);
X;
beta;
cbind( X %*% beta, exp(X %*% beta));

observed.values <- DF.ulcer[,'frequency'];
expected.values <- fitted.values(GLM.ulcer.1);
DF.residuals.1 <- cbind(
	observed          = observed.values,
	expected          = expected.values,
	by.hand           = exp(X %*% beta),
	likelihood        = dpois(x=observed.values,lambda=expected.values),
	Pearson.residual  = (observed.values - expected.values) / sqrt(expected.values),
	deviance.residual = sign(observed.values - expected.values) * sqrt( 2 * (observed.values * log(observed.values/expected.values) - (observed.values - expected.values)) )
	);
DF.residuals.1;

# maximum likelihood
prod(DF.residuals.1[,'likelihood']);
log.max.likelihood.1 <- log( prod(DF.residuals.1[,'likelihood']) );
log.max.likelihood.1;

####################################################################################################
### Saturated model (i.e each data point gets its own a fixed-effect parameter) ####################
GLM.ulcer.0 <- glm(
	formula = frequency ~ 1,
	data    = DF.ulcer,
	family  = poisson
	);
summary(GLM.ulcer.0);

# expected values (computed from maximum likelihood estimates of model coefficients),
# (observation-wise) likelihood, Pearson residuals, and deviance residuals:
X <- model.matrix(GLM.ulcer.0);
beta <- coefficients(GLM.ulcer.0);
X;
beta;
cbind( X %*% beta, exp(X %*% beta));

observed.values <- DF.ulcer[,'frequency'];
expected.values <- fitted.values(GLM.ulcer.0);
DF.residuals.0 <- cbind(
	observed          = observed.values,
	expected          = expected.values,
	by.hand           = exp(X %*% beta),
	likelihood        = dpois(x=observed.values,lambda=expected.values),
	Pearson.residual  = (observed.values - expected.values) / sqrt(expected.values),
	deviance.residual = sign(observed.values - expected.values) * sqrt( 2 * (observed.values * log(observed.values/expected.values) - (observed.values - expected.values)) )
	);
DF.residuals.0;

# maximum likelihood
prod(DF.residuals.0[,'likelihood']);
log.max.likelihood.0 <- log( prod(DF.residuals.0[,'likelihood']) );
log.max.likelihood.0;

####################################################################################################
####################################################################################################
# Pearson chi-squared statistic of Saturated Model
sum(DF.residuals.5[, 'Pearson.residual']^2);

# pseudo-R-squared of Saturated Model
(log.max.likelihood.0 - log.max.likelihood.5) / log.max.likelihood.0;

# likelihood ratio chi-squared statistic of Saturated Model --- method 1
#   likelihood ratio chi-squared statistic(model of interest)
# = 2 * [ log(max. likelihood of model of interest) - log(max. likelihood of intercept-only model) ]
2 * (log.max.likelihood.5 - log.max.likelihood.0);

# likelihood ratio chi-squared statistic of Saturated Model --- method 2
GLM.ulcer.5$null.deviance;
GLM.ulcer.5$deviance;
likelihood.ratio.chi.squared.statistic <- GLM.ulcer.5$null.deviance - GLM.ulcer.5$deviance;
likelihood.ratio.chi.squared.statistic;

# deviance of Saturated Model --- method 1
sum(DF.residuals.5[,'deviance.residual']^2);

# deviance of Saturated Model --- method 2
# Recall that:
# deviance(model of interest) := 2 * [ log(max. likelihood of saturated model) - log(max. likelihood of model of interest)) ]
2 * (log.max.likelihood.5 - log.max.likelihood.5);

####################################################################################################
####################################################################################################
# Pearson chi-squared statistic of Saturated Model
sum(DF.residuals.4[, 'Pearson.residual']^2);

# pseudo-R-squared of Saturated Model
(log.max.likelihood.0 - log.max.likelihood.4) / log.max.likelihood.0;

# likelihood ratio chi-squared statistic of Saturated Model --- method 1
#   likelihood ratio chi-squared statistic(model of interest)
# = 2 * [ log(max. likelihood of model of interest) - log(max. likelihood of intercept-only model) ]
2 * (log.max.likelihood.4 - log.max.likelihood.0);

# likelihood ratio chi-squared statistic of Saturated Model --- method 2
GLM.ulcer.4$null.deviance;
GLM.ulcer.4$deviance;
likelihood.ratio.chi.squared.statistic <- GLM.ulcer.4$null.deviance - GLM.ulcer.4$deviance;
likelihood.ratio.chi.squared.statistic;

# deviance of Saturated Model --- method 1
sum(DF.residuals.4[,'deviance.residual']^2);

# deviance of Saturated Model --- method 2
# Recall that:
# deviance(model of interest) := 2 * [ log(max. likelihood of saturated model) - log(max. likelihood of model of interest)) ]
2 * (log.max.likelihood.5 - log.max.likelihood.4);

####################################################################################################
####################################################################################################
# Pearson chi-squared statistic of Saturated Model
sum(DF.residuals.3[, 'Pearson.residual']^2);

# pseudo-R-squared of Saturated Model
(log.max.likelihood.0 - log.max.likelihood.3) / log.max.likelihood.0;

# likelihood ratio chi-squared statistic of Saturated Model --- method 1
#   likelihood ratio chi-squared statistic(model of interest)
# = 2 * [ log(max. likelihood of model of interest) - log(max. likelihood of intercept-only model) ]
2 * (log.max.likelihood.3 - log.max.likelihood.0);

# likelihood ratio chi-squared statistic of Saturated Model --- method 2
GLM.ulcer.3$null.deviance;
GLM.ulcer.3$deviance;
likelihood.ratio.chi.squared.statistic <- GLM.ulcer.3$null.deviance - GLM.ulcer.3$deviance;
likelihood.ratio.chi.squared.statistic;

# deviance of Saturated Model --- method 1
sum(DF.residuals.3[,'deviance.residual']^2);

# deviance of Saturated Model --- method 2
# Recall that:
# deviance(model of interest) := 2 * [ log(max. likelihood of saturated model) - log(max. likelihood of model of interest)) ]
2 * (log.max.likelihood.5 - log.max.likelihood.3);

####################################################################################################
####################################################################################################
# Pearson chi-squared statistic of Saturated Model
sum(DF.residuals.2[, 'Pearson.residual']^2);

# pseudo-R-squared of Saturated Model
(log.max.likelihood.0 - log.max.likelihood.2) / log.max.likelihood.0;

# likelihood ratio chi-squared statistic of Saturated Model --- method 1
#   likelihood ratio chi-squared statistic(model of interest)
# = 2 * [ log(max. likelihood of model of interest) - log(max. likelihood of intercept-only model) ]
2 * (log.max.likelihood.2 - log.max.likelihood.0);

# likelihood ratio chi-squared statistic of Saturated Model --- method 2
GLM.ulcer.2$null.deviance;
GLM.ulcer.2$deviance;
likelihood.ratio.chi.squared.statistic <- GLM.ulcer.2$null.deviance - GLM.ulcer.2$deviance;
likelihood.ratio.chi.squared.statistic;

# deviance of Saturated Model --- method 1
sum(DF.residuals.2[,'deviance.residual']^2);

# deviance of Saturated Model --- method 2
# Recall that:
# deviance(model of interest) := 2 * [ log(max. likelihood of saturated model) - log(max. likelihood of model of interest)) ]
2 * (log.max.likelihood.5 - log.max.likelihood.2);

####################################################################################################
####################################################################################################
# Pearson chi-squared statistic of Saturated Model
sum(DF.residuals.1[, 'Pearson.residual']^2);

# pseudo-R-squared of Saturated Model
(log.max.likelihood.0 - log.max.likelihood.1) / log.max.likelihood.0;

# likelihood ratio chi-squared statistic of Saturated Model --- method 1
#   likelihood ratio chi-squared statistic(model of interest)
# = 2 * [ log(max. likelihood of model of interest) - log(max. likelihood of intercept-only model) ]
2 * (log.max.likelihood.1 - log.max.likelihood.0);

# likelihood ratio chi-squared statistic of Saturated Model --- method 2
GLM.ulcer.1$null.deviance;
GLM.ulcer.1$deviance;
likelihood.ratio.chi.squared.statistic <- GLM.ulcer.1$null.deviance - GLM.ulcer.1$deviance;
likelihood.ratio.chi.squared.statistic;

# deviance of Saturated Model --- method 1
sum(DF.residuals.1[,'deviance.residual']^2);

# deviance of Saturated Model --- method 2
# Recall that:
# deviance(model of interest) := 2 * [ log(max. likelihood of saturated model) - log(max. likelihood of model of interest)) ]
2 * (log.max.likelihood.5 - log.max.likelihood.1);

####################################################################################################
####################################################################################################
# Pearson chi-squared statistic of Saturated Model
sum(DF.residuals.0[, 'Pearson.residual']^2);

# pseudo-R-squared of Saturated Model
(log.max.likelihood.0 - log.max.likelihood.0) / log.max.likelihood.0;

# likelihood ratio chi-squared statistic of Saturated Model --- method 1
#   likelihood ratio chi-squared statistic(model of interest)
# = 2 * [ log(max. likelihood of model of interest) - log(max. likelihood of intercept-only model) ]
2 * (log.max.likelihood.0 - log.max.likelihood.0);

# likelihood ratio chi-squared statistic of Saturated Model --- method 2
GLM.ulcer.0$null.deviance;
GLM.ulcer.0$deviance;
likelihood.ratio.chi.squared.statistic <- GLM.ulcer.0$null.deviance - GLM.ulcer.0$deviance;
likelihood.ratio.chi.squared.statistic;

# deviance of Saturated Model --- method 1
sum(DF.residuals.0[,'deviance.residual']^2);

# deviance of Saturated Model --- method 2
# Recall that:
# deviance(model of interest) := 2 * [ log(max. likelihood of saturated model) - log(max. likelihood of model of interest)) ]
2 * (log.max.likelihood.5 - log.max.likelihood.0);

q();

####################################################################################################
####################################################################################################
# Pearson chi-squared statistic of Saturated Model
sum(DF.residuals.2[, 'Pearson.residual']^2);

# pseudo-R-squared of Saturated Model
(log.max.likelihood.0 - log.max.likelihood.2) / log.max.likelihood.0;

# likelihood ratio chi-squared statistic of Saturated Model --- method 1
#   likelihood ratio chi-squared statistic(model of interest)
# = 2 * [ log(max. likelihood of model of interest) - log(max. likelihood of intercept-only model) ]
2 * (log.max.likelihood.2 - log.max.likelihood.0);

# likelihood ratio chi-squared statistic of Saturated Model --- method 2
GLM.ulcer.2$null.deviance;
GLM.ulcer.2$deviance;
likelihood.ratio.chi.squared.statistic <- GLM.ulcer.2$null.deviance - GLM.ulcer.2$deviance;
likelihood.ratio.chi.squared.statistic;

# deviance of Saturated Model --- method 1
sum(DF.residuals.2[,'deviance.residual']^2);

# deviance of Saturated Model --- method 2
# Recall that:
# deviance(model of interest) := 2 * [ log(max. likelihood of saturated model) - log(max. likelihood of model of interest)) ]
2 * (log.max.likelihood.2 - log.max.likelihood.2);

####################################################################################################
####################################################################################################
# Pearson chi-squared statistic of Model given by Eqn (9.9)
sum(DF.residuals.1[, 'Pearson.residual']^2);

# pseudo-R-squared of Model given by Eqn (9.9)
(log.max.likelihood.0 - log.max.likelihood.1) / log.max.likelihood.0;

# likelihood ratio chi-squared statistic of Model given by Eqn (9.9) --- method 1
#   likelihood ratio chi-squared statistic(model of interest)
# = 2 * [ log(max. likelihood of model of interest) - log(max. likelihood of intercept-only model) ]
2 * (log.max.likelihood.1 - log.max.likelihood.0);

# likelihood ratio chi-squared statistic of Model given by Eqn (9.9) --- method 2
GLM.ulcer.1$null.deviance;
GLM.ulcer.1$deviance;
likelihood.ratio.chi.squared.statistic <- GLM.ulcer.1$null.deviance - GLM.ulcer.1$deviance;
likelihood.ratio.chi.squared.statistic;

# deviance of Model given by Eqn (9.9) --- method 1
sum(DF.residuals.1[,'deviance.residual']^2);

# deviance of Model given by Eqn (9.9) --- method 2
# Recall that:
# deviance(model interest) := 2 * [ log(max. likelihood of saturated model) - log(max. likelihood of model of interest)) ]
2 * (log.max.likelihood.2 - log.max.likelihood.1);

####################################################################################################
####################################################################################################
# Pearson chi-squared statistic of Intercept-only Model
sum(DF.residuals.0[, 'Pearson.residual']^2);

# pseudo-R-squared of Intercept-only Model
(log.max.likelihood.0 - log.max.likelihood.0) / log.max.likelihood.0;

# likelihood ratio chi-squared statistic of Intercept-only Model --- method 1
#   likelihood ratio chi-squared statistic(model of interest)
# = 2 * [ log(max. likelihood of model of interest) - log(max. likelihood of intercept-only model) ]
2 * (log.max.likelihood.0 - log.max.likelihood.0);

# likelihood ratio chi-squared statistic of Intercept-only Model --- method 2
GLM.ulcer.0$null.deviance;
GLM.ulcer.0$deviance;
likelihood.ratio.chi.squared.statistic <- GLM.ulcer.0$null.deviance - GLM.ulcer.0$deviance;
likelihood.ratio.chi.squared.statistic;

# deviance of Intercept-only Model (i.e. minimal model) --- method 1
sum(DF.residuals.0[,'deviance.residual']^2);

# deviance of Intercept-only Model (i.e. minimal model) --- method 2
# Recall that:
# deviance(model of interest) := 2 * [ log(max. likelihood of saturated model) - log(max. likelihood of model of interest)) ]
log.max.likelihood.2;
log.max.likelihood.0;
2 * (log.max.likelihood.2 - log.max.likelihood.0);

####################################################################################################
####################################################################################################

anova(GLM.ulcer.0,GLM.ulcer.1);


anova(GLM.ulcer.0,GLM.ulcer.2);


anova(GLM.ulcer.1,GLM.ulcer.2);

print("ZZZ");

