
command.arguments <- commandArgs(trailingOnly = TRUE);
output.directory  <- command.arguments[1];
code.directory    <- command.arguments[2];
tmp.directory     <- command.arguments[3];

####################################################################################################
library(faraway);
library(ggplot2);

source(paste(code.directory, "multiplot.R", sep = "/"));

### SET OUTPUT DIRECTORY ###########################################################################
setwd(output.directory);

### EXAMINE DATA SET ###############################################################################
data(sexab);

sexab[,'csa'] <- factor(x = as.character(sexab[,'csa']), levels = c('NotAbused','Abused'));

str(sexab);
summary(sexab);

by(data = sexab, INDICES = sexab[,'csa'], FUN = summary);

### DIAGNOSTIC PLOTS ###############################################################################
my.ggplot.1 <- ggplot();
my.ggplot.1 <- my.ggplot.1 + geom_boxplot(
	data    = sexab,
	mapping = aes(x = csa, y = ptsd)
	);

my.ggplot.2 <- ggplot();
my.ggplot.2 <- my.ggplot.2 + geom_point(
	data    = sexab,
	mapping = aes(x = cpa, y = ptsd, shape = csa, colour = csa)
	);

png('figure-13-02.png', width = 14, height = 6, units = 'in', res = 300);
print(multiplot(my.ggplot.1, my.ggplot.2, cols = 2));
dev.off();

####################################################################################################
sexab[,'csa'] <- relevel(x = sexab[,'csa'], ref = 'Abused');
lm.full <- lm(
	formula = ptsd ~ cpa * csa,
	data    = sexab
	);
summary(lm.full);

lm.noInteraction <- lm(
	formula = ptsd ~ cpa + csa,
	data    = sexab
	);
summary(lm.noInteraction);

####################################################################################################
my.ggplot.2 <- my.ggplot.2 + geom_abline(
	intercept = coef(lm.noInteraction)[['(Intercept)']],
	slope     = coef(lm.noInteraction)[['cpa']],
	colour    = 1
	);

my.ggplot.2 <- my.ggplot.2 + geom_abline(
	intercept = coef(lm.noInteraction)[['(Intercept)']] + coef(lm.noInteraction)[['csaNotAbused']],
	slope     = coef(lm.noInteraction)[['cpa']],
	colour    = 2
	);

DF.temp <- data.frame(
	fitted   = fitted.values(lm.noInteraction),
	residual = residuals(lm.noInteraction),
	csa      = lm.noInteraction[['model']][,'csa']
	);

my.ggplot.3 <- ggplot();
my.ggplot.3 <- my.ggplot.3 + geom_point(
	data    = DF.temp,
	mapping = aes(x = fitted, y = residual, color = csa)
	);

png('figure-13-03.png', width = 14, height = 6, units = 'in', res = 300);
print(multiplot(my.ggplot.2, my.ggplot.3, cols = 2));
dev.off();

####################################################################################################

q();

