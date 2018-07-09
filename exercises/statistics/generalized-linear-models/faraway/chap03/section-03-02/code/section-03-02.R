
command.arguments <- commandArgs(trailingOnly = TRUE);
data.directory    <- command.arguments[1];
code.directory    <- command.arguments[2];
output.directory  <- command.arguments[3];
tmp.directory     <- command.arguments[4];

####################################################################################################
library(faraway);
library(ggplot2);

#source(paste(code.directory, "bugs-chains.R", sep = "/"));
#source(paste(code.directory, "which-bugs.R",  sep = "/"));

resolution <- 100;

setwd(output.directory);

####################################################################################################
data(dicentric);

str(dicentric);
dicentric;

####################################################################################################
temp.filename <- 'figure-03-03a.png';

my.ggplot <- ggplot(data = NULL);

my.ggplot <- my.ggplot + geom_line(
	data    = dicentric,
	mapping = aes(x = doseamt, y = ca/cells, colour = factor(doserate))
	);

my.ggplot <- my.ggplot + scale_x_continuous(limits = c(0,5),   breaks = seq(0,5,1));
my.ggplot <- my.ggplot + scale_y_continuous(limits = c(0,1.6), breaks = seq(0,1.6,0.2));
my.ggplot <- my.ggplot + theme(
	title      = element_text(size = 20),
	axis.title = element_text(size = 30),
	axis.text  = element_text(size = 25)
	);

ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 6, width = 12, units = 'in');

####################################################################################################
results.lm <- lm(
	formula = ca/cells ~ log(doserate) * factor(doseamt),
	data    = dicentric
	);

summary(results.lm);

temp.filename <- 'figure-03-03b.png';

my.ggplot <- ggplot(data = NULL);

DF.temp <- data.frame(
	fitted   = fitted.values(results.lm),
	residual = residuals(results.lm, type = 'response')
	);

my.ggplot <- my.ggplot + geom_point(
	data    = DF.temp,
	mapping = aes(x = fitted, y = residual)
	);

my.ggplot <- my.ggplot + geom_abline(intercept = 0, slope = 0);

my.ggplot <- my.ggplot + scale_x_continuous(limits = c(0,1.5), breaks = seq(0,1.5,0.2));
my.ggplot <- my.ggplot + scale_y_continuous(limits = c(-0.2,0.2), breaks = seq(-0.2,0.2,0.05));
my.ggplot <- my.ggplot + theme(
	title      = element_text(size = 20),
	axis.title = element_text(size = 30),
	axis.text  = element_text(size = 25)
	);

ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 6, width = 12, units = 'in');

####################################################################################################
results.poisson <- glm(
	formula = ca ~ log(cells) + log(doserate) * factor(doseamt),
	data    = dicentric,
	family  = poisson
	);
summary(results.poisson);

results.poisson <- glm(
	formula = ca ~ offset(log(cells)) + log(doserate) * factor(doseamt),
	data    = dicentric,
	family  = poisson
	);
summary(results.poisson);

####################################################################################################

q();

