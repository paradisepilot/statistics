
# data
DF.car.journeys <- data.frame(
	distance = c(  1,   3,   4,   5),
	duration = c(0.1, 0.4, 0.5, 0.6)
	);
DF.car.journeys;

### USING lm #######################################################################################
# with intercept term
LM.car.journeys <- lm(
	formula = distance ~ duration,
	data    = DF.car.journeys,
   );
summary(LM.car.journeys);

# without intercept term
LM.car.journeys <- lm(
	formula = distance ~ -1 + duration,
	data    = DF.car.journeys,
   );
summary(LM.car.journeys);

### HAND CALCULATION ###############################################################################
# observed data
y <- DF.car.journeys[,'distance'];
y;

# model matrix
X <- matrix(
	data = c(rep(1,nrow(DF.car.journeys)),DF.car.journeys[,'duration']),
	nrow = nrow(DF.car.journeys),
	ncol = 2
	);
X;

beta_hat <- solve(t(X) %*% X) %*% (t(X) %*% y);
beta_hat;

# model.matrix(LM.car.journeys);
