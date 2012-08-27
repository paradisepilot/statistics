
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

# Pearson chi-squared statistic
sum(DF.residuals.1[, 'Pearson.residual']^2);

# deviance
sum(DF.residuals.1[,'deviance.residual']^2);

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

# likelihood ratio chi-squared statistic (method 1)
2 * (log.max.likelihood.1 - log.max.likelihood.0);

# likelihood ratio chi-squared statistic (method 2)
GLM.british.doctors.1$null.deviance;
GLM.british.doctors.1$deviance;
likelihood.ratio.chi.squared.statistic <- GLM.british.doctors.1$null.deviance - GLM.british.doctors.1$deviance;
likelihood.ratio.chi.squared.statistic;

# pseudo-R-squared
(log.max.likelihood.0 - log.max.likelihood.1) / log.max.likelihood.0;

