
data(cars);
str(cars);
summary(cars);


### (a) ############################################################################################
###
### The best model is LM.cars.01. See below.
###

### ~~~~~~~~~~~~~~~~~~~~ ###
LM.cars.00 <- lm(
	formula = dist ~ speed + I(speed^2),
	data    = cars
	);
summary(LM.cars.00);


### ~~~~~~~~~~~~~~~~~~~~ ###
LM.cars.01 <- lm(
	formula = dist ~ -1 + speed + I(speed^2),
	data    = cars
	);
summary(LM.cars.01);


### ~~~~~~~~~~~~~~~~~~~~ ###
LM.cars.02 <- lm(
	formula = dist ~ -1 + I(speed^2),
	data    = cars
	);
summary(LM.cars.02);


### ~~~~~~~~~~~~~~~~~~~~ ###
AIC(
	LM.cars.00,
	LM.cars.01,
	LM.cars.02
	);


### ~~~~~~~~~~~~~~~~~~~~ ###
anova(LM.cars.00,LM.cars.01);


### ~~~~~~~~~~~~~~~~~~~~ ###
anova(LM.cars.00,LM.cars.02);


### ~~~~~~~~~~~~~~~~~~~~ ###
anova(LM.cars.01,LM.cars.02);


### (b) ############################################################################################
#
# The best model from part (a) is LM.cars.01.
# In this model, the intercept term is set to zero, and the model has only the monomial terms
# (speed) and (speed^2).
# The linear term (beta1 * speed) corresponds physically to the distance travelled before the driver
# starts to react (apply brake) to the stop signal, and during this time period, the vehicle travels
# at constant speed (the speed at the moment when the stop signal is given).
# Since in general, we know that speed * duration = distance travelled, we see that the coefficient
# beta1 roughly corresponds to the average reaction time (amount of time it takes a driver to start
# to react to the stop signal).
# According to the output of the following summary() command, we see that the average
# "reaction time" is approximately
#
#      1.23903 feet/(miles per hour) = 1.23903 feet/(5280 feet per hour)
#                                    = 0.0002346648 hour
#                                    = 0.0002346648 * 3600 seconds
#                                    = 0.8447933 second.
#

summary(LM.cars.01);


### (c) ############################################################################################
#
# No, it does NOT always make sense.
# For example, LM.cars.01 fits the data a lot better than LM.cars.00 (R-squared being
# 0.9133 vs 0.6673, respectively), even though LM.cars.01 can be obtained from LM.cars.00 by
# dropping the intercept term in LM.cars.00.
#

summary(LM.cars.00);

summary(LM.cars.01);

summary(LM.cars.02);

### Appendix #######################################################################################

library(lattice);
pdf("cars.pdf");

speeds    <- seq(0:300)/10;
plot(x = c(min(cars[,'speed']),max(cars[,'speed'])), y = c(min(cars[,'dist']),max(cars[,'dist'])), type = "n");

points(x = cars[,'speed'], y = cars[,'dist'], type = "p", col = "black");

distances <- 2.47014 + 0.91329 * speeds + 0.09996 * (speeds^2);
points(x = speeds, y = distances, type = "l", col = "red");

distances <- 1.23903 * speeds + 0.09014 * (speeds^2);
points(x = speeds, y = distances, type = "l", col = "cyan3");

distances <- 0.153374 * (speeds^2);
points(x = speeds, y = distances, type = "l", col = "green");

dev.off();

q();

