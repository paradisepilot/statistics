
data(warpbreaks);
str(warpbreaks);
summary(warpbreaks);


### ~~~~~~~~~~~~~~~~~~~~ ###
LM.warpbreaks.00 <- lm(
	formula = breaks ~ wool : tension,
	data    = warpbreaks
	);
summary(LM.warpbreaks.00);


### ~~~~~~~~~~~~~~~~~~~~ ###
LM.warpbreaks.01 <- lm(
	formula = breaks ~ wool * tension,
	data    = warpbreaks
	);
summary(LM.warpbreaks.01);


### ~~~~~~~~~~~~~~~~~~~~ ###
LM.warpbreaks.02 <- lm(
	formula = breaks ~ tension,
	data    = warpbreaks
	);
summary(LM.warpbreaks.02);


### ~~~~~~~~~~~~~~~~~~~~ ###
anova(LM.warpbreaks.01,LM.warpbreaks.02);

	# The above p-value of 0.01208 means that the difference in goodness-of-fit between the
	# tension-only model (LM.warpbreaks.02) and the wool+tension+interaction model
	# (LM.warpbreaks.01) is statistically significant.

### ~~~~~~~~~~~~~~~~~~~~ ###
pdf("warpbreaks-interaction-plot.pdf");

with(
	warpbreaks,
	{
		interaction.plot(
			response     = breaks,
			x.factor     = wool,
			trace.factor = tension
			);
		}
	);

dev.off();

