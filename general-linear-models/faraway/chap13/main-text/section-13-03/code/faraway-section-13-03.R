
command.arguments <- commandArgs(trailingOnly = TRUE);
output.directory  <- command.arguments[1];
code.directory    <- command.arguments[2];
tmp.directory     <- command.arguments[3];

####################################################################################################
library(faraway);
library(ggplot2);

source(paste(code.directory, "multiplot.R",             sep = "/"));
source(paste(code.directory, "ggplot2-color-palette.R", sep = "/"));

### SET OUTPUT DIRECTORY ###########################################################################
setwd(output.directory);

### EXAMINE DATA SET ###############################################################################
data(fruitfly);

#fruitfly[,'activity'] <- C(object = fruitfly[,'activity'], contr = contr.treatment);

str(fruitfly);
summary(fruitfly);

### DIAGNOSTIC PLOTS ###############################################################################
my.ggplot.1 <- ggplot();
my.ggplot.1 <- my.ggplot.1 + geom_point(
	data    = fruitfly,
	mapping = aes(x = thorax, y = longevity, colour = activity)
	);

png('figure-13-04.png', width = 14, height = 6, units = 'in', res = 300);
multiplot(my.ggplot.1, cols = 1);
dev.off();

####################################################################################################
lm.interaction <- lm(
	formula   = longevity ~ thorax * activity,
	data      = fruitfly,
	#contrasts = list(activity = "contr.helmert")
	);
summary(lm.interaction);

coeff.lm.interaction <- coef(lm.interaction);

intercept.isolated <- coeff.lm.interaction['(Intercept)'];
slope.isolated     <- coeff.lm.interaction['thorax'];

intercept.one <- coeff.lm.interaction['(Intercept)'] + coeff.lm.interaction['activityone'];
slope.one     <- coeff.lm.interaction['thorax']      + coeff.lm.interaction['thorax:activityone'];

intercept.low <- coeff.lm.interaction['(Intercept)'] + coeff.lm.interaction['activitylow'];
slope.low     <- coeff.lm.interaction['thorax']      + coeff.lm.interaction['thorax:activitylow'];

intercept.many <- coeff.lm.interaction['(Intercept)'] + coeff.lm.interaction['activitymany'];
slope.many     <- coeff.lm.interaction['thorax']      + coeff.lm.interaction['thorax:activitymany'];

intercept.high <- coeff.lm.interaction['(Intercept)'] + coeff.lm.interaction['activityhigh'];
slope.high     <- coeff.lm.interaction['thorax']      + coeff.lm.interaction['thorax:activityhigh'];

plot.colours <- ggplot.color.palette(5);
my.ggplot.2 <- my.ggplot.1;
my.ggplot.2 <- my.ggplot.2 + geom_abline(intercept = intercept.isolated, slope = slope.isolated, color = plot.colours[1]);
my.ggplot.2 <- my.ggplot.2 + geom_abline(intercept = intercept.one,      slope = slope.one,      color = plot.colours[2]);
my.ggplot.2 <- my.ggplot.2 + geom_abline(intercept = intercept.low,      slope = slope.low,      color = plot.colours[3]);
my.ggplot.2 <- my.ggplot.2 + geom_abline(intercept = intercept.many,     slope = slope.many,     color = plot.colours[4]);
my.ggplot.2 <- my.ggplot.2 + geom_abline(intercept = intercept.high,     slope = slope.high,     color = plot.colours[5]);
png('figure-13-04-A.png', width = 14, height = 6, units = 'in', res = 300);
multiplot(my.ggplot.2, cols = 1);
dev.off();

####################################################################################################
#model.matrix(lm.interaction);
temp <- C(object = fruitfly[,'activity'], contr = contr.helmert);
str(temp);

str(fruitfly[,'activity']);

####################################################################################################
anova(lm.interaction);

####################################################################################################
lm.noInteraction <- lm(
	formula   = longevity ~ thorax + activity,
	data      = fruitfly
	);
summary(lm.noInteraction);

####################################################################################################
coeff.lm.noInteraction <- coef(lm.noInteraction);

intercept.isolated <- coeff.lm.interaction['(Intercept)'];
slope.isolated     <- coeff.lm.interaction['thorax'];

intercept.one  <- coeff.lm.noInteraction['(Intercept)'] + coeff.lm.noInteraction['activityone'];
intercept.low  <- coeff.lm.noInteraction['(Intercept)'] + coeff.lm.noInteraction['activitylow'];
intercept.many <- coeff.lm.noInteraction['(Intercept)'] + coeff.lm.noInteraction['activitymany'];
intercept.high <- coeff.lm.noInteraction['(Intercept)'] + coeff.lm.noInteraction['activityhigh'];

plot.colours <- ggplot.color.palette(5);
my.ggplot.3 <- my.ggplot.1;
my.ggplot.3 <- my.ggplot.3 + geom_abline(intercept = intercept.isolated, slope = slope.isolated, color = plot.colours[1]);
my.ggplot.3 <- my.ggplot.3 + geom_abline(intercept = intercept.one,      slope = slope.isolated, color = plot.colours[2]);
my.ggplot.3 <- my.ggplot.3 + geom_abline(intercept = intercept.low,      slope = slope.isolated, color = plot.colours[3]);
my.ggplot.3 <- my.ggplot.3 + geom_abline(intercept = intercept.many,     slope = slope.isolated, color = plot.colours[4]);
my.ggplot.3 <- my.ggplot.3 + geom_abline(intercept = intercept.high,     slope = slope.isolated, color = plot.colours[5]);
png('figure-13-04-B.png', width = 14, height = 6, units = 'in', res = 300);
multiplot(my.ggplot.3, cols = 1);
dev.off();

####################################################################################################
anova(
	lm(formula = longevity ~ activity,          data = fruitfly),
	lm(formula = longevity ~ thorax + activity, data = fruitfly)
	);

anova(
	lm(formula = longevity ~ thorax,            data = fruitfly),
	lm(formula = longevity ~ activity + thorax, data = fruitfly)
	);

####################################################################################################
DF.temp <- data.frame(
	fitted   = fitted(lm.noInteraction),
	residual = residuals(lm.noInteraction),
	activity = lm.noInteraction[['model']][,'activity']
	);

my.ggplot.4 <- ggplot();
my.ggplot.4 <- my.ggplot.4 + geom_point(
	data    = DF.temp,
	mapping = aes(x = fitted, y = residual, colour = activity)
	);

lm.logTransformed <- lm(
	formula = log(longevity) ~ thorax + activity,
	data    = fruitfly
	)

DF.temp <- data.frame(
	fitted   = fitted(lm.logTransformed),
	residual = residuals(lm.logTransformed),
	activity = lm.logTransformed[['model']][,'activity']
	);

my.ggplot.5 <- ggplot();
my.ggplot.5 <- my.ggplot.5 + geom_point(
	data    = DF.temp,
	mapping = aes(x = fitted, y = residual, colour = activity)
	);

png('figure-13-05.png', width = 14, height = 6, units = 'in', res = 300);
multiplot(my.ggplot.4, my.ggplot.5, cols = 2);
dev.off();

####################################################################################################

q();

