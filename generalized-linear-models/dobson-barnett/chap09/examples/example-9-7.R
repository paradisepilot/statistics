
library(lattice);

# load data
FILE.melanoma <- "../../data/table-09-4_Malignant-melanoma.csv";

DF.melanoma <- read.table(
	file   = FILE.melanoma,
	sep    = "\t",
	header = TRUE
	);
DF.melanoma;

#pdf("example-9-2-1_british-doctors_data.pdf");
#dotplot(
#	x      = I(100000 * deaths / person.years) ~ age,
#	groups = smoking,
#	data   = DF.melanoma,
#	);
#dev.off();

### Saturated Model ################################################################################
# GLM model using R built-in functions:
GLM.melanoma.2 <- glm(
	formula = frequency ~ type * site,
	data    = DF.melanoma,
	family  = poisson
	);
summary(GLM.melanoma.2);

# expected values (computed from maximum likelihood estimates of model coefficients),
# (observation-wise) likelihood, Pearson residuals, and deviance residuals:
X <- model.matrix(GLM.melanoma.2);
beta <- coefficients(GLM.melanoma.2);
X;
beta;
cbind(X %*% beta, exp(X %*% beta));

observed.values <- DF.melanoma[,'frequency'];
expected.values <- fitted.values(GLM.melanoma.2);
DF.residuals.2 <- cbind(
	observed          = observed.values,
	expected          = expected.values,
	by.hand           = exp(X %*% beta),
	likelihood        = dpois(x=observed.values,lambda=expected.values),
	Pearson.residual  = (observed.values - expected.values) / sqrt(expected.values)#,
	#deviance.residual = sign(observed.values - expected.values) * sqrt( 2 * (observed.values * log(observed.values/expected.values) - (observed.values - expected.values)) )
	);
DF.residuals.2;

# maximum likelihood
prod(DF.residuals.2[,'likelihood']);
log.max.likelihood.2 <- log( prod(DF.residuals.2[,'likelihood']) );
log.max.likelihood.2;

# Pearson chi-squared statistic
sum(DF.residuals.2[, 'Pearson.residual']^2);

# deviance
# sum(DF.residuals.2[,'deviance.residual']^2);

### Additive Model #################################################################################
# GLM model using R built-in functions:
GLM.melanoma.1 <- glm(
	formula = frequency ~ type + site,
	data    = DF.melanoma,
	family  = poisson
	);
summary(GLM.melanoma.1);

# expected values (computed from maximum likelihood estimates of model coefficients),
# (observation-wise) likelihood, Pearson residuals, and deviance residuals:
X <- model.matrix(GLM.melanoma.1);
beta <- coefficients(GLM.melanoma.1);
X;
beta;
cbind(X %*% beta, exp(X %*% beta));

observed.values <- DF.melanoma[,'frequency'];
expected.values <- fitted.values(GLM.melanoma.1);
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

# Pearson chi-squared statistic
sum(DF.residuals.1[, 'Pearson.residual']^2);

# deviance (method 1)
sum(DF.residuals.1[,'deviance.residual']^2);

# deviance (method 2)
2 * (log.max.likelihood.2 - log.max.likelihood.1);

### Minimal Model ##################################################################################
GLM.melanoma.0 <- glm(
	formula = frequency ~ 1,
	data    = DF.melanoma,
	family  = poisson
	);
summary(GLM.melanoma.0);

X <- model.matrix(GLM.melanoma.0);
beta <- coefficients(GLM.melanoma.0);
X;
beta;
cbind(X %*% beta, exp(X %*% beta));

observed.values <- DF.melanoma[,'frequency'];
expected.values <- fitted.values(GLM.melanoma.0);
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

# likelihood ratio chi-squared statistic (method 1)
2 * (log.max.likelihood.1 - log.max.likelihood.0);

# likelihood ratio chi-squared statistic (method 2)
GLM.melanoma.1$null.deviance;
GLM.melanoma.1$deviance;
likelihood.ratio.chi.squared.statistic <- GLM.melanoma.1$null.deviance - GLM.melanoma.1$deviance;
likelihood.ratio.chi.squared.statistic;

# pseudo-R-squared
(log.max.likelihood.0 - log.max.likelihood.1) / log.max.likelihood.0;

