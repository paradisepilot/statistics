
library(lattice);

# load data
FILE.british.doctors <- "../../data/table-09-1_British-doctors-smoking-and-coronary-death.csv";

DF.british.doctors <- read.table(
	file = FILE.british.doctors,
	sep = "\t",
	header = TRUE
	);
DF.british.doctors;

pdf("example-9-2-1_british-doctors_data.pdf");
dotplot(
	x      = I(100000 * deaths / person.years) ~ age,
	groups = smoking,
	data   = DF.british.doctors,
	);
dev.off();

DF.british.doctors;

# augment auxiliary columns:
DF.british.doctors[,'agecat'] <- rep(0,nrow(DF.british.doctors));
DF.british.doctors[DF.british.doctors[,'age']=='35_to_44','agecat'] <- 1;
DF.british.doctors[DF.british.doctors[,'age']=='45_to_54','agecat'] <- 2;
DF.british.doctors[DF.british.doctors[,'age']=='55_to_64','agecat'] <- 3;
DF.british.doctors[DF.british.doctors[,'age']=='65_to_74','agecat'] <- 4;
DF.british.doctors[DF.british.doctors[,'age']=='75_to_84','agecat'] <- 5;
DF.british.doctors['agesq'] <- DF.british.doctors[,'agecat']^2;
DF.british.doctors[,'smkage'] <- DF.british.doctors[,'agecat'];
DF.british.doctors[DF.british.doctors[,'smoking']=='non.smoker','smkage'] <- 0;
DF.british.doctors;

### Saturated model (i.e each data point gets its own a fixed-effect parameter) ####################
DF.british.doctors.2 <- DF.british.doctors;
DF.british.doctors.2[,'agecat']  <- factor(DF.british.doctors.2[,'agecat']);
DF.british.doctors.2[,'smoking'] <- factor(DF.british.doctors.2[,'smoking']);
DF.british.doctors.2;
GLM.british.doctors.2 <- glm(
	formula = deaths ~ offset(log(person.years)) + agecat * smoking,
	data    = DF.british.doctors.2,
	family  = poisson
	);
summary(GLM.british.doctors.2);

# expected values (computed from maximum likelihood estimates of model coefficients),
# (observation-wise) likelihood, Pearson residuals, and deviance residuals:
X <- model.matrix(GLM.british.doctors.2);
beta <- coefficients(GLM.british.doctors.2);
X;
beta;
cbind( X %*% beta, DF.british.doctors[,'person.years'] * exp(X %*% beta));

observed.values <- DF.british.doctors[,'deaths'];
expected.values <- fitted.values(GLM.british.doctors.2);
DF.residuals.2 <- cbind(
	observed          = observed.values,
	expected          = expected.values,
	by.hand           = DF.british.doctors[,'person.years'] * exp(X %*% beta),
	likelihood        = dpois(x=observed.values,lambda=expected.values),
	Pearson.residual  = (observed.values - expected.values) / sqrt(expected.values),
	deviance.residual = rep(0,length(observed.values))
	# deviance.residual = sign(observed.values - expected.values) * sqrt( 2 * (observed.values * log(observed.values/expected.values) - (observed.values - expected.values)) )
	);
DF.residuals.2;

# maximum likelihood
prod(DF.residuals.2[,'likelihood']);
log.max.likelihood.2 <- log( prod(DF.residuals.2[,'likelihood']) );
log.max.likelihood.2;

### Model of interest (in this case, the model given by Eqn (9.9)) #################################
# GLM model using R built-in functions:
GLM.british.doctors.1 <- glm(
	formula = deaths ~ offset(log(person.years)) + agecat + agesq + smoking + smkage,
	data    = DF.british.doctors,
	family  = poisson
	);
summary(GLM.british.doctors.1);

# expected values (computed from maximum likelihood estimates of model coefficients),
# (observation-wise) likelihood, Pearson residuals, and deviance residuals:
X <- model.matrix(GLM.british.doctors.1);
beta <- coefficients(GLM.british.doctors.1);
X;
beta;
cbind( X %*% beta, DF.british.doctors[,'person.years'] * exp(X %*% beta));

observed.values <- DF.british.doctors[,'deaths'];
expected.values <- fitted.values(GLM.british.doctors.1);
DF.residuals.1 <- cbind(
	observed          = observed.values,
	expected          = expected.values,
	by.hand           = DF.british.doctors[,'person.years'] * exp(X %*% beta),
	likelihood        = dpois(x=observed.values,lambda=expected.values),
	Pearson.residual  = (observed.values - expected.values) / sqrt(expected.values),
	deviance.residual = sign(observed.values - expected.values) * sqrt( 2 * (observed.values * log(observed.values/expected.values) - (observed.values - expected.values)) )
	);
DF.residuals.1;

# maximum likelihood
prod(DF.residuals.1[,'likelihood']);
log.max.likelihood.1 <- log( prod(DF.residuals.1[,'likelihood']) );
log.max.likelihood.1;

### Minimal model (i.e. intercept-only model) ######################################################
GLM.british.doctors.0 <- glm(
	formula = deaths ~ offset(log(person.years)),
	data    = DF.british.doctors,
	family  = poisson
	);
summary(GLM.british.doctors.0);

observed.values <- DF.british.doctors[,'deaths'];
expected.values <- fitted.values(GLM.british.doctors.0);
DF.residuals.0 <- cbind(
	observed          = observed.values,
	expected          = expected.values,
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
sum(DF.residuals.2[, 'Pearson.residual']^2);

# pseudo-R-squared of Saturated Model
(log.max.likelihood.0 - log.max.likelihood.2) / log.max.likelihood.0;

# likelihood ratio chi-squared statistic of Saturated Model --- method 1
2 * (log.max.likelihood.2 - log.max.likelihood.0);

# likelihood ratio chi-squared statistic of Saturated Model --- method 2
GLM.british.doctors.2$null.deviance;
GLM.british.doctors.2$deviance;
likelihood.ratio.chi.squared.statistic <- GLM.british.doctors.2$null.deviance - GLM.british.doctors.2$deviance;
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
2 * (log.max.likelihood.1 - log.max.likelihood.0);

# likelihood ratio chi-squared statistic of Model given by Eqn (9.9) --- method 2
GLM.british.doctors.1$null.deviance;
GLM.british.doctors.1$deviance;
likelihood.ratio.chi.squared.statistic <- GLM.british.doctors.1$null.deviance - GLM.british.doctors.1$deviance;
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
2 * (log.max.likelihood.0 - log.max.likelihood.0);

# likelihood ratio chi-squared statistic of Intercept-only Model --- method 2
GLM.british.doctors.0$null.deviance;
GLM.british.doctors.0$deviance;
likelihood.ratio.chi.squared.statistic <- GLM.british.doctors.0$null.deviance - GLM.british.doctors.0$deviance;
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

print("ZZZ");

