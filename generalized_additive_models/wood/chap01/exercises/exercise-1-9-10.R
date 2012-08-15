
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

q();

