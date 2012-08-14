
library(MASS);

data(Rubber);
dim(Rubber);
summary(Rubber);

### (a) ############################################################################################

# (*)  Notice how large the standard error is for (Intercept).
LM.Rubber.3rd <- lm(
   formula = loss ~ I(tens^3) + I((tens^2) * hard) + I(tens * (hard^2)) + I(hard^3) + I(tens^2) + I(tens*hard) + I(hard^2) + I(tens) + I(hard),
   data    = Rubber
   );
summary(LM.Rubber.3rd);


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
# (*)  Dropping I((tens^2) * hard).  The standard error for (Intercept) is still very large.
LM.Rubber.01 <- lm(
   formula = loss ~ I(tens^3) + I(tens * (hard^2)) + I(hard^3) + I(tens^2) + I(tens*hard) + I(hard^2) + I(tens) + I(hard),
   data    = Rubber
   );
summary(LM.Rubber.01);


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
# (*)  Dropping I(hard).  The standard error for (Intercept) is still very large.
LM.Rubber.02 <- lm(
   formula = loss ~ I(tens^3) + I(tens * (hard^2)) + I(hard^3) + I(tens^2) + I(tens*hard) + I(hard^2) + I(tens),
   data    = Rubber
   );
summary(LM.Rubber.02);


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
# (*)  Dropping I(1).
LM.Rubber.03 <- lm(
   formula = loss ~ -1 + I(tens^3) + I(tens * (hard^2)) + I(hard^3) + I(tens^2) + I(tens*hard) + I(hard^2) + I(tens),
   data    = Rubber
   );
summary(LM.Rubber.03);


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
# (*)  Dropping I(hard^2).
LM.Rubber.04 <- lm(
   formula = loss ~ -1 + I(tens^3) + I(tens * (hard^2)) + I(hard^3) + I(tens^2) + I(tens*hard) + I(tens),
   data    = Rubber
   );
summary(LM.Rubber.04);


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
AIC(
	LM.Rubber.01,
	LM.Rubber.02,
	LM.Rubber.03,
	LM.Rubber.04
	);


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
anova(LM.Rubber.04,LM.Rubber.03);
anova(LM.Rubber.04,LM.Rubber.02);
anova(LM.Rubber.04,LM.Rubber.01);


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
LM.Rubber.A <- lm(
   formula = loss ~ tens : hard,
   data    = Rubber
   );
summary(LM.Rubber.A);


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
LM.Rubber.B <- lm(
   formula = loss ~ I(tens * hard),
   data    = Rubber
   );
summary(LM.Rubber.B);


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
LM.Rubber.C <- lm(
   formula = loss ~ tens + hard + tens : hard,
   data    = Rubber
   );
summary(LM.Rubber.C);


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
LM.Rubber.D <- lm(
   formula = loss ~ tens + hard + I(tens * hard),
   data    = Rubber
   );
summary(LM.Rubber.D);


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
LM.Rubber.E <- lm(
   formula = loss ~ tens * hard,
   data    = Rubber
   );
summary(LM.Rubber.E);


q();

# (*)
LM.Rubber.2nd <- lm(
   formula = loss ~ I(tens^2) + I(tens*hard) + I(hard^2) + I(tens) + I(hard),
   data    = Rubber
   );
summary(LM.Rubber.2nd);


# (*)  This is the worst fit; look at the Adjusted R-squared value.
LM.Rubber.1st.interaction <- lm(
   formula = loss ~ tens : hard,
   data    = Rubber
   );
summary(LM.Rubber.1st.interaction);


# (*)
LM.Rubber.1st.interaction <- lm(
   formula = loss ~ tens * hard,
   data    = Rubber
   );
summary(LM.Rubber.1st.interaction);


# (*)
LM.Rubber.1st <- lm(
   formula = loss ~ tens + hard,
   data    = Rubber
   );
summary(LM.Rubber.1st);

anova(LM.Rubber.2nd,LM.Rubber.3rd);
anova(LM.Rubber.1st,LM.Rubber.2nd);
anova(LM.Rubber.1st,LM.Rubber.3rd);

